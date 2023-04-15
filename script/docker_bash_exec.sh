#!/bin/zsh

DOCKERPS=$(docker ps)

echo "=======================DOCKER CONTAINER LIST========================"
echo "$DOCKERPS \n"

DOCKERPS=$(echo $DOCKERPS | sed -r 's/[ ]+/ /g')

SELECTEDCONTAINERID=''
LINECOUNTER=0
declare -a CONTAINERIDCANDIDATES
declare -a CONTAINERNAMES

while read line; do
    if [ $LINECOUNTER -ge 1 ] 
    then
        CONTAINERID=$(echo $line | cut -d ' ' -f1)
        CONTAINERNAME=$(echo $line | cut -d ' ' -f2)
        CONTAINERIDCANDIDATES+=($CONTAINERID)
        CONTAINERNAMES+=($CONTAINERNAME)
    fi

    ((LINECOUNTER++))
done <<< $DOCKERPS

echo "--------------------------------------------------------------------"
echo "Please select container id for connect"
echo "--------------------------------------------------------------------"
PS3=":"
select CONTAINERNAME in $CONTAINERNAMES
do
    echo "#### Selected container : $CONTAINERNAME ####\n"
    break
done

for (( i = 0; i < ${#CONTAINERIDCANDIDATES[@]}; i++ )); do
    if [ "${CONTAINERNAMES[@]:$i:1}" = "$CONTAINERNAME" ] 
    then
        SELECTEDCONTAINERID=${CONTAINERIDCANDIDATES[@]:$i:1}
    fi
done

echo "Connecting to \"$CONTAINERNAME : $SELECTEDCONTAINERID\" \n"

docker exec -it $SELECTEDCONTAINERID /bin/bash