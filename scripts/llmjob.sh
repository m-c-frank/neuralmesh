#!/bin/bash

# Variables
ISSUE_NUMBER=$1
REPO_NAME=justthoughts
REPO_OWNER=m-c-frank

echo "$ISSUE_NUMBER"
echo "$REPO_NAME"
echo "$REPO_OWNER"
echo "test"

ISSUE_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/${ISSUE_NUMBER}"

echo "$ISSUE_URL"

# Authenticate with GitHub CLI using GH_PAT
echo "$GH_PAT" | gh auth login --with-token

# Fetch Issue Data
echo "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/${ISSUE_NUMBER}"
curl "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/${ISSUE_NUMBER}" > issue_details.json

mkdir scripts
echo "https://raw.githubusercontent.com/m-c-frank/justthoughts/scripts/llmjob.py"
curl -o scripts/llmjob.py "https://raw.githubusercontent.com/m-c-frank/justthoughts/scripts/llmjob.py"

cat scripts/llmjob.py

pip install openai
pip install langchain

python scripts/llmjob.py issue_details.json

