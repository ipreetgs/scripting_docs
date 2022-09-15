ls test/>dir.txt
filename=dir.txt
n=1
while IFS= read -r line;
do
   echo $line;
   ls test/$line/ >test/$n.txt
  n=$((n+1))
done <$filename


diff -u test/1.txt test/2.txt
if [ $? -ne 0 ]
then
  echo "***** Content differ on repos *****"
  exit
fi
