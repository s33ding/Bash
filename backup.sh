#!/bin/bash

# Define the list of files to move
file_list=(
    $AWS_DEFAULT_FOLDER \
    $MY_BASHRC \
    $MY_VIMRC \
    $BITBUCKET \
    $DOCUMENTS \
    $DOWNLOADS \
    $GITHUB \
    $PICTURES \
    $TESTE_FOLDER \
    $VIDEOS \
    $VS_CODE_FOLDER \
    $MUSIC \
    $BINARY_HOUSE
)


for file in "${file_list[@]}"
do
    echo $file
done 

# Get the current date
date=$(date +%Y-%m-%d)

# Create a directory with the current date

mkdir $BACKUP_DRIVER/$date
chmod +w $BACKUP_DRIVER/$date

# Loop through the list of files and move them to the current date directory
for file in "${file_list[@]}"
do
    echo "COPYING: $file"
    cp $file $BACKUP_DRIVER/$date/ -r
done 
