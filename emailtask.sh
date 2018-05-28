#!/bin/bash
# kingtwoice 2018-05-28
function testfile {
for file in $FILES;do
        sed -i '$a\FINISH' $file;
done
}

function clear_last_line {
filelist="";
for file in $FILES;do
	local num=0;
	for line in $(sed '/FINISH/d' $file);do
		filelist=$filelist" -a "$line;
		let num+=1;
	done
	[ $num -eq 0 ] && echo -n > $file && echo "$(date +%F) $file  has no files;" >> $LOGFILE && exit 2;
done
#echo $filelist;
}

function clearfile {
	for file in $FILES;do
		for line in $(cat $file);do
                	[[ $line == *.gz ]] && mv $line /usr/king/ 
        	done
		echo -n > $file;
	done
 find . -maxdepth 1 -regextype "posix-egrep" -mtime +30 -a -regex ".*[0-9]{4}.*(txt|csv)$" |xargs rm -f
}

function send_email {
echo "send email..";
clear_last_line;
subject="牦牦TV数据统计";
echo "牦牦TV数据统计。请查收！" | mailx -s $subject $filelist $EMAILUSER;
[ $? -eq 0 ] && echo $(date +%F) Finish >> $SENDFILE && clearfile;
}

LOGFILE=emailtask/tasklog;
FILES=$(find ./emailtask/ -name "task_*");
TOTALTASK=0;
READY=0;
SENDFILE=emailtask/sendemail
EMAILUSER=wangbing@xzitv.com,huangzhao@xzitv.com;
fgrep "$(date +%F) Finish" $SENDFILE &> /dev/null && exit 0;
LINE=$(cat $SENDFILE | wc -l);
[ $LINE -gt 30 ] && echo -n > $SENDFILE;
for file in $FILES;do
	let TOTALTASK+=1;
	grep "FINISH" $file &>/dev/null && let READY+=1;
done
echo "Ready:$READY,Total:$TOTALTASK";
[ $READY -eq $TOTALTASK ] && send_email;

