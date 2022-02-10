#!/usr/bin/env bash

ION_REPOS="$(gh api teams/2323876/repos --jq '.[] | select(.visibility == "public") | .name')"

COMMIT_MSG_BODY=""

for REPO_NAME in $ION_REPOS; do
  RELEASE="$(gh release view -R "amzn/$REPO_NAME" --json body,createdAt,tagName)"

  [ -z "$RELEASE" ] && continue

  RELEASE_DATE="$(jq -r '.createdAt' <<< "$RELEASE" | cut -d'T' -f1)"
  TAG="$(jq -r '.tagName' <<< $RELEASE)"
  VERSION="$(cut -d'v' -f2 <<< $TAG)"
  POST_FILE_NAME="_posts/$RELEASE_DATE-$REPO_NAME-$(sed 's/\./_/g' <<< $VERSION)-released.md"

  # If file already exists, continue
  if [[ ! -f $POST_FILE_NAME ]]; then
    TITLE_CASE_REPO_NAME="$(sed -e "s/\-/ /" <<< $REPO_NAME | awk '{for (i=1;i <= NF;i++) {sub(".",substr(toupper($i),1,1),$i)} print}')"
    sed -e '/./b' -e :n -e 'N;s/\n$//;tn' <<< "\
---
layout: news_item
title: \"$TITLE_CASE_REPO_NAME $VERSION Released\"
date: $RELEASE_DATE
categories: news $REPO
---

$(jq -r '.body' <<< "$RELEASE" | sed -e 's/\r//g')

| [Release Notes $TAG](https://github.com/amzn/$REPO/releases/tag/$TAG) | [$TITLE_CASE_REPO_NAME](https://github.com/amzn/$REPO_NAME) |
" >> $POST_FILE_NAME

    git add $POST_FILE_NAME
    COMMIT_MSG_BODY=$(printf '%s\n%s' "$COMMIT_MSG_BODY" "* $REPO_NAME $TAG")
  fi
done

NUM_NEW_POSTS=$(git status -s -uno | grep -ce .)
if [[ $NUM_NEW_POSTS ]]; then
  git commit -m "$(printf 'Adds news posts for %s releases\n%s\n' "$NUM_NEW_POSTS" "$COMMIT_MSG_BODY")"
  git push
fi
