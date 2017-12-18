#!/bin/bash
#Filename: cecho.sh

arr_var=()

count=0

arr_positionNumber=()
arr_variableNames=()
arr_variableValues=()

function getVariables(){

 oldIFS=$IFS

 IFS=$1

 innerCount=0

 for item in $2
  do

   echo $item $count

   if [ $innerCount -eq 0 ]
    then

     arr_var[$count]="$item"

    else

     echo getValue "$item" "$count"

   fi

#   arr_var[$count]="$item"

   let count++

   let innerCount++

 done
   
 IFS=$oldIFS

# echo ${arr_var[*]}

}

function getValue(){

 echo get value to change

 local oldIFS=$IFS

 IFS=:

 local positionInArray=0;

 local count=0;

 for item in $1
 do

  if [ $positionInArray -eq $count ]
  then

   arr_var[$2]="$item"

   return

  fi

  let count++;

 done

 IFS=$oldIFS

}

function onChange(){

  local array_positionNumber=()
  local array_variableNames=()
  local array_variableValues=()

  local count=0;

  #$1 file's name
  
  # local saveV="$(cat $1 | grep '##')"
  # local saveV="$(cat -n example.sh | grep '##' | sed -r 's/\s{3,}//g')"
  local saveV="$(cat -n example.sh | grep '##' | sed -r "s/\s/_/g" | tr -d '[:space:]' | sed -r 's/_{2,}//g')"  

  local oldIFS=$IFS

  IFS="##"

  for linea in $saveV
  do
    if [ ${#linea} -gt 0 ]; then
        array_positionNumber[$count]="$(echo $linea | cut -d '_' -f 1)"
        array_variableNames[$count]="$(echo $linea | cut -d '_' -f 2 | cut -d "=" -f 1)"
        array_variableValues[$count]="$(echo $linea | cut -d '_' -f 2 | cut -d "=" -f 2)"
        let count++
    fi

  done

  IFS=$oldIFS

  arr_positionNumber=("${array_positionNumber[*]}")
  arr_variableNames=("${array_variableNames[*]}")
  arr_variableValues=("${array_variableValues[*]}")

}

# get variables and values from a property file.

while read line; do

 getVariables "=" $line

done < properties.proerties_shell.conf

# get position, variable´s name and  variable's value to arrays

onChange "example.sh"

