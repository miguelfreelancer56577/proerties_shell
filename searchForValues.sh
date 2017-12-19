#!/bin/bash
#Filename: cecho.sh

array_propertyName=()
array_propertyValue=()

array_positionNumber=()
array_variableNames=()
array_variableValues=()

array_file=()

function getPropertiesFile(){

  array_propertyName=()
  array_propertyValue=()

  local fileName=$1
  local propertyValue=$2

  local count=0

  while read line; do

    array_propertyName[$count]="$( echo $line | cut -d '=' -f 1 )"
    array_propertyValue[$count]="$( echo $line | cut -d '=' -f 2 | cut -d ':' -f $propertyValue )"

    let count++

  done < $fileName
  
}

function variablesToChange(){

  array_positionNumber=()
  array_variableNames=()
  array_variableValues=()

  local count=0;

  local fileName=$1

  # local saveV="$(cat $1 | grep '##')"
  # local saveV="$(cat -n example.sh | grep '##' | sed -r 's/\s{3,}//g')"
  local saveV="$(cat -n $fileName | grep '##' | sed -r "s/\s/_/g" | tr -d '[:space:]' | sed -r 's/_{2,}//g')"  

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

}

function toArrayFromFile(){

  array_file=()

  local fileName=$1

  local count=0

  while read line; do

    # echo $line

    array_file[$count]="$(echo $line)"

    let count++

  done < $fileName
  
}

function onChange(){

  local count=0

  for variablename in "${array_variableNames[@]}"
  do
    
    local countInner=0

    for property in "${array_propertyName[@]}"
    do
      
      if [ "$property" ==  "$variablename" ]
        then

        # echo $array_positionNumber[$count]
        # echo $variablename
        # echo $countInner
        # echo $array_propertyValue[$countInner]

        local positionNumber=${array_positionNumber[$count]}

        let positionNumber--

        array_file[$positionNumber]="$(echo $variablename=${array_propertyValue[$countInner]} )"

      fi

      let countInner++
      
    done

    let count++

  done

}

function run(){

  environment=$1

  propertyFile=$2

  fileToChange=$3
  
  # get variables and values from a property file.
  getPropertiesFile $propertyFile $environment

  # get position, variable´s name and  variable's value to arrays

  variablesToChange $fileToChange

  #save every line of the file into an array

  toArrayFromFile $fileToChange

  #change values into array that contains every line of the file
  onChange 

}

run 1 "properties.proerties_shell.conf" "example.sh"
