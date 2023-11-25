#!/bin/bash

# Check if an issue number is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <issue-number>"
    exit 1
fi

ISSUE_NUMBER=$1
ISSUE_TITLE="Issue Title for $ISSUE_NUMBER" # Modify as needed

# Load environment variables from .env file
if [ ! -f ".env" ]; then
    echo ".env file not found"
    exit 1
fi

source .env

# Check if required tokens are set
if [ -z "$GITHUB_TOKEN" ] || [ -z "$OPENAI_API_KEY" ]; then
    echo "Required tokens not set in .env file"
    exit 1
fi

# Set additional environment variables
export GITHUB_REPOSITORY="m-c-frank/justthoughts" # Replace with your GitHub repository
export GITHUB_ACTOR="m-c-frank" # Replace with your GitHub username

# Run the workflow with act, passing issue number and title
act -P ubuntu-latest=catthehacker/ubuntu:act-latest -j generate-blog-post \
    -s GITHUB_TOKEN="$GITHUB_TOKEN" \
    -s OPENAI_API_KEY="$OPENAI_API_KEY" \
    -e <(echo '{"issue": {"number": '"$ISSUE_NUMBER"', "title": "'"$ISSUE_TITLE"'"}}')

