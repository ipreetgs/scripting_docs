import sys
REPOSITORY =sys.argv[1]

##REPOSITORY=input("enter svn repo URL")

GITHUB_TEAM="Rodan"
AUTHORS_FILE="/tmp/gsingh-authors.txt"
ENABLE_SUBMODULES="false"

fileGen=open('settings.ini','w')

fileGen.write(f"""## NN SVN repo
## The URL to the SVN repository
REPOSITORY={REPOSITORY}
#REPOSITORY=svn://localhost/REPO_PREFIX
## The GitHub token
# Github test token:
#GITHUB_TOKEN=5bb444cae385780c1fa275e2df961f3a4a5dfb4c
# Github prod token:
GITHUB_TOKEN=c291fc65d5ae4edd5a84adda7d2bd0c2e630d345
## The GitHub URL (only GHE for now)
# Github test url:
#GITHUB_URL=https://10.2.20.2
# Github prod url:
GITHUB_URL=https://github.netnumber.com
## The GitHub Org to create the repos in
GITHUB_ORG=NetNumber
## The GitHub Team to create the repos for
GITHUB_TEAM={GITHUB_TEAM}
## the author mapping. If it's declared here, it must exist or the script will exit
AUTHORS_FILE={AUTHORS_FILE}
## SVN username... default is fine for unauthenticated
SVN_USERNAME=gsingh
#SVN_USERNAME=svnadmin
## SVN password... default is fine for unauthenticated
SVN_PASSWORD=gsingh05242022
#SVN_PASSWORD=svnadmin
## This is used to bring in only the latest revision
MIGRATE_HISTORY=true
## Max file size for the repo. Default=100MB
MAX_FILE_SIZE=500
## Find and migrate nested repositories?
ENABLE_SUBMODULES={ENABLE_SUBMODULES}
## Discover the repository size before migrating?
SVN_SIZER=false
""")