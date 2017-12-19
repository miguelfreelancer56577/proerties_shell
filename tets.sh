lockdir="./somedir"
testlock(){
    if mkdir "$lockdir"
    then # Directory did not exist, but was created successfully
         echo >&2 "successfully acquired lock: $lockdir"
         retval=0
    else
         echo >&2 "cannot acquire lock, giving up on $lockdir"
         retval=1
    fi
    return "$retval"
}

testlock
other=$?
if [ "$other" == 0 ]
then
     echo "directory not created"
else
     echo "directory already created"
fi