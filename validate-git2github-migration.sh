#!/bin/bash
# validate-git2github-migration.sh -- Verify that a git repository was correctly migrated to GitHub
# Ben Ibasco
# bibasco@netnumber.com
# Last Update: April 28, 2022

cleanup() {
  echo "cleanup"
  cd $INIT_WORKING_DIR
  rm -rf $GITHUB_REPO
}

INIT_WORKING_DIR=$(dirname "$(readlink -f "$0")")
GITHUB_URL=https://github.netnumber.com/NetNumber
GIT_REPO=""
GITHUB_REPO=""

while IFS= read -r line; do
  GIT_REPO=`echo $line | awk -F ',' '{print $1}'`
  GITHUB_REPO=`echo $line | awk -F ',' '{print $2}'`

  printf "\nProcessing line: $line\n"
  git clone -q $GITHUB_URL/$GITHUB_REPO

  if [ $? -ne 0 ]
  then
    echo "***** VALIDATION FAILURE *****"
    echo "Please verify that the github repo $GITHUB_URL/$GITHUB_REPO exists"
    continue
  fi

  cd $GITHUB_REPO
  git remote add -f old-repo $GIT_REPO
  if [ $? -ne 0 ]
  then 
    echo "***** Validation FAILURE *****"
    echo "An error was encountered trying to check $GIT_REPO"
    cleanup
    continue
  fi

  git remote update
  git diff --exit-code --output=/tmp/$GITHUB_REPO.diff master old-repo/master
  if [ $? -ne 0 ]
  then
    echo "***** VALIDATION FAILURE *****"
    echo "Differences found between old git repo ($GIT_REPO) and new github repo ($GITHUB_REPO). Diff file can be found at: /tmp/$GITHUB_REPO.diff"
    cleanup
    continue
  fi
  
  cd ..
  cleanup
  echo "***** SUCCESSFULLY VALIDATED $GITHUB_REPO *****"
done < $1



