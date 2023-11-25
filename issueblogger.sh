#!/bin/bash

# Variables
ISSUE_NUMBER=$1
REPO_NAME=$(basename $(git remote get-url origin) .git)
REPO_OWNER=$(basename $(dirname $(git remote get-url origin)))
BRANCH_NAME="${ISSUE_NUMBER}-issueblogger"

# Authenticate with GitHub CLI using GH_PAT
echo "$GH_PAT" | gh auth login --with-token

# Fetch Issue Data
curl "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/${ISSUE_NUMBER}" > issue_details.json
curl "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/${ISSUE_NUMBER}/comments" > issue_comments.json
echo '{"issue_data":' > issue_data.json
cat issue_details.json >> issue_data.json
echo ',"comments":' >> issue_data.json
cat issue_comments.json >> issue_data.json
echo '}' >> issue_data.json

# Generate Content
python scripts/issueblogger.py issue_data.json

# Git Configuration
git config user.name 'github-actions'
git config user.email 'github-actions@github.com'

# Git Operations
git fetch
git checkout main
git pull origin main
git checkout -b "$BRANCH_NAME" || git checkout "$BRANCH_NAME"
git add ./blog/"${ISSUE_NUMBER}-new-post.md"
git commit -m "Add new blog post for issue #${ISSUE_NUMBER}"
git push -u origin "$BRANCH_NAME"

# Create Pull Request
gh pr create --base main --title "New Blog Post: Issue #${ISSUE_NUMBER}" --body "This pull request contains the blog post content for Issue #${ISSUE_NUMBER}" --head "$BRANCH_NAME"
