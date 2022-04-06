#!/bin/bash

COUNT=0
STARTED=0

for i in {1..3}
do
    ((COUNT=COUNT+1))
    echo "$STAGE_NAME Starting container [Attempt: $COUNT]"
    curl http://localhost:8000
    a=`echo $?`
    
    if [ $a -eq 0 ]    
    then
        STARTED=1
        break
    
    else
        sleep 1
    fi
    COUNT=COUNT+1
done


if [ $STARTED -eq 0 ]
then

    exit 1

fi
