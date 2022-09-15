echo "enter git repo name e.g(nn2/component/alarm-component)"
read gitrepo
echo "enter github repo name e.g(nn2-component-alarm-component)"
read ghrepo

gh repo create NetNumber/$ghrepo --internal -t Rodan

echo "repo created"
##STEP II

cd /home/gsingh/internal/scripts/github

./post_ghe_repo_creation_steps.sh $ghrepo


cd /home/gsingh/internal/ansible

ansible-playbook git_repo_set_perms.yml -e "git_mode=disable git_repo=$gitrepo.git"

cd /home/gsingh/github-migration

./git2github.sh $gitrepo

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
GIT_REPO=$GITURL/$gitrepo
GITHUB_REPO=$ghrepo

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
 git diff --exit-code --output=/home/gsingh/log/$GITHUB_REPO.diff master old-repo/master
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
