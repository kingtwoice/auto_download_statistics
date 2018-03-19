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
	awk '{if(match($7,/.*(zywszy_sd|1_sd).*\.ts/)) print $7}' $1 | awk '{data[$1]++;}END{for(i in data) print data[i],i}' | sort -rn > $TEMPFILE_ZY;
	awk '{if(match($7,/.*(xzwszy|3_sd).*\.ts/)) print $7}' $1 | awk '{data[$1]++;}END{for(i in data) print data[i],i}' | sort -rn > $TEMPFILE_HY;
# | grep -m 1 zywszy_sd
}

function get_zy {
	local a=$(fgrep -m 1 zywszy_sd $TEMPFILE_ZY | cut -d" " -f1);
	local b=$(fgrep -m 1 1_sd $TEMPFILE_ZY | cut -d" " -f1);
	num=0;
	[ $a -gt 0 ] 2>/dev/null && let num+=$a;
	[ $b -gt 0 ] 2>/dev/null && let num+=$b;
	[ $num -gt $MAX_ZY ] && MAX_ZY=$num;
}

function get_hy {
	local a=$(fgrep -m 1 xzwszy $TEMPFILE_HY | cut -d" " -f1);
        local b=$(fgrep -m 1 3_sd $TEMPFILE_HY | cut -d" " -f1);
        num=0;
        [ $a -gt 0 ] 2>/dev/null && let num+=$a;
        [ $b -gt 0 ] 2>/dev/null && let num+=$b;
	[ $num -gt $MAX_HY ] && MAX_HY=$num;
}

SERVICE=xzitvcnstream;
DOMAIN=stream.xzitv.cn;
TEMPFILE_ZY=video_temp_zy;
TEMPFILE_HY=video_temp_hy;
TIME=$(date -d '1 day ago' +%F);
OUTPUTFILE=${TIME}_video.txt;
MAX_ZY=0;
MAX_HY=0;
TASKFILE=/root/emailtask/task_cdnvideo;
/root/autodown.sh -s $SERVICE -D $DOMAIN;
#gzipfile 1;
#[[ -f $filepath ]] && echo "yes" || echo "no"
echo "$TIME,视频在线人数统计" > $OUTPUTFILE;
for((i=1;i<=24;i++));do
	gzipfile $i;
	[[ -f $filepath ]] && get_watchperson $filepath;
	local j=$i-1;
 	echo "======= $j:00 至 $i:00 =======" >> $OUTPUTFILE;
	get_zy;
	echo "藏语直播在线人数峰值: $num" >> $OUTPUTFILE;
	get_hy;
	echo "汉语直播在线人数峰值: $num" >> $OUTPUTFILE;
	echo >> $OUTPUTFILE;
  	[[ -f $filepath ]] && rm -f $filepath;
done

sed -i -e '2i\汉语直播在线人数峰值:$MAX_HY' -e '2i\藏语在线人数峰值:$MAX_ZY' -e '2i\以下为分时段统计' $OUTPUTFILE;
echo $OUTPUTFILE >> $TASKFILE;
echo "<--FINISH-->" >> $TASKFILE;
