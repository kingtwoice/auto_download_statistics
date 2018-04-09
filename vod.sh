#!/bin/bash

function gzipfile {
	local file=${1}_00-${DOMAIN}*;
	if [ $1 -lt 10 ];then
		file=0$file;
	fi
	filepath=$(find "$(pwd)" -name "$file");
	if [[ $filepath == *.gz ]];then
		gzip -d $filepath;
		filepath=${filepath%.*};	
	fi
}

function get_watchperson { 
	local str=$(awk '{if(match($7,/.*\.ts/)&& $9<400)data[$4]++}END{for(i in data)print data[i],i}' $1 | sort -rn | head -1);
	num=$(echo $str | cut -d" " -f1);
        appeartime=$(echo $str | cut -d" " -f2);
        appeartime=${appeartime#*:};
        [[ $num -gt $MAX ]] && MAX=$num;
}

SERVICE=xzitvcnvod;
DOMAIN=vfile.xzitv.cn;
TIME=$(date -d '1 day ago' +%F);
OUTPUTFILE=$(pwd)/${TIME}_vod.txt;
MAX=0;
TASKFILE=/root/emailtask/task_cdnvod;
/root/autodown.sh -s $SERVICE -D $DOMAIN;
#gzipfile 1;
#[[ -f $filepath ]] && echo "yes" || echo "no"
echo "$TIME,视频点播在线人数统计" > $OUTPUTFILE;
for((i=1;i<=24;i++));do
	gzipfile $i;
	[[ -f $filepath ]] && get_watchperson $filepath;
	let j=$i-1;
 	echo "======= $j:00 至 $i:00 =======" >> $OUTPUTFILE;
	echo "视频点播在线人数峰值: $num" >> $OUTPUTFILE;
	echo "出现时间: $appeartime" >> $OUTPUTFILE;
	echo >> $OUTPUTFILE;
  	[[ -f $filepath ]] && rm -f $filepath;
done

sed -i -e "2i\视频点播在线人数峰值:$MAX" -e '2i\以下为分时段统计' $OUTPUTFILE;
[[ -f $OUTPUTFILE ]] && echo $OUTPUTFILE >> $TASKFILE;
echo "<--FINISH-->" >> $TASKFILE;
