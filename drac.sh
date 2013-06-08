#!/bin/bash
#This script is for dispatching drac wrangling job in seqence manner 

#  1. Taq Master  : /home/controltier/scripts/dvis/taq_master.sh
#  2. Taq Trade   : /home/controltier/scripts/dvis/taq_trade_automation.sh
#  3. Taq quote   : /home/controltier/scripts/dvis/taq_automation.sh



Project=DVSystemOperation
DispatchNode=172.16.30.45

DATE="$1"
test -z "$DATE" && {  DATE=`date --date='1 day ago' +"%Y-%m-%d"` ; }

HOLIDAY="2012-01-02 2012-01-16 2012-02-20 2012-04-06 2012-05-28 2012-07-04 2012-09-03 2012-11-22 2012-12-25"

if [ `echo "$HOLIDAY" | grep -c "$DATE" ` -gt 0 ] ; then
   echo "#[ $DATE ] is NYSE holiday so terminate this job"
   exit

fi

echo -e "\n\n ***"
echo "## [`date +"%H:%M:%S"`] Executing the taq_master wrangling for $DATE trade day"
ctl-exec -p $Project -C 1 -I $DispatchNode  -K -s /home/controltier/scripts/dvis/taq_master.sh -- $DATE

echo -e "\n\n ***"
echo "## [`date +"%H:%M:%S"`] ==> Executing the taq_trade wrangling for $DATE trade day"
ctl-exec -p $Project -C 1 -I $DispatchNode  -K -s /home/controltier/scripts/dvis/taq_trade_automation.sh -- $DATE


echo -e "\n\n ***"
echo "##[`date +"%H:%M:%S"`] ==> Executing the taq_quote wrangling for $DATE trade day"
ctl-exec -p $Project -C 1 -I $DispatchNode  -K -s /home/controltier/scripts/dvis/taq_automation.sh -- $DATE

echo "##[`date +"%H:%M:%S"`] ==> Lets Start s3 uploading"
ctl-exec -p $Project -C 1 -I $DispatchNode  -K -s /home/controltier/scripts/dvis/drac_s3_uploader.sh -- $DATE    

echo "##[`date +"%H:%M:%S"`] ==> dv_drac_upate-ec2"
ctl-exec -p $Project -C 1 -I  OpenNMS.deepvalue.net  -K -s /home/controltier/scripts/dvis/dv_datawareUpdate.sh -- $DATE 
