#!/bin/bash

# Define the list of files to move
file_list=(
    $ADM \
    $AWS_DEFAULT_FOLDER \
    $BASH_SCRIPTS \
    $BITBUCKET \
    $DOCUMENTS \
    $DOWNLOADS \
    $FEDORA \
    $GITHUB \
    $IPYTHON \
    $MY_BASHRC \
    $MYSCRIPTS \
    $MY_VIMRC \
    $PICTURES \
    $TESTE_FOLDER \
    $VIDEOS \
    $VS_CODE_FOLDER \
    $MUSIC
)


for file in "${file_list[@]}"
do
    echo $file
done 

# Get the current date
date=$(date +%Y-%m-%d)

# Create a directory with the current date
rm -r $date -f
mkdir $date
chmod +w $date

# Loop through the list of files and move them to the current date directory
for file in "${file_list[@]}"
do
    echo "COPYING: $file"
    cp $file $date -r
done 
