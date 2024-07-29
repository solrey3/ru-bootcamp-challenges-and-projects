#!/bin/bash

# Initialize an empty array to hold all repository names
all_repos=()

# Fetch repositories page by page
page=1
while true; do
  repos=$(gh repo list solrey3 --json name --jq '.[].name' --page $page --limit 100)
  if [ -z "$repos" ]; then
    break
  fi
  all_repos+=($repos)
  ((page++))
done

# Filter and add the repositories as submodules
for repo in "${all_repos[@]}"; do
  # Check if the repository name matches the desired patterns
  if [[ "$repo" =~ (-challenge|-Challenge|Project) ]]; then
    # Skip the excluded repositories
    if [[ " ${EXCLUDE_REPOS[@]} " =~ " ${repo} " ]]; then
      echo "Skipping $repo"
      continue
    fi

    # Check if the submodule already exists
    if [ -d "$repo" ]; then
      echo "Submodule $repo already exists, skipping"
      continue
    fi

    # Add the repository as a submodule
    git submodule add https://github.com/solrey3/$repo.git $repo
  fi
done

# Initialize and update submodules
git submodule update --init --recursive

# Commit the changes
git add .
git commit -m "Added challenge and project repositories as submodules"
git push origin main
