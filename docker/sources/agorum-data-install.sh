#!/bin/bash
echo "create /opt/agorum/data.install from initial setup"
mkdir /opt/agorum/data.install
mkdir /opt/agorum/data.install/mysql
mkdir /opt/agorum/data.install/solr
mkdir /opt/agorum/data.install/zookeeper
mkdir /opt/agorum/data.install/jboss
mkdir /opt/agorum/data.install/log
#mkdir /opt/agorum/data.install/scripts

mv /opt/agorum/scripts /opt/agorum/data.install
mv /opt/agorum/agorumcore/storage /opt/agorum/data.install
mv /opt/agorum/agorumcore/mysql/data /opt/agorum/data.install/mysql
mv /opt/agorum/agorumcore/solr/nodes /opt/agorum/data.install/solr
mv /opt/agorum/agorumcore/zookeeper/data /opt/agorum/data.install/zookeeper
mv /opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/autoupdate/auto-install-plugins /opt/agorum/data.install/jboss
mv /opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/lib/properties.jar /opt/agorum/data.install/jboss
mv /opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/config /opt/agorum/data.install/jboss
mv /opt/agorum/agorumcore/jboss/server/default/deploy/jms/mysql-jdbc-service.xml /opt/agorum/data.install/jboss
mv /opt/agorum/agorumcore/jboss/server/default/statistics.json /opt/agorum/data.install/jboss

mkdir /opt/agorum/data.install/jboss/agorumcorebackendtransactions
rm -fr /opt/agorum/agorumcore/jboss/server/default/agorumcorebackendtransactions

rm -f /opt/agorum/agorumcore/jboss/server/default/statistics.json
mv /opt/agorum/agorumcore/jboss/server/default/log /opt/agorum/data.install/log/jboss
mv /opt/agorum/agorumcore/solr/server/logs /opt/agorum/data.install/log/solr
mv /opt/agorum/agorumcore/zookeeper/zookeeper.out /opt/agorum/data.install/log/zookeeper.out

rm -fr /opt/agorum/data.install/mysql/data/*.err
rm -fr /opt/agorum/data.install/mysql/data/*.pid
rm -fr /opt/agorum/data.install/mysql/data/ib_logfile*
rm -fr /opt/agorum/data.install/log/jboss/*
rm -fr /opt/agorum/data.install/log/solr/*
truncate -s 0 /opt/agorum/data.install/log/zookeeper.out
rm -f /opt/agorum/install_config.properties
rm -f /opt/agorum/setup-agorum-core-server-linux-pro-*.bin
rm -f /opt/agorum/agorumcoreocr-linux.zip
rm -f /opt/agorum/agorum-data-install.sh

touch /opt/agorum/data.install/.done
