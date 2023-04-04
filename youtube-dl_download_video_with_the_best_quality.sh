#!/bin/bash

# Ask the user for the video URL
read -p "Enter the YouTube video URL: " video_url

# Download the video in the best available quality up to 1080p
youtube-dl -f 'bestvideo[height<=1080]+bestaudio/best' $video_url

