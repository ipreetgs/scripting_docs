cleanup() {
  echo "cleanup"
  cd $INIT_WORKING_DIR
  rm -r $GITHUB_REPO
  rm -r $SVN_REPO_DIR
}

INIT_WORKING_DIR=$(dirname "$(readlink -f "$0")")
GITHUB_URL=https://github.netnumber.com/NetNumber
SVN_REPO=""
SVN_REPO_DIR=""
GITHUB_REPO=""
SVN_USER="bibasco"
SVN_PASSWORD="bibasco682016"


while IFS= read -r line || [[ -n "$line" ]]; do
  SVN_REPO=`echo $line | awk -F ',' '{print $1}'`
  SVN_REPO_DIR=`echo $SVN_REPO | awk -F '/' '{print $NF}'`
  GITHUB_REPO=`echo $line | awk -F ',' '{print $2}'`

  printf "\nProcessing line: $line\n"

  # Check if github repo exists
  git clone -q $GITHUB_URL/$GITHUB_REPO
  if [ $? -ne 0 ]
  then
    echo "***** VALIDATION FAILURE *****"
    echo "Please verify that the github repo $GITHUB_URL/$GITHUB_REPO exists"
    exit
  fi

  # Check out svn repo
  svn checkout -q --username $SVN_USER --password $SVN_PASSWORD $SVN_REPO
  if [ $? -ne 0 ]
  then 
    echo "***** Validation FAILURE *****"
    echo "An error was encountered trying to checkout $SVN_REPO"
    cleanup
    exit
  fi
  ### CODE to Check branches
  echo "Checked out $SVN_REPO successfully to: $SVN_REPO_DIR"
  
  cd $SVN_REPO_DIR
  svnb=$(ls branches/)
  cd ..

  cd $GITHUB_REPO
  for sbranch in $svnb
  do
    echo "Checking if SVN repo branch named \"$sbranch\" exists in git repo"
    git branch -a | grep $sbranch
    #git branch |grep mstr    to check if code works
    if [ $? -ne 0 ]
    then
      echo "$(tput setaf 2)***** VALIDATION FAILURE $sbranch not exist in git repo *****"
      # echo "$(tput setaf 7)"
      exit
    fi
  done
  cd ..
##### checking content 

  cd $SVN_REPO_DIR
  svnfiles=$(ls trunk/)
  cd ..

  cd $GITHUB_REPO
  for content in $svnfiles
  do
  # TODO - $(tput setaf 5)
    echo "checking svn $content in github repo $(tput setaf 7)"
    ls|grep $content
    if [ $? -ne 0 ]
    then
      echo "$(tput setaf 2)***** VALIDATION FAILURE $content not exist in git repo ***** $(tput setaf 7)"
      exit
    fi
  done
  cd ..
##### checking if github have extra branches


  #### check commit info
  cd $GITHUB_REPO  
  gh_commit_msg=`git log -1 --format=%B -n 1 | head -1 | xargs`

  cd $INIT_WORKING_DIR  
  svn_commit_msg=`svn log -l 1 --username $SVN_USER --password $SVN_PASSWORD $SVN_REPO_DIR | sed '4q;d' | xargs`
  if [[ "$gh_commit_msg" != "$svn_commit_msg" ]]
  then 
    echo "***** Validation FAILURE *****"
    echo "Last commit of $SVN_REPO did NOT match last commit of $GITHUB_REPO"
    echo "SVN Repo last commit message: $svn_commit_msg"
    echo "GH Repo last commit message: $gh_commit_msg"
    # cleanup
    exit
  fi
  
  # cleanup
  echo "***** SUCCESSFULLY VALIDATED $GITHUB_REPO *****"
done < $1