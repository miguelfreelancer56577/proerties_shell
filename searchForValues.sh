#!/bin/bash
#Filename: cecho.sh

arr_propertyName=()
arr_propertyValue=()

arr_positionNumber=()
arr_variableNames=()
arr_variableValues=()

function getPropertiesFile(){

  local array_propertyName=()
  local array_propertyValue=()

  local fileName=$1
  local propertyValue=$2

  local count=0

  while read line; do

    array_propertyName[$count]="$( echo $line | cut -d '=' -f 1 )"
    array_propertyValue[$count]="$( echo $line | cut -d '=' -f 2 | cut -d ':' -f $propertyValue )"

    let count++

  done < $fileName

  arr_propertyName=("${array_propertyName[*]}")
  arr_propertyValue=("${array_propertyValue[*]}")
  
}

function variablesToChange(){

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

function toArrayFromFile(){

  local array_file=()

  local fileName=$1

  local count=0

  while read line; do

    array_file[$count]="$(echo $line)"

    let count++

  done < $fileName
  
}

# get variables and values from a property file.
getPropertiesFile "properties.proerties_shell.conf" 1

# get position, variable´s name and  variable's value to arrays

variablesToChange "example.sh"

#save every line of the file into an array

toArrayFromFile "example.sh"

