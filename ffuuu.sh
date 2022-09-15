cleanup() {
  echo "cleanup"
  cd test
  rm -rf *
}
filename=$1

GITHUB_URL=https://github.netnumber.com/NetNumber
GITHUB_REPO="nn-api-slee-availability-session-slee"
SVN_Repo=svn://bld-master.netnumber.com/svobs/nne/nn/api/availability/session-slee/java
cd test
pwd

git clone -q $GITHUB_URL/$GITHUB_REPO
echo "git repo cloning done"

echo $SVN_Repo
svn checkout --username gsingh --password gsingh05242022 $SVN_Repo
if [ $? -ne 0 ]
  then
    echo "****** SVN ERROR *****"
    exit
  fi

echo "svn done"


####verf

echo $SVN_Repo
svn checkout --username gsingh --password gsingh05242022 $SVN_Repo
if [ $? -ne 0 ]
  then
    echo "****** SVN ERROR *****"
    exit
  fi

echo "svn done"


####verf

ls >/home/gsingh/dir.txt
filename=/home/gsingh/dir.txt
n=1
  while IFS= read -r line;
  do
     echo $line;
     ls $line/trunk >$n.txt
     if [ $? -ne 0 ]
     then
       ls $line>$n.txt
       echo "github repo"

     fi
     echo "svn repo"
     n=$((n+1))
  done <$filename

     
diff -u 1.txt 2.txt
if [ $? -ne 0 ]
then
    echo "*******Content differ in  repos *****"
    exit
    cleanup
fi
echo "*********** VALIDATION Success Repos exists*************"



filename=/home/gsingh/dir.txt
r=5
  while IFS= read -r line;
  do
     echo $line;
     ghr=$line
     ls $line/branches/ >$r.txt
     if [ $? -ne 0 ]
     then
       echo "svn branches"
     fi
     r=$((r+1))
  done <$filename

filenameVer=/home/gsingh/github-migration/svn2github-bash/test/5.txt
  while IFS= read -r brnc;
  do
     
     cd ghr
     git branch -a|grep brnc
     if [ $? -ne 0 ]
     then
       echo "some error"
       exit
     fi
     echo "branches same"
     r=$((r+1))
  done <$filename


