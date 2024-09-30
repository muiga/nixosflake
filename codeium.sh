#!/bin/bash

# Variables
PARENT_DIR="$HOME/.local/share/JetBrains" # Change to the parent directory
FILENAME="language_server_linux_x64"             # File to search for
LINK_TARGET="$(which codeium_language_server)"     # File to create symbolic link to

# Flag to check if any files were found
found_any_files=false

# Find the file in all subdirectories of the parent directory
find "$PARENT_DIR" -type f -name "$FILENAME" | while read -r filepath; do
    found_any_files=true
    dir=$(dirname "$filepath") # Get the directory of the file
    
    echo "File found: $filepath"
    
    # Delete the file
    rm "$filepath"
    echo "Deleted $FILENAME in $dir"
    
    # Create the symbolic link
    ln -s "$LINK_TARGET" "$filepath"
    echo "Created symbolic link to $LINK_TARGET in $dir"
done

# If no files were found, echo "not found"
if [ "$found_any_files" = false ]; then
    echo "No $FILENAME found in any subdirectories of $PARENT_DIR"
fi
