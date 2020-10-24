#!/bin/bash
set -e
echo "check agorum setup files"
[ "$1"] && GH_TOKEN="$1"
[ "$GH_TOKEN" ] || { echo "missing github token" ; exit 1 ; }
GH_OWNER="coredevorg"
GH_REPO="download"
GH_RELEASE_TAG="agorum-9_5_0_3-1455"
GH_RELEASE_URL="https://api.github.com/repos/$GH_OWNER/$GH_REPO/releases"
GH_AUTH="Authorization: token $GH_TOKEN"
GH_ACCEPT="Accept: application/octet-stream"
response=$(curl -sH "$GH_AUTH" $GH_RELEASE_URL/tags/$GH_RELEASE_TAG)
for name in $(echo $response | jq -r '.assets[].name')
do
    id=$(echo $response | jq --arg name "$name" '.assets[] | select(.name == $name).id')
    echo "$id - $name" 
    [ -f "$name" ] || {
        curl -sLJO -H "$GH_AUTH" -H "$GH_ACCEPT" "$GH_RELEASE_URL/assets/$id"
    }
done
[ -f setup-agorum-core-server-linux-pro-9_5_0_3-1455.bin ] || { echo "missing agorum setup" ; exit 2 ; }
[ -f agorumcoreocr-linux.zip ] || { echo "missing agorum ocr" ; exit 3 ; }
sed -i "s/{{ROI_PASSWORD}}/${ROI_PASSWORD}/"     install_config.properties
sed -i "s/{{MYSQL_PASSWORD}}/${MYSQL_PASSWORD}/" install_config.properties
sed -i "s/{{MYSQL_PASSWORD}}/${MYSQL_PASSWORD}/" mysql-ds.xml

echo "run agorum setup"
export AUTOCONFIG="/opt/agorum/install_config.properties"
BIN=$(ls setup-agorum-core-server-linux-pro-*.bin)
chmod 700 $BIN && ./$BIN unattended

echo "replace mysql driver"
rm /opt/agorum/agorumcore/jboss/server/default/lib/drizzle_jdbc.jar
rm /opt/agorum/agorumcore/jboss/server/default/deploy/mysql-ds.xml
mv /opt/agorum/mysql-connector-java-5.1.*.jar /opt/agorum/agorumcore/jboss/server/default/lib
mv /opt/agorum/mysql-ds.xml /opt/agorum/agorumcore/jboss/server/default/deploy
mkdir agorumcore/storage

echo "unpack agorum core ocr"
unzip agorumcoreocr-linux.zip && mv agorumcoreocr-linux agorumcore/ocr

echo "unpack additional agorum plugins"
INSTALL="/opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/autoupdate/auto-install-plugins"
mkdir -p "$INSTALL" && mv agorumcoreocr-*.zip "$INSTALL"

# start agorum once to initialize environment
/opt/agorum/agorumcore/scripts/agorumcore start
sleep 5
/opt/agorum/agorumcore/scripts/agorumcore stop
