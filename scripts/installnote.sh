#!/bin/bash

# Usage check and directory existence check
[ "$#" -ne 1 ] || [ ! -d "$1" ] && echo "Usage: $0 path/to/directory" && exit 1

# Create a temporary copy of createnote.sh
temp_file=$(mktemp)
cp createnote.sh "$temp_file"

# Updating REPO_DIR in the temporary file
sed -i "s|REPO_DIR=.*|REPO_DIR=$1|" "$temp_file"

# Move the temporary file to the user's path
chmod +x "$temp_file"
mv "$temp_file" "$HOME/.local/bin/createnote"

echo "Setup complete. Use 'createnote' to create a new note."
