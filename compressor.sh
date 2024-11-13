#!/bin/bash

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
    local dir="$1"
    echo "Compressing directory: $dir"
    tar -czf "$dir.$ARCHIVE_FORMAT" -C "$dir" . && rm -rf "$dir"
    echo "Directory $dir replaced with $dir.$ARCHIVE_FORMAT"
}

# Traverse the directory structure, excluding directories already containing .tar.gz files
find "$TARGET_DIR" -type d \( ! -name "*.$ARCHIVE_FORMAT" \) | while read -r dir; do
    # Skip if a .tar.gz file already exists for this directory
    if [[ -f "$dir.$ARCHIVE_FORMAT" ]]; then
        continue
    fi
    
    # Count the number of items and the number of small files in the directory
    item_count=$(find "$dir" -mindepth 1 -maxdepth 1 | wc -l)
    small_file_count=$(find "$dir" -type f -size -"${SIZE_THRESHOLD}"k | wc -l)
    
    # Check if the directory has too many small items
    if [[ $item_count -ge $ITEM_THRESHOLD && $small_file_count -ge $((ITEM_THRESHOLD / 2)) ]]; then
        compress_folder "$dir"
    fi
done

