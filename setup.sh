#!/bin/bash

echo "Set array"
# Initialize an empty array to hold all repository names
all_repos=()

echo "Fetch repos"
# Fetch repositories
repos=$(gh repo list solrey3 --json name --jq '.[].name' --limit 100)
if [ -z "$repos" ]; then
  echo "No repositories found."
else
  all_repos=($repos)
fi

echo "Repositories fetched: ${#all_repos[@]}"

echo "Add submodules"
# Filter and add the repositories as submodules
for repo in "${all_repos[@]}"; do
  echo "Processing repo: $repo"
  # Check if the repository name matches the desired patterns
  if [[ "$repo" =~ (-challenge|-Challenge|Project) ]]; then
    # Check if the submodule already exists
    if [ -d "$repo" ]; then
      echo "Submodule $repo already exists, skipping"
      continue
    fi
    # Add the repository as a submodule
    git submodule add https://github.com/solrey3/$repo.git $repo
  fi
done

echo "Update submodules"
# Initialize and update submodules
git submodule update --init --recursive

echo "Commit"
# Commit the changes
git add .
git commit -m "Added challenge and project repositories as submodules"
git push origin main
