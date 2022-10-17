#!/bin/bash

## Script to automize universal steps for making assessment: #################################
# Ask user for project name:
echo Set project name:
read PROJECT_NAME
# Export environment variable:
export PROJECT_NAME
# Initialize new project in poetry:
poetry new $PROJECT_NAME
# cd into new directory:
cd $PROJECT_NAME
# Always required:
poetry add pandas
poetry add ipykernel --group dev

# Set python location to .venv location:
VENV=$(poetry env info -p)
VENV="${VENV/"/home/vscode"/"~"}"
touch analysis.ipynb
export VENV
cd ..

# Start git repository: ###########################################################################
# Login to github:
gh auth login

# Create repository:
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /user/repos \
  -f name=$PROJECT_NAME \
 -f description='Repository for '$PROJECT_NAME \
 -f homepage='https://github.com' \
 -F private=false \
 -F is_template=true 

# Perform first commit:
git config --global --add safe.directory $PWD
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin "https://github.com/(gh api user | jq -r '.login')/${PROJECT_NAME}.git"
git push -u origin main

# Display location of virtual environment: ####################################################
echo Poetry .venv location:
echo $VENV