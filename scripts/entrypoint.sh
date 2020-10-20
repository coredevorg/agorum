#!/bin/bash
# entrypoint.sh initialize data volume on first run 
set -e # exit script on error

[ -f /opt/agorum/data/.done ] || {
    echo "initalize mounted data volume with data.install"
    cp -r /opt/agorum/data.install/. /opt/agorum/data
    chown -R mysql:mysql /opt/agorum/data/mysql/data
}

[ -L /opt/agorum/agorumcore/mysql/data ] || {
    echo "linking agorumcore directories to data volume"
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

# startup agorum core
IP=$(ifconfig eth0 | grep inet | awk '{print $2}')
echo "$IP   roihost" >> /etc/hosts
echo "using network address $IP"
/opt/agorum/agorumcore/scripts/agorumcore start
