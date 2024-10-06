#!/usr/bin/env sh

# Usage: ./reorder_file_changes.sh <file1> <file2> ...

# Check if at least one file path is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <file1> <file2> ..."
  exit 1
fi

# Create a temporary branch from the current branch (assumed to be master or main)
current_branch=$(git branch --show-current)
echo -e "\033[33m Creating a temporary branch from $current_branch\033[0m"
git checkout -b "new_history"

# Remove all mentions of the specified files from history and rename to temp/
# Something like ["--path {path_name}" for path_name in paths] in python:
path_string=""
for file in  "$@"; do
  path_string="$path_string --path $file"
done
echo -e "\033[33m Filtering history with $path_string\033[0m"
git filter-repo --refs "new_history" $path_string --force
# This will get me a repo with only the commits that we want to push back

# Go back to master and create one with the inverse of these changes
echo -e "\033[33m Creating a new branch from $current_branch\033[0m"
git checkout "$current_branch"
git checkout -b "old_stuff"
git filter-repo --refs "old_stuff" $path_string --invert-paths --force # Screw good pracice I guess

git checkout "new_history"
# Squash it all into a `bedrock` commit
# Get the base commit (common ancestor) with the main branch
BASE_COMMIT=$(git rev-list --max-parents=0 HEAD)
COMMIT_MESSAGES=$(git log --reverse --format=%B $BASE_COMMIT..HEAD)
# Reset to the base commit, keeping changes in the working directory
echo -e "\033[33m Resetting to $BASE_COMMIT\033[0m"
git reset $BASE_COMMIT
# Get the commit messages from all commits since the base commit
# # Stage all changes
git add .
# # Create a new commit with the combined commit messages
echo "$COMMIT_MESSAGES" | git commit --amend -F -

git checkout "old_stuff"
git rebase "new_history"
# exit
