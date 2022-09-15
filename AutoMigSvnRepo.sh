echo "enter svn repo name"
read SVN_REPO

python3 settingINIgen.py $SVN_REPO

source settings.ini 

echo $REPOSITORY

svn log --username gsingh --password gsingh05242022 -q ${REPOSITORY} | awk '/^r/{print $3" = "$3" <"$3"@example.com>"}'|sort -u|tee /tmp/gsingh-authors.txt


./svn2github.sh

echo "enter github repo neme   "
read ghrepo

#### Post Repos

cd /home/gsingh/internal/scripts/github
./post_ghe_repo_creation_steps.sh $ghrepo

#LOck SVN Repo

#cd /home/gsingh/internal/ansible/
#SvnRepoDr=$( sed -e 's#.*nne/\(\)#\1#' <<<$SVN_REPO)
#ansible-playbook svn_repo_set_perms.yml -e "svn_mode=enable svn_repo=nne svn_repo_dir=$SvnRepoDr"

#view github repo url

gh repo view NetNumber/$ghrepo

