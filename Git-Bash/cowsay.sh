#!/bin/bash

declare -a MODES
MODES=("b" "d" "g" "p" "s" "t" "w" "y")

declare -a COWS
COWS=("tableflip" "cat" "clippy" "default" "hedgehog" "kilroy" "owl" "shrug" "squirrel" "tux")

MODES_LENGTH=${#MODES[@]}
MODES_INDEX=$(($RANDOM % $MODES_LENGTH))
RANDOM_MODE=${MODES[$MODES_INDEX]}

COWS_LENGTH=${#COWS[@]}
COWS_INDEX=$(($RANDOM % $COWS_LENGTH))
RANDOM_COW=${COWS[$COWS_INDEX]}

echo ${RANDOM_COW[@]} -${RANDOM_MODE[@]} Fetching quote...

URL="https://ms-rq-api.herokuapp.com/"
HTTP_RESPONSE=$( curl -sw "%{http_code}" $URL )
HTTP_CODE=${HTTP_RESPONSE:${#HTTP_RESPONSE}-3}

if [ ! "$HTTP_CODE" -eq 200 ]; then
  cowsay -f ${RANDOM_COW} -${RANDOM_MODE} -W 70 "$HTTP_CODE Failure!"
else
	HTTP_BODY=${HTTP_RESPONSE:0:${#HTTP_RESPONSE}-3}
	echo $HTTP_BODY | sed -e 's/[{""}]/''/g' | cowsay -f ${RANDOM_COW} -${RANDOM_MODE} -W 70
fi
