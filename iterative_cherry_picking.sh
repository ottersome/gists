#!/usr/bin/env sh
while read commit_hash; do
  git checkout $commit_hash -- $2
  git add $2
done < $1

