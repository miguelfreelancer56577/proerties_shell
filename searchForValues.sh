#!/bin/bash
#Filename: cecho.sh

arr_var=()

count=0

function getVariables(){

 oldIFS=$IFS

 IFS=$1

 for item in $2
  do
   echo $item $count
   arr_var[$count]="$item"
   let count++
 done
   
 IFS=$oldIFS

# echo ${arr_var[*]}

}




while read line; do
 getVariables "=" $line
done < properties.proerties_shell.conf

echo '***************'

echo ${#arr_var[*]}

echo ${arr_var[*]}

