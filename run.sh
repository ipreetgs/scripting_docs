#!/bin/bash

# Directory path

directory="test/"

# Iterate over the files in the directory
for file in "$directory"*
do
  # Check if the current item is a file
  if [ -f "$file" ]; then
    echo "Processing file: $file"
    inp=$(echo $file | awk '{gsub("test/", "");print}')
    out=$(echo "$inp" | awk -F"." '{ $NF = "mp4"; print $0 }' OFS=".")
    # Perform operations on the file here

    ffmpeg -i "$file" ot/"$out"
    echo "-----------------"
  fi
done
