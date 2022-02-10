#!/usr/bin/env bash

# Loops through a whitespace delimited list of Ion repositories, and generates
# a news item for the latest release of each repository if a news item doesn't
# already exist for that release.
#
# Any news items that are generated will automatically be staged for commit.
# The user or workflow that is running the script is responsible for committing
# and pushing any changes.
#
# If any news items are generated, an auto-generated commit message will be
# exported as GENERATED_NEWS_COMMIT_MESSAGE.
#
# This script does not generate news items for releases marked as a pre-release
# version.

# TODO: See if github actions can use the github cli to automatically list all Ion repositories.
# readonly repo_nameS="$(gh api teams/2323876/repos --jq '.[] | select(.visibility == "public") | .name')"

# This should be kept up-to-date with all PUBLIC ion repositories.
readonly REPO_NAMES="\
ion-c
ion-cli
ion-docs
ion-dotnet
ion-eclipse-plugin
ion-element-kotlin
ion-go
ion-hash
ion-hash-dotnet
ion-hash-go
ion-hash-java
ion-hash-js
ion-hash-python
ion-hash-test
ion-hash-test-driver
ion-hive-serde
ion-intellij-plugin
ion-java
ion-java-benchmark-cli
ion-java-path-extraction
ion-js
ion-kotlin-builder
ion-python
ion-rust
ion-schema
ion-schema-kotlin
ion-schema-rust"

commit_msg_body=""

for repo_name in $REPO_NAMES; do
  printf "Checking for releases in %s... " "$repo_name"
  release="$(gh release view -R "amzn/$repo_name" --json body,createdAt,tagName)"
  [ -z "$release" ] && continue

  release_date="$(jq -r '.createdAt' <<< "$release" | cut -d'T' -f1)"
  tag="$(jq -r '.tagName' <<< "$release")"
  version="$(cut -d'v' -f2 <<< "$tag")"
  news_item_file_path="_posts/$release_date-$repo_name-$(sed 's/\./_/g' <<< "$version")-released.md"

  # NOTE: If we decide that we want to include the release notes in the news item, we need to remove
  # the '\r' characters from the release body. i.e.:
  # release_notes = $(jq -r '.body' <<< "$release" | sed -e 's/\r//g')

  printf 'found %s... ' "$tag"

  # If file already exists, then we already have a new item for this release.
  if [[ -f $news_item_file_path ]]; then
    echo 'news already exists for this release.'
  else
    title_case_repo_name="$(sed -e "s/\-/ /" <<< "$repo_name" | awk '{for (i=1;i <= NF;i++) {sub(".",substr(toupper($i),1,1),$i)} print}')"

    # Collapses any repeated newlines down to a single newline
    sed -e '/./b' -e :n -e 'N;s/\n$//;tn' <<< "\
---
layout: news_item
title: \"$title_case_repo_name $version Released\"
date: $release_date
categories: news $repo_name
---

$title_case_repo_name $version is now available.

| [Release Notes $tag](https://github.com/amzn/$repo_name/releases/tag/$tag) | [$title_case_repo_name](https://github.com/amzn/$repo_name) |
" >> "$news_item_file_path"

    git add "$news_item_file_path"
    commit_msg_body=$(printf '%s\n%s' "$commit_msg_body" "* $repo_name $tag")
    echo "generated $news_item_file_path"
  fi
done

readonly NUM_NEW_POSTS=$(git status -s -uno | grep -ce .)
if [[ $NUM_NEW_POSTS -ne 0 ]]; then
  GENERATED_NEWS_COMMIT_MESSAGE="$(printf 'Adds news posts for %s releases\n%s\n' "$NUM_NEW_POSTS" "$commit_msg_body")"
else
  GENERATED_NEWS_COMMIT_MESSAGE= # Nothing
fi
export GENERATED_NEWS_COMMIT_MESSAGE
