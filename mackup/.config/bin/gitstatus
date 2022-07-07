#!/bin/sh

# NOTE: two-letter status code
# https://git-scm.com/docs/git-status
# X          Y     Meaning
# -------------------------------------------------
# 	 [AMD]   not updated
# M        [ MTD]  updated in index
# T        [ MTD]  type changed in index
# A        [ MTD]  added to index
# D                deleted from index
# R        [ MTD]  renamed in index
# C        [ MTD]  copied in index
# [MTARC]          index and work tree matches
# [ MTARC]    M    work tree changed since index
# [ MTARC]    T    type changed in work tree since index
# [ MTARC]    D    deleted in work tree
# 	    R    renamed in work tree
# 	    C    copied in work tree
# -------------------------------------------------
# D           D    unmerged, both deleted
# A           U    unmerged, added by us
# U           D    unmerged, deleted by them
# U           A    unmerged, added by them
# D           U    unmerged, deleted by us
# A           A    unmerged, both added
# U           U    unmerged, both modified
# -------------------------------------------------
# ?           ?    untracked
# !           !    ignored
# -------------------------------------------------

# make test bold
bold=$(tput bold)

echo "\n"

# make newlines the only separator
IFS=$'\n'

# save git status to variable
git_status=$(git status --porcelain)

# make modified files list
modified_files=$(echo "$git_status" | grep " M")
# count modified_files
modified_files_count=$(echo "$modified_files" | wc -l)
# trim modified_files_count whitespace
modified_files_count=$(echo "$modified_files_count" | tr -d ' ')
# echo bold string
echo "${bold}Modified Files ($modified_files_count)${bold}"

# loop through modified files
for file in $modified_files; do
  # replace "M" with ""
  file=${file/M/ }
  # prepend yellow text to fist two characters
  file="\033[33m${file:0:2}\033[0m${file:2}"
  echo $file
done

echo "\n"

# make untracked files list
untracked_files=$(echo "$git_status" | grep "??")

# count modified_files
untracked_files_count=$(echo "$untracked_files" | wc -l)
# trim modified_files_count whitespace
untracked_files_count=$(echo "$untracked_files_count" | tr -d ' ')
# echo bold string
echo "${bold}Untracked Files ($untracked_files_count)${bold}"

# loop through untracked files
for file in $untracked_files; do
  # replace "M" with ""
  file=${file/\??/  }
  # prepend green text to fist two characters
  file="\033[32m${file:0:2}\033[0m${file:2}"
  echo $file
done

echo "\n"

# make deleted files list
deleted_files=$(echo "$git_status" | grep " D")

# count modified_files
deleted_files_count=$(echo "$deleted_files" | wc -l)
# trim modified_files_count whitespace
deleted_files_count=$(echo "$deleted_files_count" | tr -d ' ')
# echo bold string
echo "${bold}Deleted Files ($deleted_files_count)${bold}"

# loop through deleted files
for file in $deleted_files; do
  # replace "M" with ""
  file=${file/\D/ }
  # prepend red text to fist two characters
  file="\033[31m${file:0:2}\033[0m${file:2}"
  echo $file
done
