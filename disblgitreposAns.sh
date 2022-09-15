filename=$1
while IFS= read -r line;
  do
     echo $line;
     cd /home/gsingh/internal/ansible
     ansible-playbook git_repo_set_perms.yml -e "git_mode=disable git_repo=$line.git"
     if [ $? -ne 0 ]
     then
       ansible-playbook git_repo_set_perms.yml -e "git_mode=disable git_repo=$line"
       if [ $? -ne 0 ]
       then
         echo "$(tput setaf 2) $(tput setab 4)****##############################******************* repo Disabled Failed ****###########################**********************"
         exit
       fi
       
     fi
     echo "$(tput setaf 5) $(tput setab 7)****##############################******************* repo $line Disabled ****###########################**********************"

  done <$filename
