while IFS= read -r line;
do
   echo $line;
   gh repo view netnumber/$line
   if [ $? -ne 0 ]
   then
    echo "***** VALIDATION FAILURE *****"
    echo "Please verify that the github repo $line exists"
    exit
   fi
done <$1