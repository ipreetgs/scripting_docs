import os
import sys
import subprocess

vfile = sys.argv[1]

f=open(vfile,'r')
for line in f:
    print(line)
    GitHub_Repo=line.split(',')[1]
    Svn_Repo=line.split(',')[0]
    Svn_Dir=os.path.basename(os.path.normpath(Svn_Repo))

    os.chdir(f'{Svn_Dir}')
    #Svn_Branches = os.popen('ls branches/')
    Svn_BranchList =os.listdir('branches')
    os.chdir('..')
    
    
    os.chdir(GitHub_Repo)
    #os.popen('git branch')
    #Github_Branches=os.popen('git branch')
    for i in Svn_BranchList:
        print(f'checking SVN {i} branch In GitHub Repo')
        os.system(f'git branch|grep {i}')

    os.chdir('..')
  

         

    

    
 