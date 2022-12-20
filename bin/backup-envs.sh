#!/bin/bash
# shellcheck disable=
#
# Find all env files & put their content in envs.txt file
# & optionally encrypt the file for backup purposes

ENV_FILES=$(find . -maxdepth 2 -regextype posix-extended -regex '.*(.env(.local)?|env.js)$')
SAVE_FILE="envs_$(date '+%Y-%m-%d').txt"

if [[ -z "$ENV_FILES" ]]; then
  echo -e '\nNo env files found with -maxdepth 2 from: ' "$PWD"
  exit 1
fi

echo -e '\nFound env files at -maxdepth 2\n'
echo "$ENV_FILES"
echo ''

read -r -p "Continue (y/n) " CONT
case $CONT in
y)
  echo "yes"
  ;;
*)
  echo 'Canceling...'
  exit 0
  ;;
esac

{
  echo -e '***********************\n'
  date '+%Y-%m-%d %T'
  echo -e '\n***********************\n'
} > "$SAVE_FILE"

for FILE in $ENV_FILES; do
  {
    echo "$FILE"
    echo ''
    cat "$FILE"
  } >> "$SAVE_FILE"
  echo -e '\n--------------------------\n' >> "$SAVE_FILE"
done

echo "$SAVE_FILE file created"
echo ''

read -r -p "Encrypt $SAVE_FILE file? (y/n) " GPG
case ${GPG:0:1} in
y)
  gpg -c --no-symkey-cache "$SAVE_FILE"
  echo 'Gpg file created'
  echo ''
  read -r -p "Delete .txt file? (y/n) " DELETE
  case ${DELETE:0:1} in
  y)
    rm "$SAVE_FILE"
    echo "$SAVE_FILE deleted"
    ;;
  *)
    echo 'no'
    ;;
  esac
  ;;

*)
  echo 'Skipped encrypting...'
  ;;
esac

echo ''
echo 'env files in folder:'
echo ''
ls -1 ./*env*
