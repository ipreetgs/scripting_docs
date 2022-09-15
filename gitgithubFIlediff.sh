#!/bin/bash
cleanup() {
  echo "cleanup"
  cd $INIT_WORKING_DIR
  rm -rf *
}
filename=$1
INIT_WORKING_DIR=~/test/
cd $INIT_WORKING_DIR
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
    echo "***** VALIDATION FAILURE GITHUB repo not or empty *****"
    echo "Please verify that the github repo $GITHUB_URL/$GITHUB_REPO exists"
    continue
  fi
  git clone -q $GIT_REPO
  
  ls test/>dir.txt
  filename=dir.txt
  n=1
  while IFS= read -r line;
  do
     echo $line;
     ls test/$line/ >test/$n.txt
    n=$((n+1))
  done <$filename

  diff -u test/1.txt test/2.txt
  if [ $? -ne 0 ]
  then
    echo "***** Content differ on repos *****"
    cleanup
    exit
  fi
  cleanup
done <$filename
