#!/bin/bash
# Directory to start searching from
TARGET_DIR="$1"
# Threshold for number of items in a directory to consider compressing
ITEM_THRESHOLD=100
# Minimum size (in KB) of files to consider small
SIZE_THRESHOLD=1000
# Archive format (you can change it to zip or another format if desired)
ARCHIVE_FORMAT="tar.gz"
if [[ -z "$TARGET_DIR" ]]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi
# Function to compress the folder and remove the original
compress_folder() {
    # Make sure this directory still exists
    local dir_to_compress="$1"
    local compressed_path=$(dirname "$dir_to_compress")
    local compressed_basename=$(basename "$dir_to_compress")
    local new_base_name="khompressed_${compressed_basename}.tar.gz"
    local new_file_path="$compressed_path/$new_base_name"
    tar -czf "$new_file_path" -C "$dir_to_compress" . && rm -rf "$dir_to_compress"
    echo "Directory $dir_to_compress replaced with ${new_file_path}"
}
# Get the total number of directories to process
total_dirs=$(find "$TARGET_DIR" -type d \( ! -name "*.$ARCHIVE_FORMAT" \) | wc -l)
processed_dirs=0
last_reported_percentage=0
# Traverse the directory structure, excluding directories already containing .tar.gz files
find "$TARGET_DIR" -type d \( ! -name "*.$ARCHIVE_FORMAT" \) | while read -r dir; do
    # Skip if a .tar.gz file already exists for this directory
    if [[ -f "$dir.$ARCHIVE_FORMAT" ]]; then
        continue
    fi
    # Check if $dir still exists (it might have been tarred already)
    if [[ ! -d "$dir" ]]; then
        continue
    fi
    
    # Count the number of items and the number of small files in the directory
    item_count=$(find "$dir" -mindepth 1 -maxdepth 1 | wc -l)
    small_file_count=$(find "$dir" -type f -size -"${SIZE_THRESHOLD}"k | wc -l)
    
    # Check if the directory has too many small items
    if [[ $item_count -ge $ITEM_THRESHOLD && $small_file_count -ge $((ITEM_THRESHOLD / 2)) ]]; then
        compress_folder "$dir"
    fi
    # Update and display progress
    processed_dirs=$((processed_dirs + 1))
    progress_percentage=$((processed_dirs * 100 / total_dirs))
    
    if [[ $progress_percentage -gt $last_reported_percentage ]]; then
        echo "Progress: $progress_percentage% ($processed_dirs/$total_dirs directories processed)"
        last_reported_percentage=$progress_percentage
    fi
done
