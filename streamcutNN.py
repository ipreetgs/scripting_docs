f1=open('gt.txt','r')
fw=open('dfs.txt','w')
for i in f1:
    a=i[23:].strip("\n")
    fw.write(f'{a}\n')