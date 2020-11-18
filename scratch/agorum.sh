#!/bin/zsh
# set -x
WORKDIR="/Users/bst/Develop/agorum/code"
cd "$WORKDIR" || exit 1
VM="agorum-core-digitec"
MOUNT="digitec/private"

case "$1" in

start)  agorum vm start "$VM"
        agorum mount "$MOUNT"
        PRIVATE=$(mount | grep $MOUNT | sed 's/.* on \(.*\) (.*/\1/')
        ln -sf "${PRIVATE}/Administration/customers/cdev.core" .
        export GIT_DIR="$(pwd)/.git"
        vc -n cdev.core 
        ;;

stop)   [ -L cdev.core ] && rm cdev.core
        agorum umount "$MOUNT"
        agorum vm stop "$VM"
        ;;

status) vmrun list
        mount | grep $MOUNT
        ;;
        
*)      echo "usage: $(basename $0) start|stop"
        exit 2
        ;;

esac
