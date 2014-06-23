#!/bin/bash

TMP_FILE=/tmp/mp_details.xml
BASE_REPOSITORIES=http://download.eclipse.org/releases/kepler

while getopts "u:p:" OPT; do
  case $OPT in
    u)
      MP_URL=$OPTARG
      ;;
    p)
      ECLIPSE_PATH=$OPTARG
      ;;
    *)
      exit 1
      ;;
  esac
done

curl -o $TMP_FILE $MP_URL/api/p

IUS=`echo 'cat /marketplace/node/ius/iu/text()' | xmllint --shell $TMP_FILE | grep -v "^ --" | grep -v "^/ >" | sed 's/$/.feature.group/' | tr "\\n" "," | sed 's/,$//'`
REPOSITORIES=$BASE_REPOSITORIES','$(echo 'cat /marketplace/node/updateurl/text()' | xmllint --nocdata --shell $TMP_FILE | grep -v "^ --" | grep -v "^/ >")
REPOSITORIES=`echo $REPOSITORIES | sed 's/,$//'`

$ECLIPSE_PATH/eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $REPOSITORIES -installIU $IUS -destination $ECLIPSE_PATH -profile SDKProfile

echo 'Paso 4' >> /tmp/out

