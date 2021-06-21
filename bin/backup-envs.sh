#!/bin/bash
# shellcheck disable=
#
# Find all env files & put their content in envs.txt file
# & optionally encrypt the file for backup purposes

ENV_FILES=$(find . -maxdepth 2 -regex '.*\(.env\|env.js\)$')

if [[ -z "$ENV_FILES" ]]; then
  echo -e '\nNo env files found with -maxdepth 2 from: ' "$PWD"
  exit 1
fi

echo -e '\nFound env files at -maxdepth 2\n'
echo "$ENV_FILES" | xargs -n1
echo ''

read -r -p "Continue (y/n) " CONT
case $CONT in
y)
  echo 'Writing to envs.txt...'
  ;;
*)
  echo 'Canceling...'
  exit 0
  ;;
esac

echo '' > envs.txt

for FILE in $ENV_FILES; do
  {
    echo "$FILE"
    echo ''
    cat "$FILE"
  } >> envs.txt
  echo -e '\n--------------------------\n' >> envs.txt
done

echo 'envs.txt file created'
echo ''

read -r -p "Encrypt envs.txt file? (y/n) " GPG
case ${GPG:0:1} in
y)
  gpg -c --no-symkey-cache envs.txt
  echo 'Gpg file created'
  echo ''
  read -r -p "Delete envs.txt file? (y/n) " DELETE
  case ${DELETE:0:1} in
  y)
    rm envs.txt
    echo 'envs.txt deleted'
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
ls ./*env*
