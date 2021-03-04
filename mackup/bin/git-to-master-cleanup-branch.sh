#!/bin/bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git checkout master
git pull origin master
git branch -d $BRANCH
