#  path url line editing


str="svn://bld-master.netnumber.com/svobs/nne/nn/api/accounting/slee/java"
echo $str


SvnRepoDr=$( sed -e 's#.*nne/\(\)#\1#' <<<$str)
echo $SvnRepoDr

>>>

awk -F / '{print $NF}'
git branch -r|grep -v '>'|grep -v main|awk -F / '{print $NF}'


#sed -e 's#.*nne/\(\)#\1#' <<<$str

#cut -d "/" -f2 <<< "$str"
#sed -e 's#.*=\(\)#\1#' <<< "$str"
#awk -F / '{print $NF}' svn://bld-master.netnumber.com/svobs/nne/nn/api/accounting/slee/java