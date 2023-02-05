declare -A hashmap
flag=0
k=0
while true
do #menu
echo "r) read a dataset from the file"
echo "p) print the names of the features"
echo "l) encode a feature using label encoding"
echo "o) encode a feature using one-hot encoding"
echo "m) apply MinMax scalling"
echo "s) save the processed dataset"
echo "e) exit"
read choice
case "$choice"
in
r) echo "Please input the name of the dataset file"
    read  filename
 if [ -e $filename ]
then
   cp $filename copy.txt
   cp $filename copy2.txt
   filename2=copy.txt
   filename3=copy2.txt
fi
    k=0
  for i in "${!hashmap[@]}"; do
      unset hashmap[$i]
done
    flag=1
     if [ ! -e $filename ]
     then
        echo "file does not exist"
          flag=0
        elif [ ! -r $filename ]
           then
          echo "This not readable file  you must change permission"
          flag=0
       else
       number=$(sed -n '1p' $filename | tr ';' ' ' | wc -w)
       number2=$(sed -n '2p' $filename | tr ';' ' ' | wc -w)
       if [ $number -ne  $number2 ]
       then
   echo  "The format of the data in the dataset file is wrong"
          flag=0
       fi
         fi;;
p) if [ $flag -eq 0 ]
     then
      echo "you must first read a dataset from a file"
      else
       echo " The names of features is : "
       sed -n '1p' $filename3 | tr ';' '  '
       sed -n '1p' $filename3 | tr ';' '  ' > final.txt
fi;;
l) if [ $flag -eq 0 ]
      then
      echo "you must first read a dataset from a file"
      else
      echo "Please input the name (small letter) of the categorical feature for label encoding"
      read feature
   if  grep $feature $filename2 > /dev/null
      then
        line=$( grep $feature $filename2 | tr ';' ' ')
        counter=1
         for i in $line
           do
          if [ $feature = $i ]
            then
           echo "The name of feature is exist"
              break
           fi
       counter=$((counter + 1))
            done
values=$(cat $filename2 | tr ';' ' ' | cut -d' ' -f$counter  )
values=$(echo $values | cut -d' ' -f2- | tr " " "\12" | sort | uniq)
           for i in $values
           do
           if test "${hashmap[$i]+isset}"
             then
continue #the value exist in the hash
else
             hashmap[$i]=$k
    k=$(( k + 1))
fi
           done
  echo " the distinct values of the categorical feature and the code of each value"
       for i in "${!hashmap[@]}"; do
      echo "the value is : $i and the code is ${hashmap[$i]}"
done
position=0
if [ -e newfile1.txt ]
then
rm newfile1.txt
fi
     while read line;
     do
    if [ $position -eq 0 ]
    then
       echo $line
       echo $line  >> newfile1.txt
         position=1
       continue
      fi
word=$(echo $line |cut -d';' -f$counter)
var=$(echo $line | cut -d ';' -f-$counter | tr ';' ' ')
count=0
     for i in $var
      do
     if [ $i = $word ]
     then
      count=$((count+1))
     fi
      done
       echo $line |  sed  s/$word/${hashmap[$word]}/$count
     echo $line |  sed  s/$word/${hashmap[$word]}/$count  >> newfile1.txt
       done < $filename2
      else
      echo "The name of categorical feature is wrong"
       fi
cp newfile1.txt $filename2
cat newfile1.txt > final.txt
       fi;;
o) if [ $flag -eq 0 ]
      then
     echo "you must first read a dataset from a file"
     else
      echo "Please input the name (small letter) of the categorical feature for one-hot encoding"
      read feature
   if  grep $feature $filename3 > /dev/null
      then
        line=$( grep $feature $filename3 | tr ';' ' ')
        counter=1 #the number of field for the feature
         for i in $line
           do
          if [ $feature = $i ]
            then
           echo "The name of feature is exist"
              break
           fi
       counter=$((counter + 1))
            done
if [ -e newfile2.txt ]
then
rm newfile2.txt
fi
values=$(cat $filename3 | tr ';' ' ' | cut -d' ' -f$counter  )
values=$(echo $values | cut -d' ' -f2- | tr " " "\12" | sort | uniq) #just sort if each value in line
echo $values| tr ' '  ';' >> newfile2.txt
position=0
if [ -e result.txt ]
then
rm result.txt
fi
file=newfile2.txt
file=$(cat $file | tr ';' ' ')
while read line ;do
 if [ $position -eq 0 ]
    then
         position=1
       continue
      fi
word=$(echo $line | cut -d ';' -f$counter)
for i in $file
do
if [ $word != $i ]
then
printf "0;" >>newfile2.txt
else
printf "1;" >>newfile2.txt
fi
done
printf "\n" >> newfile2.txt
done < $filename3
echo "The distinct values of the categorical feature : "
cat newfile2.txt
firstPart=$(cut -d ';' -f-$(($counter -1 )) $filename3)
echo $firstPart | tr ' ' '\12' > first.txt
lastPart=$(cut -d ';' -f$(($counter + 1))- $filename3)
echo $lastPart | tr ' ' '\12' > second.txt
paste -d ';' first.txt newfile2.txt second.txt | tr -s ';' ';' >result.txt
cat result.txt | tr -s  ';' ';'
cat result.txt > final.txt
       else
  echo "The name of categorical feature is wrong"
      fi
    cp result.txt $filename3
       fi;;
m)if [ $flag -eq 0 ]
      then
     echo "you must first read a dataset from a file"
     else
     echo "Please input the name of the feature to be scaled"
           read feature
   if  grep $feature $filename2 > /dev/null
      then
        line=$( grep $feature $filename2 | tr ';' ' ')
        counter=1 #the number of field for the feature
         for i in $line
           do
          if [ $feature = $i ]
            then
           echo "The name of feature is exist"
              break
      fi
       counter=$((counter + 1))
            done
values=$(cat $filename2 | tr ';' ' ' | cut -d' ' -f$counter)
values=$(echo $values | cut -d ' ' -f2-)
min=$(echo $values | cut -d ' ' -f1)

if  echo $min |  grep '[A-Za-z]' > /dev/null
then
echo "is feature is categorical feature and  must be encoded first"
else
max=$(echo $values | cut -d ' ' -f1)
for i in $values
do
if [ $i -lt $min ]
then
    min=$i
fi
if [ $i -gt $max ]
then
      max=$i
fi
done
echo "The minmun value is `echo $min`"
echo "The maximum value is `echo $max`"
echo "The minmun value is `echo $min`" > scale.txt
echo "The maximum value is `echo $max`" >> scale.txt
for i in $values
do
#the equation here
a=$(bc <<< "$i - $min")
b=$(bc <<< "$max - $min")
c=$(bc <<< "scale=2; $a /$b")
 echo "for the value `echo $i` the scale is `echo $c`"
echo "for the value `echo $i` the scale is `echo $c`" >>scale.txt
done
fi
     else
      echo "The name of categorical feature is wrong"
      fi
cat scale.txt > final.txt
fi;;
s) if [ $flag -eq 0 ]
      then
  echo "you must first read a dataset from a file"
     else
     flag=3
     echo " Please input the name of the file to save the processed dataset"
       read name
       cat final.txt > $name
fi;;
e) if [ $flag -ne 3 ]
      then
 echo "The processed dataset is not saved. Are you sure you want to exist"
      read ans
     if [ $ans = yes -o $ans = Yes ]
      then
            exit
      else
     echo " "
    fi
  else
    echo  "Are you sure you  want to exist ?"
     read ans
   if [ $ans = yes -o $ans = Yes ]
      then
            exit
      else
               echo " "
    fi
fi;;
*) echo "This choice is not available !! try anoter one please)";;
esac
done
