  abz=$1
  while IFS= read -r line;
  do
     echo $line;
     echo "line read"
  done <$abz

  
