git branch -r | awk '{print $1}' | awk -F/ '{print "remote="$1"; branch="$2";" }' | while read l
do eval $l
    echo $branch
done


git branch -r|grep -v '>'
git branch -r|grep -v '>'|grep -v main


git branch -r|grep -v '>'|grep -v main|awk '{print $1}' | awk -F/ '{print "remote="$1"; branch="$2";" }' | while read l
do eval $l
    echo $branch
done


gbl=`git branch -r|grep -v '>'|grep -v main|awk '{print $1}' | awk -F/ '{print "remote="$1"; branch="$2";" }' | while read l
do eval $l
    echo $branch
done`

val=`for gi in $gbl
do
echo $svnb|grep $gi
done`


gbl=`git branch -r|grep -v '>'|grep -v main|awk '{print $1}' | awk -F/ '{print $2}'`