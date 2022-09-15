#svn checkout --username gsingh --password gsingh05242022 svn://bld-master.netnumber.com/svobs/nne/nn/component/alarm/
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
SVN_USER=""
SVN_PASSWORD=""


while IFS= read -r line || [[ -n "$line" ]]; do
  SVN_REPO=`echo $line | awk -F ',' '{print $1}'`
  SVN_REPO_DIR=`echo $SVN_REPO | awk -F '/' '{print $NF}'`
  GITHUB_REPO=`echo $line | awk -F ',' '{print $2}'`

  printf "\nProcessing line: $line\n"

  # Check if github repo exists


  ### CODEE
  
  cd $SVN_REPO_DIR
  svnb=$(ls branches/)
  cd ..

  cd $GITHUB_REPO
  for sbranch in $svnb
  do
    echo "$(tput setaf 5)checking svn $sbranch in git repo$(tput setaf 7)"
    git branch |grep $sbranch
    #git branch |grep mstr    to check if code works
    if [ $? -ne 0 ]
    then
      echo "$(tput setaf 2)***** VALIDATION FAILURE $sbranch not exist in git repo *****$(tput setaf 7)"
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
    echo "$(tput setaf 5)checking svn $content in github repo $(tput setaf 7)"
    ls|grep $content
    if [ $? -ne 0 ]
    then
      echo "$(tput setaf 2)***** VALIDATION FAILURE $content not exist in git repo ***** $(tput setaf 7)"
    fi
  done
  cd ..



done < $1