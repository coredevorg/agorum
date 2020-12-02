#!/bin/bash
# entrypoint.sh initialize data volume on first run 
set -e # exit script on error

STAT=/opt/agorum/data/.state
LOG=/opt/agorum/data/.log
IP=/opt/agorum/data/.ip

function state() {
    echo "$1" > "$STAT" 
}

function log() {
    local stamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$@" && echo "$stamp $@" >> $LOG
}

state "entrypoint"
log "entrypoint $@"

HOST=$(ifconfig eth0 | grep inet | awk '{print $2}')
echo "$HOST" > "$IP"
echo "$HOST   roihost" >> /etc/hosts
log "using network address $HOST"

# check arguments from run command and exec entry script
[ "$1" ] && { CMD="$1" ; shift ; exec "$CMD" "$@" ; }

state "initialize"

function sigterm_handler() {
    state "sigterm"
    log "received SIGTERM, stopping agorumcore ..."
    /opt/agorum/agorumcore/scripts/agorumcore stop
    state "stopped"
    cat /dev/null > $IP
    log "agorumcore stopped, exit container process"
    exit 143
}


[ -f /opt/agorum/data/.done ] || {
    log echo "initalize data volume with data.install"
    cp -r /opt/agorum/data.install/. /opt/agorum/data
}


# chown not working with vmhgfs mounts from VMware Fusion (?)
grep /opt/agorum/data /etc/mtab | grep -q vmhgfs-fuse || {
    [ "$( stat -c '%U' /opt/agorum/data/mysql/data )" == "mysql" ] || {
        log "adjust mysql ownership"
        chown -R mysql:mysql /opt/agorum/data/mysql/data
    }   
}

[ -L /opt/agorum/agorumcore/mysql/data ] || {
    log "linking agorumcore directories to data volume"
    ln -s /opt/agorum/data/mysql/data /opt/agorum/agorumcore/mysql/data
    ln -s /opt/agorum/data/solr/nodes /opt/agorum/agorumcore/solr/nodes
    ln -s /opt/agorum/data/zookeeper/data /opt/agorum/agorumcore/zookeeper/data
    ln -s /opt/agorum/data/storage /opt/agorum/agorumcore/storage
    ln -s /opt/agorum/data/jboss/properties.jar /opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/lib/properties.jar
    ln -s /opt/agorum/data/jboss/config /opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/config
    ln -s /opt/agorum/data/jboss/mysql-jdbc-service.xml /opt/agorum/agorumcore/jboss/server/default/deploy/jms/mysql-jdbc-service.xml
    ln -s /opt/agorum/data/jboss/agorumcorebackendtransactions /opt/agorum/agorumcore/jboss/server/default
    ln -s /opt/agorum/data/jboss/statistics.json /opt/agorum/agorumcore/jboss/server/default
    ln -s /opt/agorum/data/jboss/auto-install-plugins /opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/autoupdate/auto-install-plugins
    ln -s /opt/agorum/data/log/jboss /opt/agorum/agorumcore/jboss/server/default/log
    ln -s /opt/agorum/data/log/solr /opt/agorum/agorumcore/solr/server/logs
    ln -s /opt/agorum/data/log/zookeeper.out /opt/agorum/agorumcore/zookeeper/zookeeper.out
}

# start agorumcore and wait for SIGTERM
trap 'sigterm_handler' SIGTERM

state "starting"
log "starting agorumcore ..."
/opt/agorum/agorumcore/scripts/agorumcore start
state "running"
log "agorumcore running, waiting for container termination ..."
while true ; do tail -f /dev/null & wait ${!} ; done
