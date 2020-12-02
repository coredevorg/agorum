#!/bin/bash

NAME=$1 ; shift
[ "$2" ] && OPTS="$@" || OPTS="-d" 

IMAGE=agorum
NETWORK=office
DATA=/opt/agorum/data
MOUNT=/mnt/sda1/data/$NAME

INTERACTIVE="-it"
NOSTARTUP="--entrypoint bash"
DETACHED="-d"

STATE=$(docker inspect $NAME 2>/dev/null | jq -r .[0].State.Status)
case "$STATE" in
running) echo "Container [$NAME] already running!"
         ;;
exited)  echo "Starting existing container ..."
         docker start $NAME
         ;;
*)       echo "Creating new container [$NAME] from image [$IMAGE] ..." 
         docker run --network=$NETWORK --name=$NAME -v $MOUNT:$DATA $OPTS $IMAGE
         ;;
esac

IP=$(docker inspect $NAME | jq -r .[0].NetworkSettings.Networks.$NETWORK.IPAddress)
echo "$IP"

# generate local host entry
grep -v "$IP" /etc/hosts > $TMPDIR/hosts.$$
cat <<EOF >>$TMPDIR/hosts.$$
$IP $NAME.$NETWORK.local $NAME
EOF
sudo cp $TMPDIR/hosts.$$ /etc/hosts
