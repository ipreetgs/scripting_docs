line="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCera66gCOTLor1jXqY4Ohk1ewUdGDEosuheJ9Wisuh5GFGqK3j5SFsQi6euw4OlCqSUmSrYJMuSVJkTQPVlwkE900GuleUSHa39TM/yvTQbrsr0cBSo9GG+i7/wjXVMA7yuRlROwMWwM7ggQnhrwM4si3dRqn4jcqSzlALXSr4QPzlV8BabBGI3OUNxhex2BBi+qf1GD8fGCNKoj5cWYA8yMZbsF5GJYOjdY7vjDhBVhGvS1qVq3KIDbvxE0kH4+HZlABPVls0f5Qia8Y8pRRgaYehI/ZsNoytsuPFmcu4TsbUR2LA4SrIQvy7wqi2VWFrctv1qAn0QbNLgQ2RR8dJEw6PMbBkgCtHYZjtHD9dK76TfdtQtvCKikqibqBKaoe0bBkecFC/sB2DwJidS3eax6+iNWEQsEefSnoxPcxPPWBv61x7n8TknBshSgcexIAxQX86wk7xqgfLUIcOFX1vJIj1dBI5iqtApbmqfuOuza90mQqzMoxEoNoeUHiaBTs= gurpreet@TXCHD-LAP-242"

useSys=`cut -d "=" -f2 <<< "$line"`
UserName=`cut -d "@" -f1 <<< "$useSys"`
echo $UserName


#!/bin/bash

echo "Your uid is ${UID}"

# Enforece that script should executed with root priviledges.
if [[ "${UID}" -ne 0 ]]
then
  echo "Script should be executed with root priviledges."
  exit 1
fi

# if the user doesn't supply a username.
if [[ "${#}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [COMMENT]..."
  echo "Create an account on the local system with name of USER_NAME and a comment field of comment."
  exit 1
fi

#The first parameter is the username
USER_NAME="${1}"
#The rest of the parameters are for the comments.
shift
COMMENT="${@}"

sudo useradd -m -d /home/"${USER_NAME}" -s /bin/bash "${USER_NAME}"
sudo mkdir /home/"${USER_NAME}"/.ssh


echo "Enter your SSH Public KEY: "
read pubkey
sudo echo "${pubkey}" >> /home/"${USER_NAME}"/.ssh/authorized_keys

sudo chown -R "${USER_NAME}":"${USER_NAME}" /home/"${USER_NAME}"/.ssh
sudo chmod 700 /home/"${USER_NAME}"/.ssh
sudo chmod 600 /home/"${USER_NAME}"/.ssh/authorized_keys


echo "providing sudo priviledges to newly created user: "
read sudoersentry
sudo echo "${sudoersentry}" >> /etc/sudoers.d/90-cloud-init-users

echo
echo 'UserName:'
echo "${USER_NAME}"
echo
echo 'Host'
echo "${HOSTNAME}"
exit 0