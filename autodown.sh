#!/bin/bash
# Date   :2017-11-03
# Author :kingtwoice
# Version:v1.0
#
#帐号文件
USERFILE=/root/cdnuser;
#用户名
USERNAME=$(cut -d" " -f1 $USERFILE);
#密码
PASSWORD=$(cut -d" " -f2 $USERFILE);
PWD=$(pwd);
#登录UPYUN
function LOGIN {
RETURN_STR=$(curl -l -H "Content-type: application/json" -e "https://console.upyun.com/login/" -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -H "x-requested-with:XMLHttpRequest" -H ":authority:console.upyun.com" -H ":method:POST" -H ":path:/accounts/signin/" -H ":scheme:https" -X POST -d '{"username":"'$USERNAME'","password":"'$PASSWORD'"}' https://console.upyun.com/accounts/signin/ -c ./upyun.cookie 2>/dev/null);
#echo $RETURN_STR;
LOGIN_FLAG=$(echo $RETURN_STR | jq .msg.messages[0] 2>/dev/null);
if [[ $LOGIN_FLAG == "\"登录成功\"" ]];then
	return 0;
else
	return 1;
fi
}

#分析并记录日志下载地址,需提前安装jq, yum install jq -y;
function GET_DOWNLOAD_ADDR {
echo "开始分析日志下载地址";
local RETURN=$(curl -l -e "https://console.upyun.com/toolbox/log/log_analy/" -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -H "x-requested-with:XMLHttpRequest" -H ":authority:console.upyun.com" -H ":method:GET" -H ":path:/api/analysis/archives/?bucket_name=$SERVICE&date=$DATE&domain=$DOMAIN&useSsl=true" -H ":scheme:https" -X GET -b ./upyun.cookie "https://console.upyun.com/api/analysis/archives/?bucket_name=$1&date=$2&domain=$3&useSsl=true" 2>/dev/null);
#echo $RETURN;

local datalist=$(echo $RETURN | jq ".data.data | length" 2>/dev/null);
if [[ $datalist -lt 1 ]];then
	return 1;
fi
if [[ $TIME == "*" ]];then
        for((i=0;i<=23;i++));do
        TOTAL[$i]=$i;
        done
        else
        local tempstr=$(echo "$TIME" | awk 'BEGIN{FS=","}{for(i=1;i<=NF;i++)
                                {if(index($i,"-"))
                                        {split($i,test,"-");
                                        for(j=test[1]-1;j<test[2];j++) printf j " ";} 
                                else printf ($i-1) " ";}
                          }');
	TOTAL=($tempstr);
        fi



ARR=$(echo $RETURN | jq ".data.data" 2>/dev/null);
totallen=${#TOTAL[*]};
local index=0;
for i in ${TOTAL[@]};do
        local temp=$(echo $ARR | jq ".[$i].url");
	local urls=$(echo $temp | sed s/\"//g);
	URL[$index]=$urls;
	logfile[$index]=${urls##*/};
	if [ $index -eq 0 ];then
		echo $urls > $DOWNLOADURLFILE;
	else
		echo $urls >> $DOWNLOADURLFILE;
	fi	
	let index+=1;
done
echo "日志下载地址分析结束,准备下载";
return 0;
}

#删除重复下载的日志
function RM_OLD_FILE {
	for f in ${logfile[@]};do
		[ -f $f ] && rm -f $f &> /dev/null
	done
	return 0;
}

#下载日志
function DOWNLOAD_LOGFILE {
	echo "开始下载日志文件,下载日志存放在download.log中";
	wget -c -i $DOWNLOADURLFILE -o $DOWNLOADLOGFILE -U "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36";
	#[ -f $DOWNLOADURLFILE ] && rm -f $DOWNLOADURLFILE;
}

#CTRL+C前的清理
function CLEAR_UP {
	[ -f $DOWNLOADURLFILE ] && rm -f $DOWNLOADURLFILE &> /dev/null;
	return 0;
}
#下载日志
DOWNLOADLOGFILE=$PWD/download.log;
#重试下载日志
RETRYLOGFLE=$PWD/retrydownload.log;
#日志地址临时文件
DOWNLOADURLFILE=$(mktemp "$PWD"/download.XXXXX);
#默认下载为前一天
DAY=1;

#默认服务文件
SERVICEFILE=/root/cdnservice;
#默认下载又拍服务
SERVICE=$(cut -d" " -f1 $SERVICEFILE);
#默认下载域名
DOMAIN=$(cut -d" " -f2 $SERVICEFILE);
#下载日期
DATE=$(date -d $DAY' days ago' +%F);
#下载时间,第几小时的日志,*为1-24,也可写为1-24,多个分开的时间可写为如"5-9 11 13-18"
TIME="*";

EMAILFILE=/root/emailuser1;
EMAILUSER=$(cat $EMAILFILE);

function SET_VAL {
	eval $2=$1;
	return $?;
}
function PRINT_ERR {
	echo -ne "\033[31m";
        echo "Usage: $0 -p 几天之前 -d 日志具体时间(-p -d 使用一个即可,同时使用按最后一个参数的时间执行) -s 又拍服务 -D 绑定域名";
	echo -ne "\033[0m";
        return 0;
}
function CHECK_EXIT {
        if [[ $1 -ne 0 ]];then
                PRINT_ERR;
                exit 2;
        fi
}

function CHECK_COMPLETE {
	completedlen=$(grep -o '100%' $DOWNLOADLOGFILE | wc -l);
	# completedlen=${#completed[*]};
	if [ $completedlen -lt $totallen ];then
		return 1;
	fi	
	return 0;
}

function DOWNLOAD_NOT_COMPLETE {
	for i in ${URL[@]};do
		local filename=${i##*/};
		if ! egrep -o "$filename.{0,3}saved" $DOWNLOADLOGFILE &> /dev/null;then
			echo $i >> $COMPLETEDLOG;
			[ -f $filename ] && rm -f $filename &> /dev/null
			wget -b -c -a $RETRYLOGFLE $i &> /dev/null
		fi
	done
}

while [ $# != 0 ];do
case "$1" in
-p)
	shift;
	SET_VAL $1 "DAY";
	CHECK_EXIT $?;
	#下载日期
	DATE=$(date -d $DAY' days ago' +%F);
	shift;
;;
-d)
        shift;
        SET_VAL $1 "DATE";
	CHECK_EXIT $?;
        shift;
;;
-s)
        shift;
        SET_VAL $1 "SERVICE";
	CHECK_EXIT $?;
        shift;
;;

-D)
        shift;
        SET_VAL $1 "DOMAIN"; 
	CHECK_EXIT $?;
        shift;

;;
-t)
	shift;
	SET_VAL $1 "TIME";
	CHECK_EXIT $?;
	shift;
;;
*)
	CHECK_EXIT 1;
;;
esac
done
trap 'CLEAR_UP' INT EXIT QUIT KILL TERM;
if GET_DOWNLOAD_ADDR $SERVICE $DATE $DOMAIN;then
	RM_OLD_FILE && DOWNLOAD_LOGFILE
else
	if LOGIN;then
		if GET_DOWNLOAD_ADDR $SERVICE $DATE $DOMAIN;then
			RM_OLD_FILE && DOWNLOAD_LOGFILE
		fi
	fi
fi
if ! CHECK_COMPLETE;then
	COMPLETEDLOG=$PWD/completed.log;
	msg="$(date +%F' '%T) -- $SERVICE:$DOMAIN,日志未全部下载完成,已下载:$completedlen;总共:$totallen.附件为具体未下载日志"
	echo $msg > $COMPLETEDLOG;
	echo "未下载日志:" >> $COMPLETEDLOG;
	DOWNLOAD_NOT_COMPLETE
	echo "以上未下载日志，已尝试重新下载。" >> $COMPLETEDLOG;
	echo "$msg" | mailx -s "CDN日志自动下载问题" -a $COMPLETEDLOG $EMAILUSER;
fi
#echo $DATE;
#echo $SERVICE;
#echo $DOMAIN;
