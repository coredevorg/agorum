#!/bin/bash
# create data.install from agorumcore

[ "$(pwd)" == "/opt/agorum" -a -d agorumcore ] || { echo "script must be run from /opt/agorum" ; exit 1 ; }
[ "$1" == "INIT" ] && OP="mv" || OP="cp -r"

echo "create data.install from initial setup"
[ -d data.install ] || mkdir data.install
rm -rf data.install/*
mkdir data.install/mysql
mkdir data.install/solr
mkdir data.install/zookeeper
mkdir data.install/jboss
mkdir data.install/log
# mkdir data.install/scripts

[ -d scripts ] && $OP scripts data.install || mkdir data.install/scripts
[ -d agorumcore/storage ] && $OP agorumcore/storage data.install || mkdir data.install/storage
$OP agorumcore/mysql/data data.install/mysql
$OP agorumcore/solr/nodes data.install/solr
$OP agorumcore/zookeeper/data data.install/zookeeper
[ -d agorumcore/jboss/server/default/deploy/roi.ear/autoupdate/auto-install-plugins ] && \
    $OP agorumcore/jboss/server/default/deploy/roi.ear/autoupdate/auto-install-plugins data.install/jboss || \
    mkdir data.install/jboss/auto-install-plugins
$OP agorumcore/jboss/server/default/deploy/roi.ear/lib/properties.jar data.install/jboss
$OP agorumcore/jboss/server/default/deploy/roi.ear/config data.install/jboss
$OP agorumcore/jboss/server/default/deploy/jms/mysql-jdbc-service.xml data.install/jboss

[ -f agorumcore/jboss/server/default/statistics.json ] && \
    $OP agorumcore/jboss/server/default/statistics.json data.install/jboss || touch data.install/jboss/statistics.json
$OP agorumcore/jboss/server/default/log data.install/log/jboss
$OP agorumcore/solr/server/logs data.install/log/solr
$OP agorumcore/zookeeper/zookeeper.out data.install/log/zookeeper.out
mkdir data.install/jboss/agorumcorebackendtransactions

[ "$1" == "INIT" ] && {
    rm -fr agorumcore/jboss/server/default/agorumcorebackendtransactions
    rm -f agorumcore/jboss/server/default/statistics.json
    rm -fr data.install/mysql/data/*.err
    rm -fr data.install/mysql/data/*.pid
    rm -fr data.install/mysql/data/ib_logfile*
    rm -fr data.install/log/jboss/*
    rm -fr data.install/log/solr/*
    truncate -s 0 data.install/log/zookeeper.out

    rm -f install_config.properties
    rm -f setup-agorum-core-server-linux-pro-*.bin
    rm -f agorumcoreocr-linux.zip
    rm -f agorum-data-install.sh
    rm -f agorum-setup.sh
}
touch data.install/.done
