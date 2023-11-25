#!/bin/bash

# Configuration
REPO_DIR=./
BLOG_DIR=$REPO_DIR/blog
EDITOR=nvim

# Fetch GitHub user details using GitHub CLI
GIT_USERNAME=$(gh api user --jq .login)
GIT_USER_NAME=$(gh api user --jq .name)
GIT_USER_URL=$(gh api user --jq .html_url)
GIT_USER_IMAGE_URL="$GIT_USER_URL.png"

# Ensure GitHub username was fetched
if [ -z "$GIT_USERNAME" ]; then
    echo "Failed to fetch GitHub username. Ensure you're logged in with 'gh auth login'."
    exit 1
fi

# Check if the blog directory exists
if [ ! -d "$BLOG_DIR" ]; then
    echo "Blog directory not found. Please check the BLOG_DIR path."
    exit 1
fi

# Generate a filename with the current date and time
FILENAME=$(date +"%Y-%m-%d-%H-%M-%S")-note.md
FULL_PATH=$BLOG_DIR/$FILENAME

# Create a new blog post file with dynamic author content
cat > $FULL_PATH << EOF
---
title: 'New Note $(date +"%Y-%m-%d %H:%M:%S")'
author: '$GIT_USER_NAME'
author_title: 'Contributor at GitHub'
author_url: $GIT_USER_URL
author_image_url: $GIT_USER_IMAGE_URL
tags: [note]
---

Your note starts here...
EOF

# Open the file in the editor
$EDITOR $FULL_PATH

# Check if the file was modified
if [ ! -s $FULL_PATH ]; then
    echo "No changes made to the note. Exiting."
    exit 0
fi

# Navigate to the repo
cd $REPO_DIR

# Add, commit, and push changes
git add $FULL_PATH
git commit -m "Added new note: $FILENAME by $GIT_USER_NAME"
git push

