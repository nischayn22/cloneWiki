#!/bin/bash
#sh cloneWiki.sh --oldwikipath=testnew --newwikipath=testnew2 --olddbname=testnew --newdbname=testnew2 --dbusername=root --dbpassword=""

for i in "$@"
do
case $i in
    -e=*|--oldwikipath=*)
    OLDWIKIPATH="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--newwikipath=*)
    NEWWIKIPATH="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--olddbname=*)
    olddbname="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--newdbname=*)
    newdbname="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--dbusername=*)
    dbusername="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--dbpassword=*)
    dbpassword="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done
err=0
[[ -z ${OLDWIKIPATH} ]] && { echo "OLDWIKIPATH argument not provided"; err=1; }
[[ -z ${NEWWIKIPATH} ]] && { echo "NEWWIKIPATH argument not provided"; err=1; }
[[ -z ${olddbname} ]] && { echo "olddbname argument not provided"; err=1; }
[[ -z ${newdbname} ]] && { echo "newdbname argument not provided"; err=1; }
[[ -z ${dbusername} ]] && { echo "dbusername argument not provided"; err=1; }
[[ -z ${dbpassword} ]] && { echo "dbpassword argument not provided"; err=1; }

[[ err -eq 1 ]] && { echo "Please fix errors and try again"; exit 1; }

echo "Creating directory for new wiki..."
$(mkdir ${NEWWIKIPATH});
echo "Copying old wiki files to new wiki directory..."
err=0
for x in ${OLDWIKIPATH}/*; do
  echo "$x -> ${NEWWIKIPATH}/${x##*/}"
  cp -r "$x" "${NEWWIKIPATH}/"
done
echo "Creating new wiki db..."
mysql --user=${dbusername} --password=${dbpassword} -e "CREATE DATABASE ${newdbname};"
echo "Copying old wiki db to new wiki db..."
mysqldump --user=${dbusername} --password=${dbpassword} ${olddbname} | mysql --user=${dbusername} --password=${dbpassword} ${newdbname}