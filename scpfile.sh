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
#/root/tongji.sh -i ip -f $file;

gzip -d `ls *xzitv*.gz 2>/dev/null` 2>/dev/null;
awk 'BEGIN{totalcount=0;totalpv=0;total200=0;total403=0;total404=0;total500=0;total504=0;}
        {data[$1]++;code[$1,$9]++;if(match($7,/\.html|\/$|\/\?/)>0&&$9<400)pv[$1]++;}
        END{for(i in data){
        printf("%-10s%-30s%10d%10d%10d%8d%6d%6d\n",data[i],i,pv[i],code[i,200],code[i,403],code[i,404],code[i,500],code[i,504]);
        totalcount+=data[i];totalpv+=pv[i];total200+=code[i,200];total403+=code[i,403];total404+=code[i,404];total500+=code[i,500];total504+=code[i,504];
        }
        pct=total200*100/totalcount;str200=sprintf("%3.2f",pct)"%";
        pct=total403*100/totalcount;str403=sprintf("%3.2f",pct)"%";
        pct=total404*100/totalcount;str404=sprintf("%3.2f",pct)"%";
        pct=total500*100/totalcount;str500=sprintf("%3.2f",pct)"%";
        pct=total504*100/totalcount;str504=sprintf("%3.2f",pct)"%";
        printf("%-10s%-25s%10d%10d%10d%8d%6d%6d%7s%7s%7s%7s%7s\n",totalcount,"总次数[PV|200|403|404|500|504]",totalpv,total200,total403,total404,total500,total504,str200,str403,str404,str500,str504);
        }' `ls *xzitv*` | sort -rn > $file.txt;
/usr/bin/scp -oStrictHostKeyChecking=no $file.txt root@node1.test.com:/root/$file.txt;
sed -r 's@[[:space:]]+@,@g#' $file.txt > $file.csv;
fi
#[ -f $file.txt ] && rm -f $file.txt;

