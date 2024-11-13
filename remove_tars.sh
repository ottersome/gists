#!/bin/bash
# Define the directory to search. You can change this to any directory you want.
SEARCH_DIR="."
# Use the find command to locate all files named khompressed_.tar.gz and process them
find "$SEARCH_DIR" -type f -name "khompressed_.tar.gz" | while read -r file; do
    echo "Removing: $file"
    rm "$file"
done
echo "All specified files have been removed."
