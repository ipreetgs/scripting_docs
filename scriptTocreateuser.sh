### Syntex IS   ./scpt.sh id_rsa.pub
## Pub key and script should be in same dir

echo "######Creating User from Pub key#####"


KeyFile=$1

while IFS= read  line ; do
  echo $line
  keycont=$line   # store key data to var to use out side the loop
  echo "##### Key ####"
  useSys=`cut -d "=" -f2 <<< "$line"`
  User_Name=`cut -d "@" -f1 <<< "$useSys"`
#   echo $User_Name   # username space in starting 
done <$KeyFile

#### code to remove the space in start 

# UserName=`${USER_NAME//[[:blank:]]/}`
# echo "$User_Name" | sed 's/[[:space:]]//g'


UserName=`echo "$User_Name" | sed 's/[[:space:]]//g'`
# echo $UserName

echo "Target UserName  is $UserName"
# echo $keycont 

# add username 
sudo useradd -m $UserName
sudo mkdir /home/"$UserName"/.ssh
echo "user added"

sudo echo "${keycont}" >> /home/"$UserName"/.ssh/authorized_keys
echo "key inserted"
sudo chown -R "${UserName}":"${UserName}" /home/"${UserName}"/.ssh
sudo chmod 700 /home/"${UserName}"/.ssh
sudo chmod 600 /home/"${UserName}"/.ssh/authorized_keys

## add user to root group
chck=` cat /etc/sudoers.d/90-cloud-init-users |grep ubuntu`
if [ $? -ne 0 ]
then
  usermod -a -G sudo "${USER_NAME}"
else
  exit 1
fi





