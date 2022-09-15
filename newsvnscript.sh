echo "enter svn repo name"
read SVN_REPO
echo "enter github repo neme   "
read REPO_NAME
python3 settingINIgen.py $SVN_REPO

source settings.ini 

echo $REPOSITORY

svn log --username gsingh --password gsingh05242022 -q ${REPOSITORY} | awk '/^r/{print $3" = "$3" <"$3"@example.com>"}'|sort -u|tee /tmp/gsingh-authors.txt



./svn2github.sh $REPO_NAME



#### Post Repos

cd /home/gsingh/internal/scripts/github
./post_ghe_repo_creation_steps.sh $REPO_NAME

#LOck SVN Repo

#cd /home/gsingh/internal/ansible/
#SvnRepoDr=$( sed -e 's#.*nne/\(\)#\1#' <<<$SVN_REPO)
#ansible-playbook svn_repo_set_perms.yml -e "svn_mode=enable svn_repo=nne svn_repo_dir=$SvnRepoDr"

#view github repo url

gh repo view NetNumber/$REPO_NAME
cd ~
cd test
##validation

cleanup() {
  # debug
  # echo "cleanup"
  cd $INIT_WORKING_DIR
  rm -r $GITHUB_REPO
  rm -r $SVN_REPO_DIR
}

INIT_WORKING_DIR=$(dirname "$(readlink -f "$0")")
GITHUB_URL=https://github.netnumber.com/NetNumber
SVN_REPO=$SVN_REPO
SVN_REPO_DIR=""
GITHUB_REPO=$REPO_NAME
SVN_USER="gsingh"
SVN_PASSWORD="gsingh05242022"

is_trunk_based=false

## TODO: Add helper function for reporting errors with flag to exit on first validation failure

# Checking if trunk based repository
if [[ $SVN_REPO == *"trunk"* ]]; then
  SVN_REPO=`echo $SVN_REPO | sed 's,/*[^/]\+/*$,,'`
  is_trunk_based=true
else
  is_trunk_based=false
fi
SVN_REPO_DIR=`echo $SVN_REPO | awk -F '/' '{print $NF}'`
# Check if github repo exists
git clone -q $GITHUB_URL/$GITHUB_REPO
if [ $? -ne 0 ]
then
  echo "***** VALIDATION FAILURE: Please verify that the github repo $GITHUB_URL/$GITHUB_REPO exists"
  exit
fi

 # Check out svn repo
 svn checkout -q --username $SVN_USER --password $SVN_PASSWORD $SVN_REPO
 if [ $? -ne 0 ]
 then 
   echo "***** VALIDATION FAILURE: An error was encountered trying to checkout $SVN_REPO"
   cleanup
   exit
 fi

 # Check if there are SVN branches
 cd $SVN_REPO_DIR
 svnb=$(ls branches/)
 if [ $? -ne 0 ]
 then
   echo "Repository has no branches"
   svnb=''
 fi
 printf "Subversion branches found:\n$svnb\n"
  
# Check if there are Git branches aside from main
cd $INIT_WORKING_DIR/$GITHUB_REPO
gitb=`git branch -r|grep -v '>'|grep -v main|awk '{print $1}' | awk -F/ '{print $2}'`
printf "Git branches found:\n$gitb\n"

# Verify that the number of branches match
svnb_cnt=`echo $svnb | wc -w`
gitb_cnt=`echo $gitb | wc -w`
if [ $svnb_cnt -ne $gitb_cnt ]
then
  echo "***** VALIDATION FAILURE: SVN and Git repository branches do NOT match"
  exit
 fi

 # Verify that SVN branches were migrated
 for sbranch in $svnb
 do
   gitb=`git branch -a | grep $sbranch`
   if [ $? -ne 0 ]
   then
     echo "$(tput setaf 2)***** VALIDATION FAILURE: $sbranch does NOT exist in git repo"
     echo "$(tput setaf 7)"
     cleanup
     exit
   fi
 done
 cd $INIT_WORKING_DIR    

 # checking content 
 cd $SVN_REPO_DIR
 svnfiles=$(ls trunk/)
 cd $INIT_WORKING_DIR

 cd $GITHUB_REPO
 for content in $svnfiles
 do
   content_check=`ls|grep $content`
   if [ $? -ne 0 ]
   then
     echo "$(tput setaf 2)***** VALIDATION FAILURE: $content not exist in git repo $(tput setaf 7)"
     exit
   fi
 done
  
 # Compare latest commits
 cd $INIT_WORKING_DIR/$GITHUB_REPO  
 gh_commit_msg=`git log -1 --format=%B -n 1 | head -1 | xargs`  

 cd $INIT_WORKING_DIR
 if [[ $is_trunk_based = true ]] ; then
   svn_commit_msg=`svn log -l 1 --username $SVN_USER --password $SVN_PASSWORD $SVN_REPO_DIR/trunk | sed '4q;d' | xargs`
 else
   svn_commit_msg=`svn log -l 1 --username $SVN_USER --password $SVN_PASSWORD $SVN_REPO_DIR | sed '4q;d' | xargs`
 fi
  
 if [[ "$gh_commit_msg" != "$svn_commit_msg" ]]
 then 
   echo "***** VALIDATION FAILURE: Last commit of $SVN_REPO did NOT match last commit of $GITHUB_REPO"
   echo "***** SVN Repo last commit message: $svn_commit_msg"
   echo "***** GH Repo last commit message: $gh_commit_msg"
   cleanup
   exit
 fi
  
 cleanup
 echo "***** SUCCESSFULLY VALIDATED $GITHUB_REPO *****"
