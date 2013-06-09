#!/bin/bash

export JAVA_HOME=$HOME/app_packages/jdk1.6.0_30
DVIS_HOME=~/dvis-repo/dvis
EXPORT_DIR=~/emitData
DVIS_VER=2.0-SNAPSHOT
DVIS_LIB="$DVIS_HOME/mysql-connector/5.1.12/mysql-connector-5.1.12.jar:
$DVIS_HOME/log4j/1.2.14/log4j-1.2.14.jar:
$DVIS_HOME/commons-pool/1.3/commons-pool-1.3.jar:
$DVIS_HOME/spring/2.0.1/spring-2.0.1.jar:
$DVIS_HOME/commons-dbcp/1.2.2/commons-dbcp-1.2.2.jar:
$DVIS_HOME/commons-collections/3.2.1/commons-collections-3.2.1.jar:
$DVIS_HOME/commons-net/1.4.1/commons-net-1.4.1.jar:
$DVIS_HOME/activation/1.1/activation-1.1.jar:
$DVIS_HOME/mail/1.4/mail-1.4.jar:
$DVIS_HOME/poi/2.5.1/poi-2.5.1.jar:
$DVIS_HOME/jxl/2.1/jxl-2.1.jar:
$DVIS_HOME/httpclient-cache/4.1.2/httpclient-cache-4.1.2.jar:
$DVIS_HOME/httpclient/4.1.2/httpclient-4.1.2.jar:
$DVIS_HOME/httpcore/4.1.2/httpcore-4.1.2.jar:
$DVIS_HOME/httpmime/4.1.2/httpmime-4.1.2.jar:
$DVIS_HOME//quickfixj-core/1.2.1.9.dv/quickfixj-core-1.2.1.9.dv.jar:
$DVIS_HOME/commons-codec/1.4/commons-codec-1.4.jar:
$DVIS_HOME/commons-logging/1.1.1/commons-logging-1.1.1.jar:
$DVIS_HOME/commons-lang/1.0/commons-lang-1.0.jar:
$DVIS_HOME/json/2.3/json-lib-2.3.jar:
$DVIS_HOME/ezmorph/1.0.6/ezmorph-1.0.6.jar:
$DVIS_HOME/commons-beanutils/1.8.0/commons-beanutils-1.8.0.jar:
$DVIS_HOME/dvis/$DVIS_VER/dvis-$DVIS_VER.jar:
$DVIS_HOME/common/2.4.1/common-2.4.1.jar"

#lets replace \n with no space, so that cloe will run.
DVIS_LIB=`echo $DVIS_LIB | tr '\n' ' '`
DVIS_LIB=`echo $DVIS_LIB | tr -d ' '`

CsvDir=/home/research/RJ-MasterOrderCsv_dir

if [ "$1" = ORDER ] ; then
   CLASS=net.deepvalue.transformation.RJOrdersParser
elif [ "$1" = TRADE ] ; then
  CLASS=net.deepvalue.transformation.RJTradesParser
else
  echo -e "##Undefined operation [$1] " 
  exit 1 
fi

FILE=$2
test ! -s $CsvDir/$FILE && { echo "[ $HOSTNAME  `date +%H:%M:%S` ] => Your specified file [$FILE] doesn't exist at $CsvDir"  ; exit 1 ; }
COMMAND="$JAVA_HOME/bin/java -Xms1024m -Xmx1024m -XX:MaxDirectMemorySize=128m $SERVER_HOT_SPOT -Dlog4j.dir=$DVIS_HOME -Dexport.dir=$SLICE_DIR -classpath .:$DVIS_HOME/resources/:$DVIS_LIB net.deepvalue.boot.DVISEntryPoint $CLASS jdbc:mysql://172.16.30.55:3306/rj_database $CsvDir/$FILE 500"
echo $COMMAND
$COMMAND
