#!/bin/bash
#	date  : 2017-10-30
#	author: kingtwoice
#	version: v1.0
function SET_VAL {
        eval $2=$1;
}

day=1;
while [ $# != 0 ];do
case "$1" in
-p)
        shift;
        SET_VAL $1 "day";
        shift;
;;
*)
        exit 3;
;;
esac
done
file=$(date -d $day' day ago' +%F)_ip;
if [ -f $file.txt ];then
/usr/bin/scp -oStrictHostKeyChecking=no $file.txt root@node1.test.com:/root/$file.txt;
else
/root/tongji.sh -i ip -f $file;
/usr/bin/scp -oStrictHostKeyChecking=no $file.txt root@node1.test.com:/root/$file.txt;
fi
#[ -f $file.txt ] && rm -f $file.txt;

