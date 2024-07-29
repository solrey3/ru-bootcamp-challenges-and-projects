#!/bin/bash

# List of repositories to exclude

# Get list of repositories to add as submodules
repos=$(gh repo list solrey3 --json name --jq '.[].name' | grep -E '(-challenge|-Challenge|Project)')

for repo in $repos; do
  # Add the repository as a submodule
  git submodule add https://github.com/solrey3/$repo.git $repo
done

# Initialize and update submodules
git submodule update --init --recursive

# Commit the changes
git add .
git commit -m "Added challenge and project repositories as submodules"
git push origin main
