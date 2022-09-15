#### Velidation

cleanup() {
  echo "cleanup"
  cd $INIT_WORKING_DIR
  rm -rf $GITHUB_REPO
}

INIT_WORKING_DIR=~/test/
cd $INIT_WORKING_DIR

GITHUB_URL=https://github.netnumber.com/NetNumber
GITURL="git.netnumber.com:/git"
GIT_REPO=git.netnumber.com:/git/nn2/app/rta
GITHUB_REPO=nn2-app-rta

git clone -q $GITHUB_URL/$GITHUB_REPO

if [ $? -ne 0 ]
then
  echo "***** VALIDATION FAILURE *****"
  echo "Please verify that the github repo $GITHUB_URL/$GITHUB_REPO exists"
  exit
fi

cd $GITHUB_REPO
git remote add -f old-repo $GIT_REPO
 if [ $? -ne 0 ]
 then
   echo "***** Validation FAILURE *****"
   echo "An error was encountered trying to check $GIT_REPO"
   cleanup
   exit
 fi

 git remote update
 echo "working"
 git diff --exit-code --output='~/log/$GITHUB_REPO.diff' master old-repo/master
 if [ $? -ne 0 ]
 then
   echo "***** VALIDATION FAILURE *****"
   echo "Differences found between old git repo ($GIT_REPO) and new github repo ($GITHUB_REPO). Diff file can be found at: ~/log/$GITHUB_REPO.diff"
   cleanup
   exit
 fi

 cd ..
 cleanup
 echo "***** SUCCESSFULLY VALIDATED $GITHUB_REPO *****"
