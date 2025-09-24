#!/usr/bin/env python3
import streamlit as st
import boto3
import pandas as pd
import os

@st.cache_data
def load_data():
    session = boto3.Session(profile_name='s33ding')
    dynamodb = session.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('bashrc')
    response = table.scan()
    df = pd.DataFrame(response['Items'])
    
    # Add subgroup column if it doesn't exist
    if 'subgroup' not in df.columns:
        df['subgroup'] = 'general'
    
    # Add deprecated column if it doesn't exist
    if 'deprecated' not in df.columns:
        df['deprecated'] = False
    
    # Remove duplicates based on cmd column, keep first occurrence
    df = df.drop_duplicates(subset=['cmd'], keep='first')
    
    return df

def save_changes(df):
    session = boto3.Session(profile_name='s33ding')
    dynamodb = session.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('bashrc')
    
    with table.batch_writer() as batch:
        for _, row in df.iterrows():
            item = {
                'id': str(row.get('id', row['cmd'])),
                'cmd': str(row['cmd']),
                'kind': str(row['kind']),
                'group': str(row['group']),
                'subgroup': str(row.get('subgroup', 'general')),
                'deprecated': bool(row.get('deprecated', False))
            }
            batch.put_item(Item=item)

st.set_page_config(layout="wide")

# Create tabs
tab1, tab2 = st.tabs(["Commands", "Style"])

with tab1:
    st.title("Bashrc Commands Manager")

    # Add new command form
    st.header("Add New Command")
    with st.form("add_command"):
        col1, col2, col3, col4 = st.columns(4)
        with col1:
            new_cmd = st.text_input("Command")
        with col2:
            new_kind = st.selectbox("Kind", ["alias", "export", "function"])
        with col3:
            new_group = st.text_input("Group")
        with col4:
            new_subgroup = st.text_input("Subgroup", value="general")
        
        if st.form_submit_button("Add Command", type="primary"):
            if new_cmd and new_group:
                session = boto3.Session(profile_name='s33ding')
                dynamodb = session.resource('dynamodb', region_name='us-east-1')
                table = dynamodb.Table('bashrc')
                
                item = {
                    'id': new_cmd,
                    'cmd': new_cmd,
                    'kind': new_kind,
                    'group': new_group,
                    'subgroup': new_subgroup,
                    'deprecated': False
                }
                table.put_item(Item=item)
                st.cache_data.clear()
                st.success("Command added successfully!")
                st.rerun()
            else:
                st.error("Command and Group are required!")

    # Load data
    df = load_data()

    # Search
    st.markdown("""
    <style>
    .stTextInput > div > div > input {
        font-size: 18px;
        height: 50px;
    }
    </style>
    """, unsafe_allow_html=True)
    search = st.text_input("Search", key="search_input")

    # Auto-focus script
    st.markdown("""
    <script>
    window.addEventListener('load', function() {
        setTimeout(function() {
            const inputs = window.parent.document.querySelectorAll('input[aria-label="Search"]');
            if (inputs.length > 0) {
                inputs[0].focus();
            }
        }, 500);
    });
    </script>
    """, unsafe_allow_html=True)

    # Sidebar filters
    st.sidebar.header("Filters")
    kinds = st.sidebar.multiselect("Kind", df['kind'].unique(), default=df['kind'].unique())
    groups = st.sidebar.multiselect("Group", df['group'].unique(), default=df['group'].unique())
    subgroups = st.sidebar.multiselect("Subgroup", df['subgroup'].unique(), default=df['subgroup'].unique())

    # Sort options
    st.sidebar.header("Sort")
    sort_by = st.sidebar.selectbox("Sort by", ["cmd", "kind", "group", "subgroup"])
    sort_order = st.sidebar.radio("Order", ["Ascending", "Descending"])

    # Filter data
    filtered_df = df[df['kind'].isin(kinds) & df['group'].isin(groups) & df['subgroup'].isin(subgroups)]
    if search:
        filtered_df = filtered_df[filtered_df['cmd'].str.contains(search, case=False, na=False)]

    # Sort data
    ascending = sort_order == "Ascending"
    filtered_df = filtered_df.sort_values(by=sort_by, ascending=ascending)

    # Display metrics
    col1, col2, col3 = st.columns(3)
    col1.metric("Total", len(df))
    col2.metric("Filtered", len(filtered_df))
    col3.metric("Groups", df['group'].nunique())

    # Editable dataframe
    st.header("Commands")
    edited_df = st.data_editor(
        filtered_df[['cmd', 'kind', 'group', 'subgroup', 'deprecated']],
        use_container_width=True,
        num_rows="dynamic",
        height=600,
        column_config={
            "cmd": st.column_config.TextColumn("Command", width="medium"),
            "kind": st.column_config.SelectboxColumn("Kind", options=["alias", "export", "function"], width="small"),
            "group": st.column_config.TextColumn("Group", width="small"),
            "subgroup": st.column_config.TextColumn("Subgroup", width="small"),
            "deprecated": st.column_config.CheckboxColumn("Deprecated", width="small")
        },
        hide_index=True
    )

    # Generate bashrc content
    bashrc_content = ""
    kind_order = ['export', 'alias', 'function']

    # Filter out deprecated items
    active_df = df[df['deprecated'] != True]

    for kind in kind_order:
        if kind not in active_df['kind'].values:
            continue
        kind_df = active_df[active_df['kind'] == kind]
        bashrc_content += f"\n#{'='*60}\n"
        bashrc_content += f"# {kind.upper()}\n"
        bashrc_content += f"#{'='*60}\n"
        
        for group in kind_df['group'].unique():
            group_df = kind_df[kind_df['group'] == group]
            bashrc_content += f"\n#{'-'*30}\n"
            bashrc_content += f"# {group}\n"
            bashrc_content += f"#{'-'*30}\n"
            
            for subgroup in group_df['subgroup'].unique():
                subgroup_df = group_df[group_df['subgroup'] == subgroup]
                if subgroup != 'general':
                    bashrc_content += f"\n# {subgroup}\n"
                
                for _, row in subgroup_df.iterrows():
                    bashrc_content += f"{row['cmd']}\n"

    # Buttons
    col1, col2, col3, col4 = st.columns(4)
    with col1:
        if st.button("Save Changes", type="primary"):
            # Find changes by comparing with original data
            changes = edited_df.compare(filtered_df[['cmd', 'kind', 'group', 'subgroup', 'deprecated']])
            if not changes.empty:
                # Get changed rows and merge with original data to get id field
                changed_indices = changes.index.unique()
                changed_df = edited_df.loc[changed_indices].copy()
                
                # Add id field from original data
                for idx in changed_indices:
                    if idx in df.index and 'id' in df.columns:
                        changed_df.loc[idx, 'id'] = df.loc[idx, 'id']
                    else:
                        changed_df.loc[idx, 'id'] = changed_df.loc[idx, 'cmd']
                
                save_changes(changed_df)
                st.cache_data.clear()
                st.success(f"Saved {len(changed_df)} changes!")
            else:
                st.info("No changes to save.")
            st.rerun()

    with col2:
        if st.button("Delete Deprecated", type="secondary"):
            session = boto3.Session(profile_name='s33ding')
            dynamodb = session.resource('dynamodb', region_name='us-east-1')
            table = dynamodb.Table('bashrc')
            
            deprecated_items = df[df['deprecated'] == True]
            if not deprecated_items.empty:
                with table.batch_writer() as batch:
                    for _, row in deprecated_items.iterrows():
                        batch.delete_item(Key={'id': str(row.get('id', row['cmd']))})
                st.cache_data.clear()
                st.success(f"Deleted {len(deprecated_items)} deprecated items!")
                st.rerun()
            else:
                st.info("No deprecated items to delete.")

    with col3:
        if st.button("Save to ~/.bashrc", type="secondary"):
            bashrc_path = "/home/roberto/.bashrc"
            try:
                with open(bashrc_path, 'r') as f:
                    current_content = f.read()
                
                # Find markers and replace content between them
                start_marker = "# AUTO-GENERATED COMMANDS START"
                end_marker = "# AUTO-GENERATED COMMANDS END"
                
                if start_marker in current_content and end_marker in current_content:
                    before = current_content.split(start_marker)[0]
                    after = current_content.split(end_marker)[1]
                    new_content = f"{before}{start_marker}\n{bashrc_content}{end_marker}{after}"
                else:
                    new_content = f"{current_content}\n\n{start_marker}\n{bashrc_content}{end_marker}\n"
                
                with open(bashrc_path, 'w') as f:
                    f.write(new_content)
                
                st.success("Bashrc updated successfully!")
            except Exception as e:
                st.error(f"Error updating bashrc: {e}")

    with col4:
        if st.button("Backup to S3", type="secondary"):
            s3_path = os.getenv('BASHRC_S3')
            if s3_path:
                try:
                    bucket, key = s3_path.replace('s3://', '').split('/', 1)
                    session = boto3.Session(profile_name='s33ding')
                    s3 = session.client('s3')
                    s3.put_object(Bucket=bucket, Key=key, Body=bashrc_content)
                    st.success("Bashrc backed up to S3!")
                except Exception as e:
                    st.error(f"S3 backup failed: {e}")
            else:
                st.error("BASHRC_S3 environment variable not set")

    # Display generated bashrc
    st.header("Generated Bashrc")
    st.info("💡 Commands will be saved between `# AUTO-GENERATED COMMANDS START` and `# AUTO-GENERATED COMMANDS END` markers in your ~/.bashrc file, preserving existing content.")

    # Check for syntax errors in generated content
    import subprocess
    import tempfile

    try:
        with tempfile.NamedTemporaryFile(mode='w', suffix='.sh', delete=False) as f:
            f.write(bashrc_content)
            temp_file = f.name
        
        result = subprocess.run(['bash', '-n', temp_file], capture_output=True, text=True)
        if result.returncode == 0:
            st.success("✅ No syntax errors found")
        else:
            st.error("❌ Syntax errors found:")
            st.code(result.stderr, language='bash')
    except Exception as e:
        st.warning(f"Could not check syntax: {e}")

    # Show bashrc with line numbers
    lines = bashrc_content.split('\n')
    numbered_content = '\n'.join([f"{i+1:3}: {line}" for i, line in enumerate(lines)])
    st.code(numbered_content, language='bash')

with tab2:
    st.title("Shell Style Manager")
    
    # Load current style from ~/.bashrc
    bashrc_path = "/home/roberto/.bashrc"
    start_marker = "# AUTO-GENERATED STYLE START"
    end_marker = "# AUTO-GENERATED STYLE END"
    
    try:
        with open(bashrc_path, 'r') as f:
            content = f.read()
        
        if start_marker in content and end_marker in content:
            current_style = content.split(start_marker)[1].split(end_marker)[0].strip()
        else:
            current_style = ""
    except:
        current_style = ""
    
    # Style editor
    edited_style = st.text_area("Shell Style", value=current_style, height=400, help="Add your shell customizations here")
    
    if st.button("Save & Sync", type="primary"):
        try:
            # Save to ~/.bashrc
            with open(bashrc_path, 'r') as f:
                current_content = f.read()
            
            if start_marker in current_content and end_marker in current_content:
                before = current_content.split(start_marker)[0]
                after = current_content.split(end_marker)[1]
                new_content = f"{before}{start_marker}\n{edited_style}\n{end_marker}{after}"
            else:
                new_content = f"{current_content}\n\n{start_marker}\n{edited_style}\n{end_marker}\n"
            
            with open(bashrc_path, 'w') as f:
                f.write(new_content)
            
            # Sync to S3 using the same profile as the main app
            s3_path = os.getenv('BASHRC_STYLE_S3')
            if s3_path:
                try:
                    bucket, key = s3_path.replace('s3://', '').split('/', 1)
                    session = boto3.Session(profile_name='s33ding')
                    s3 = session.client('s3')
                    s3.put_object(Bucket=bucket, Key=key, Body=edited_style)
                    st.success("Style saved to ~/.bashrc and synced to S3!")
                except Exception as s3_error:
                    st.error(f"Style saved to ~/.bashrc but S3 sync failed: {s3_error}")
            else:
                st.error("BASHRC_STYLE_S3 environment variable not set")
            st.rerun()
        except Exception as e:
            st.error(f"Error: {e}")
