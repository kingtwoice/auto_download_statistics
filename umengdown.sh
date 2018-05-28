#!/bin/bash
# Date   :2017-11-09
# Author :kingtwoice
# Version:v1.0
#
#帐号文件
USERFILE=/root/umenguser;
#用户名
USERNAME=$(cut -d" " -f1 $USERFILE);
#密码
PASSWORD=$(cut -d" " -f2 $USERFILE);
PWD=$(pwd);
function GET_TOKEN {
RND=0.$RANDOM$RANDOM$RANDOM;
LOGINURL="https://passport.alibaba.com/mini_login.htm?lang=zh_cn&appName=youmeng&appEntrance=default&styleType=auto&bizParams=&notLoadSsoView=true&notKeepLogin=false&isMobile=false&cssLink=https://passport.umeng.com/css/loginIframe.css&rnd='$RND'";
RETURN_STR=$(curl $LOGINURL -c ./alibaba.cookie 2>/dev/null);
HISD=$(echo $RETURN_STR | egrep -o 'hsid.{0,3}value="[[:alnum:]]*' | sed -e 's/\(.*value="\)\([[:alnum:]]*\)/\2/');
UMIDTOKEN=$(echo $RETURN_STR | egrep -o 'umidToken.{0,3}value="[[:alnum:]]*' | sed -e 's/\(.*value="\)\([[:alnum:]]*\)/\2/');
CSRFTOKEN=$(echo $RETURN_STR | egrep -o '_csrf_token.{0,3}value="[[:alnum:]]*' | sed -e 's/\(.*value="\)\([[:alnum:]]*\)/\2/');
MODULUS=$(echo $RETURN_STR | egrep -o 'modulus.{0,3}value="[[:alnum:]]*' | sed -e 's/\(.*value="\)\([[:alnum:]]*\)/\2/');
UA="106#+YoBUCBNBcEBGQKaBBBBBpZb54jYt0K19uYYL0Kc94xVs0ZU74FVLCZi5VbYGi0Uk4EZ0itg5uyus0YR9fbYL0i19XrZt5kKBBgbylZc9MMhIaSKBB5byltqmWB/BCBEylmi4gO0ylmbyl6v3pDbOlmbyxzz0q4wylmUPgO0yV4byl6v3pVYt9LKBlYBM+Fv4NEskmGFS5zA5RkRkXcSNpQJnXLj2qUdWmSInWy/1JLqCXbI+UPbuOJanVyS2qXVfRoE4UkMMGLAdQzOnfWghOTSnfDM+Hg5KP9pngCUcJo0t4sL+f7cjOxM5gks3q6V2TSb+VsOFJy5lU2x3OmcgZdFkuiNnIAp3TDO+KkRy8tqvgd1GmnrgTBwnRCn+qMn3TDP6fJ1w+L88f0N6eleIKZ1nX01+IweKWKN2RkRsrS9tusEGmeMPDYg7RBOkwhdAWSs7gD/wJDZlUkInWc1gQDanXyP6qXJoA2Onf0Mc9zp2R2M+4hMQo+sdPZbd8N7CPZiduGuxJWqBCBFt2AD4QiEUy91Z1T1KerAlLvcRfQG5uHwIeHpkLzFfQPzckJ1Wf5+wmJwOu/k22UnwkMM6h0EvBLnfrkKBB7byIDv3pD+BCBo6qyFCmsKBBZM7EXKnboBKAJMQ9fOBCB0Scmi4FrajDSHXJxJDeSHRoh2N4dkECoBo72b1Zwrg2Tn3bM8v0oH3sE+ECoBo7nb1ZwQC9Tn3bM8v0oH3sE+ECoBo72b1Zb1z2Tn3bM8v0oH3sE+ECoBo7nb1Zb1HETn3bM8v0oH3sE+ECoBpRCb1Zb1HETn3bM8v0oH3bY2R25x0Ut+NCoB4meb1ZzzQph+fRM5t0yyjRSkf25/eRakXCY2ONs1BCBo7NFBQ5LKBKbsylDv32BjjDSHNVpql2SHmojA7DyFgBLkf25/lCoBKAJMQ2A5BCBtGlmi4gjB+zTn3JTYVRUn3bY2ONil3Eb+mojA7esKBBZM7EXKNCoB4meb1ZzJhAv+fRM5t0yyjRSkf25/eRakXCY2ONh5BCBtGlmi4gP7eETn3JTYVRUn3bY2ONil3Eb+mojA75LKBKbsylDv3dxJjDSHNVpql2SHmojA7DyFgBLkf25/NCoB4meb1ZzJhjh+fRM5t0yyjRSkf25/eRakXCY2ONh5BCBtGlmi4gPpP2Tn3JTYVRUn3bY2ONil3Eb+mojA75LKBKbsylDv3tCLjDSHNVpql2SHmojA7DyFgBLkf25/NCoB4meb1ZzJYAv+fRM5t0yyjRSkf25/eRakXCY2ONh5BCBtGlmi4gPor2Tn3JTYVRUn3bY2ONil3Eb+mojA75LKBKbsylDv3tdFjDSHNVpql2SHmojA7DyFgBLkf25/NCoB4meb1ZzFDE6+fRM5t0yyjRSkf25/eRakXCY2ONh5BCBtGlmi4gxfozTn3JTYVRUn3bY2ONil3Eb+mojA78yKBBebklDvGCoBpulbDKFF0VXYczN9kiCFUDan3JKNeXd2GCoBpqlbZOFR0VXYYQM8v0oH3yYGj+OuemDKBKjRym9vET0bStF+NmGD3ST6jRMA8iEzfQsiBCB9ScBy4xx0tn4Wj5QR0mr+fESHON/83oEGGCoBAnlblOF80VmUuEN9kiCFUDan3z5rWgO6mC==";

curl -c ./mmstat.cookie -e $LOGINURL "http://log.mmstat.com/v.gif?logtype=1&title=%u53CB%u76DF+%20%u7528%u6237%u4E2D%u5FC3&pre=&cache=3c3acc9&scr=1920x1080&cna=MylNEWhDFhICAbaWLo8XdCjB&spm-cnt=0.0.0.0.d37b4d50kuXwN&category=&uidaplus=&aplus&yunid=&&trid=0b83e0e615103100233575440e5eb9&asid=AQAAAACHgAVa+aC4WgAAAABDVdQ+EL4hjA==&p=1&o=win10&b=chrome50&s=1920x1080&w=webkit&ism=pc&lver=7.6.17&jsver=aplus_std&tag=1&stag=-1&ltag=-1" 2>/dev/null;
#UA=$(echo $RETURN_STR | egrep -o 'UA_InputId.{0,3}value=".*>' | sed -e 's/\(.*value="\)\(.*\)\(\">\)/\2/');
#echo UA:$UA;
#echo $MODULUS > ./rsa_rand;
echo $HISD;
echo $UMIDTOKEN;
echo $CSRFTOKEN;
#echo $MODULUS;
#openssl genrsa -out ./rsa.pem -rand ./rsa_rand; 
#openssl rsautl -encrypt -in umengpwd -inkey ./rsa.pub -out ./umengpwd.en;
#PASSWORD=$(cat ./umengpwd.en); 
#echo $PASSWORD;
}

#模拟滑动验证码
function CHECK_CODE {
	NOCAPPKEY="CF_APP_TBLogin_PC";
	#CODETOKEN="df9d574e423acb0aa27f2e617ad7b4c757deebc4";
	local url="https://cf.aliyun.com/nocaptcha/analyze.jsonp?";
	local a="a="$NOCAPPKEY"&";
	local t="t="$UMIDTOKEN"&";
	local n="n="$UA"&";
	local p="p=\{\"isMobile\":\"false\",\"fm-login-id\":\"lvchenggang@hoge.cn\"\}&";
	local s="scene=&";
	local y="asyn=0&";
	local l="lang=zh_CN&";
	local v="v=849&";
	local c="callback=jsonp_0"$RANDOM$RANDOM$RANDOM;
	RETURN_STR=$(curl -X GET -b ./alibaba.cookie $url$a$t$n$p$s$y$l$v$c 2>/dev/null);
	local jsonpstr=$(echo $RETURN_STR | sed -e 's/\(jsonp_[[:digit:]]*(\)\(.*\)\();\)/\2/');
	local CHECK_FLAG=$(echo $jsonpstr | jq .result.code);
	if ! [ $CHECK_FLAG -eq 0 ];then
		return 1;
	fi
	SIG=$(echo $jsonpstr | jq .result.value | sed s/\"//g);
	CSESSIONID=$(echo $jsonpstr | jq .result.csessionid | sed s/\"//g);
	return 0;
}

function CHECK_BLOCK {
	local timestamp=$(date +%s)000;
	RETURN_STR=$(curl -e $LOGINURL -b ./mmstat.cookie "https://gm.mmstat.com/jstracker.2?type=9&id=jstracker&v=1&nick=&islogin=&msg=block&file=&ua=&line=&scrolltop=&screen=&t='$timestamp'" 2>/dev/null);
	curl -e $LOGINURL -b ./mmstat.cookie "https://gm.mmstat.com/tbspm.1.1?cache=c776b2c&gmkey=CLK&gokey=href%3Djavascript%3AnoCaptcha.reset(1)%26spm%3D0.0.0.0.30d87257SZ2IvF&cna=MylNEWhDFhICAbaWLo8XdCjB&spm-cnt=0.0.0.0.30d87257SZ2IvF&logtype=2" 2>/dev/null;
	echo $RETURN_STR;
}

#登录umeng,现已更改为登录alibaba再转umeng验证。
function LOGIN {
if [ $# -eq 0 ];then
RETURN_STR=$(curl -l -H "Content-Type:application/x-www-form-urlencoded;charset=UTF-8" -e 'https://passport.alibaba.com/mini_login.htm?lang=zh_cn&appName=youmeng&appEntrance=default&styleType=auto&bizParams=&notLoadSsoView=true&notKeepLogin=false&isMobile=false&cssLink=https://passport.umeng.com/css/loginIframe.css&rnd='$RND'' -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -H "Host:passport.alibaba.com" -H "Origin:https://passport.alibaba.com" -H "X-Requested-With:XMLHttpRequest" -X POST -d 'loginId='$USERNAME'&password2='$PASSWORD'&checkCode=&appName=youmeng&appEntrance=default&bizParams=&ua='$UA'&hsid='$HSID'&rdsToken=&umidToken='$UMIDTOKEN'&isRequiresHasTimeout=false&isRDSReady=true&isUMIDReady=true&umidGetStatusVal=255&lrfcf=&lang=zh_cn&scene=&isMobile=false&screenPixel=1920x1080&navlanguage=zh-CN&navUserAgent=Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36&navAppVersion=&navPlatform=Win32&token=&nocAppKey=&csessionid=&sig=&captchaToken=&_csrf_token='$CSRFTOEKN'' -b ./alibaba.cookie "https://passport.alibaba.com/newlogin/login.do?fromSite=-2&appName=youmeng" 2>/dev/null);
else
RETURN_STR=$(curl -l -H "Content-Type:application/x-www-form-urlencoded;charset=UTF-8" -e 'https://passport.alibaba.com/mini_login.htm?lang=zh_cn&appName=youmeng&appEntrance=default&styleType=auto&bizParams=&notLoadSsoView=true&notKeepLogin=false&isMobile=false&cssLink=https://passport.umeng.com/css/loginIframe.css&rnd='$RND'' -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -H "Host:passport.alibaba.com" -H "Origin:https://passport.alibaba.com" -H "X-Requested-With:XMLHttpRequest" -X POST -d 'loginId='$USERNAME'&password2='$PASSWORD'&checkCode=&appName=youmeng&appEntrance=default&bizParams=&ua='$UA'&hsid='$HSID'&rdsToken=&umidToken='$UMIDTOKEN'&isRequiresHasTimeout=false&isRDSReady=true&isUMIDReady=true&umidGetStatusVal=255&lrfcf=&lang=zh_cn&scene=&isMobile=false&screenPixel=1920x1080&navlanguage=zh-CN&navUserAgent=Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36&navAppVersion=&navPlatform=Win32&token='$UMIDTOKEN'&nocAppKey='$1'&csessionid='$2'&sig='$3'&captchaToken=&_csrf_token='$CSRFTOEKN'' -b ./alibaba.cookie "https://passport.alibaba.com/newlogin/login.do?fromSite=-2&appName=youmeng" 2>/dev/null);
fi
echo $RETURN_STR;
LOGIN_FLAG=$(echo $RETURN_STR | jq .content.data.loginType 2>/dev/null);
if [[ $LOGIN_FLAG == "\"pwdLogin\"" ]];then
	ST=$(echo $RETURN_STR | jq .content.data.st | sed s/\"//g 2>/dev/null); echo ST:$ST ;return 0;
else
	ST=1DmwLm0pkzEa-6ZYluVBDPg;
	return 0;
fi
}

function REGISTER_UMENG {
	RETURN_STR=$(curl -e "https://passport.umeng.com/login" -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -H ":authority:passport.umeng.com" -H ":method:GET" -H ":path:/login/register?st=$ST&appId=&redirectUrl=undefined" -H ":scheme:https" -X GET -c ./umeng.cookie -v "https://passport.umeng.com/login/register?st=$ST&appId=&redirectUrl=undefined" >./registerumeng);
echo "======reg=========================";
echo $RETURN_STR;
echo "==================================";
}

function TEST_LOGIN {
	RETURN_STR=$(curl -e "http://passport.umeng.com/user/products" -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -H ":authority:web.umeng.com" -H ":method:GET" -H ":path:/main.php?c=site&a=show" -H ":scheme:https" -X GET -b ./umeng.cookie "https://web.umeng.com/main.php?c=site&a=show" 2>/dev/null);
	echo $RETURN_STR | grep -o "$USERNAME"  &>/dev/null  &&  echo $RETURN_STR | grep -o "正常登录" &>/dev/null && return 0 || return 1
}

#删除重复下载的日志
function RM_OLD_FILE {
	local len=${#logfile[*]};
	for ((i=0;i<len;i++));do
		local file=$PWD/${logfile[$i]};
		[ -f $file ] && rm -rf $file &> /dev/null;
	done
	return 0;
}

function SET_DOWNLOADURLFILE_BY_DAY {
	local st="";
	local t=0;
	local start="";
	local end=$(date -d '1 days ago' +%Y-%m-%d);
	for ((i=0;i<$DAY;i++)) ;do
		let t=$DAY-$i;
		st=$(date -d $t' days ago' +%Y-%m-%d);
		[ $i -eq 0 ] && start=$st;
		[ $TYPE -eq 1 ] && echo "https://web.umeng.com/main.php?c=cont&a=page&ajax=module=report&siteid=1259818451&st=$st&et=$st&tabIndex=1&sourcetype=&source=&condtype=&condname=&condvalue=&downloadType=csv $PWD/$st.csv.temp" >> $DOWNLOADURLFILE;
	done
	[ "$start" == "$end" ] && local filename=$PWD/$start.csv.temp || local filename=$PWD/$start-$end.csv.temp ;
	[ $TYPE -eq 0 ] && echo "https://web.umeng.com/main.php?c=cont&a=page&ajax=module=report&siteid=1259818451&st=$start&et=$end&tabIndex=1&sourcetype=&source=&condtype=&condname=&condvalue=&downloadType=csv $filename" > $DOWNLOADURLFILE;
}

function SET_DOWNLOADURLFILE_BY_MONTH {
	local m=$(date -d $MONTH' month ago' +%m);
	local beginday=$(date -d $MONTH' month ago' +%Y-%m-01);
	local timestamp=$(date -d $beginday +%s);
	local nowstamp=$(date +%s);
	local oneday=86400;
	local mm=$m;
	local start="";
	local index=0;
	while [ $mm -eq $m -a $timestamp -le $nowstamp ];do
		[ $index -eq 0 ] && start=$beginday;
		[ $TYPE -eq 1 ] && echo "https://web.umeng.com/main.php?c=cont&a=page&ajax=module=report&siteid=1259818451&st=$beginday&et=$beginday&tabIndex=1&sourcetype=&source=&condtype=&condname=&condvalue=&downloadType=csv $PWD/$beginday.csv.temp" >> $DOWNLOADURLFILE;
		let timestamp+=$oneday;
		beginday=$(date -d @$timestamp +%F);
		mm=$(date -d $beginday +%m);
		let index++;
	done	
	if [ $TYPE -eq 0 ];then
		let timestamp-=$oneday;
		local end=$(date -d @$timestamp +%F);
		echo "https://web.umeng.com/main.php?c=cont&a=page&ajax=module=report&siteid=1259818451&st=$start&et=$end&tabIndex=1&sourcetype=&source=&condtype=&condname=&condvalue=&downloadType=csv $PWD/$start-$end.csv.temp" > $DOWNLOADURLFILE;
	fi
}

function SET_DOWNLOADURLFILE_BY_DATE {
	echo "https://web.umeng.com/main.php?c=cont&a=page&ajax=module=report&siteid=1259818451&st=$DATE&et=$DATE&tabIndex=1&sourcetype=&source=&condtype=&condname=&condvalue=&downloadType=csv $PWD/$DATE.csv.temp" > $DOWNLOADURLFILE;
}

#下载友盟受访页面文件
function DOWNLOAD_UMFILE {
	TOTAL=$(cat $DOWNLOADURLFILE | wc -l 2>/dev/null);
	echo "开始友盟受访页面文件,下载日志存放在umengdownload.log中";
	while read LINE;do 
		local url=$(echo $LINE|cut -d" " -f 1);
	 	local filename=$(echo $LINE|cut -d" " -f 2);
		wget --no-check-certificate  --load-cookies=./umeng.cookie --keep-session-cookies -a $DOWNLOADLOGFILE -O $filename -U "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" $url ;
		storefile=${filename%*.temp};
		iconv -f gbk -t utf8 $filename -o $storefile &>/dev/null;
		[ -f $filename ] && rm -f $filename;
	done < $DOWNLOADURLFILE;
	[ -f $DOWNLOADURLFILE ] && rm -f $DOWNLOADURLFILE;
}

function MERGE_URL {
	[ -f $storefile ] || return 1;
	if [ $TYPE -eq 0 ];then
		mergefile=${storefile%*.csv}_url_merge.csv;
		awk 'BEGIN{FS=",";OFS=",";}$1~/^http/{
			uri="";
			if(index($1,"?")>0||index($1,"#")>0){
				split($1,url,/[?#]/);
				uri=url[1];
			}
			else{
				uri=$1;
			}
                        gsub("tv.cn","tv.com",uri);
			ARR[uri]+=$2;
		}END{
			for(i in ARR){
                        	print i,ARR[i];
                	}
		}' $storefile | sort -t ',' -rn -k 2 > $mergefile;
		sed -i '1i\受访页面,访问次数' $mergefile;
	fi
}

function SEND_EMAIL {
	[ $TYPE -eq 1 ] && return 1;
	if [ $1 -eq 1 ];then
		local lastmonth=$(date -d '1 month ago' +%Y-%m);
		tar -zcf $lastmonth.umeng.tar.gz $lastmonth*.csv;
		#local subject="$lastmonth，友盟月数据统计";
		#echo "这是$lastmonth月，友盟上的访问数据，附件.csv为友盟上一个月的总数据下载文件，附件url_merge.csv为URL合并后的统计文件，附件.tar.gz为上一月每一天的数据文件打包，用作留底检查，请查收！" | mailx -s $subject -a $storefile -a $mergefile -a $lastmonth.umeng.tar.gz $EMAILUSER
		#[ -d /usr/king/ ] || mkdir -p /usr/king
		#mv $lastmonth.umeng.tar.gz /usr/king/
		#rm -f $lastmonth*.csv &> /dev/null;	
		#任务合并
		[[ -f $storefile ]] && echo $storefile >> $TASKFILE;
		[[ -f $mergefile ]] && echo $mergefile >> $TASKFILE;
		[[ -f $lastmonth.umeng.tar.gz ]] && echo $lastmonth.umeng.tar.gz >> $TASKFILE;
	else
		#subject="友盟数据统计";
        	#local date=${storefile%%.*};
		#date=${date##*/};
        	#echo "这是$date，友盟上的访问数据，附件.csv文件为友盟下载文件，附件url_merge.csv为URL合并后统计文件。请查收！" | mailx -s $subject -a $storefile -a $mergefile $EMAILUSER
		#任务合并
		[[ -f $storefile ]] && echo $storefile >> $TASKFILE;
		[[ -f $mergefile ]] && echo $mergefile >> $TASKFILE;
	fi
	return 0;
}

function CHECK_MONTH_FIRSTDAY {
	local tests=$(date +%d);
        if [ "$tests" == "01" ];then
		return 0;
	fi
	return 1;

}

#CTRL+C前的清理
function CLEAR_UP {
	[ -f $DOWNLOADURLFILE ] && rm -rf $DOWNLOADURLFILE &> /dev/null;
	return 0;
}

function TRY_DOWNLOAD_AGAIN {
        echo "友盟日志未下载成功或数据有误，已重新尝试下载" | mailx -s "友盟日志自动下载出错"  $EMAILADM;
	[ $1 -eq 0 ] && eval SET_DOWNLOADURLFILE_BY_$FUNFLAG && DOWNLOAD_UMFILE && return 0;
	[ $1 -eq 1 ] && SET_DOWNLOADURLFILE_BY_MONTH && DOWNLOAD_UMFILE && return 0;
}

#月任务
function MONTH_MISSION {
if CHECK_MONTH_FIRSTDAY ;then
        MONTH=1;
        SET_DOWNLOADURLFILE_BY_MONTH;
        DOWNLOAD_UMFILE;
        [ -f $storefile ] || TRY_DOWNLOAD_AGAIN 1;
        [ $MERGE -eq 1 ] && MERGE_URL;
        [ $SEND_EMAIL -eq 1 ] && SEND_EMAIL 1;
fi
}

#下载日志
DOWNLOADLOGFILE=$PWD/umengdownload.log;
cat /dev/null > $DOWNLOADLOGFILE;
#页面地址临时文件
DOWNLOADURLFILE=$(mktemp $PWD/umengdownload.XXXXX);
#默认下载为前一天
DAY=1;
#默认是一个月前的月份
MONTH=1;
#默认是按输入时间段下载单个文件
TYPE=0;
#默认为今天
DATE=$(date +%F);
#邮件接收人
EMAILFILE=/root/emailuser;
EMAILFILE1=/root/emailuser1;
EMAILUSER=$(cat $EMAILFILE);
EMAILADM=$(cat $EMAILFILE1);
#邮件任务文件
TASKFILE=/root/emailtask/task_umeng;
#是否合并URL
MERGE=0;
#是否发送邮件,仅当TYPE为0时发送。即只有单个文件时发送。
SEND_EMAIL=0;
#默认调用BY_DAY方法进行下载地址文件进行设置
FUNFLAG="DAY";
#是否开启月统计
MC=0;
function SET_VAL {
	eval $2=$1;
}
function PRINT_ERR {
	echo -ne "\033[31m";
        echo "Usage: $0 -d 最近几天 -m 某个月前 -D 具体某一天时间 -t {0,1} 0:按输入时间下载单个文件(默认),1:按天为单位下载一个或多个文件 -M {0|1} 0:不合并URL,1:合并URL -s {0|1} 0:不发送邮件,1:发送邮件 -mc {0|1} 1:开启月统计,默认为0";
	echo -ne "\033[0m";
        return 0;
}
function CHECK_EXIT {
        if [[ $1 -ne 0 ]];then
                PRINT_ERR;
                exit 2;
        fi
}

while [ $# != 0 ];do
case "$1" in
-d)
	shift;
	SET_VAL $1 "DAY";
	CHECK_EXIT $?;
	FUNFLAG="DAY";
	#SET_DOWNLOADURLFILE_BY_DAY;
	shift;
;;
-m)
        shift;
        SET_VAL $1 "MONTH";
	CHECK_EXIT $?; 
	#SET_DOWNLOADURLFILE_BY_MONTH;
	FUNFLAG="MONTH";
	shift; 
;;
-D)
        shift;
        SET_VAL $1 "DATE";
	CHECK_EXIT $?;
	#SET_DOWNLOADURLFILE_BY_DATE;
	FUNFLAG="DATE";
        shift;
;;
-t)
	shift;
	SET_VAL $1 "TYPE";
	CHECK_EXIT $?;
	shift;
;;
-M)
 	shift;
	SET_VAL $1 "MERGE";
	CHECK_EXIT $?;
	shift;
;;
-s)	
	shift;
	SET_VAL $1 "SEND_EMAIL";
	CHECK_EXIT $?;
	shift;
;;
-mc)	
	shift;
	SET_VAL $1 "MC";
	CHECK_EXIT $?;
	shift;
;;
*)
	CHECK_EXIT 1;
;;
esac
done
trap 'CLEAR_UP' INT EXIT QUIT ABOR KILL TERM;
eval SET_DOWNLOADURLFILE_BY_$FUNFLAG;
if TEST_LOGIN;then
echo "友盟登录成功";
DOWNLOAD_UMFILE;
else
	GET_TOKEN;
	if ! LOGIN;then
		CHECK_CODE;
		recode=$?;
		check_time=0;
		until  [[ $recode == 0 || $check_time == 3 ]];do
			CHECK_BLOCK;
			sleep 1;
			CHECK_CODE;
			recode=$?;
			let check_time+=1;
			sleep 2;
		done
		if [ $recode -eq 0 ];then
			LOGIN $NOCAPPKEY $CSESSIONID $SIG;
		else
			echo "滑动验证失败";
			#CLEAR_UP;
			exit 1;
		fi
	fi
	REGISTER_UMENG;
	if TEST_LOGIN;then
		echo "友盟登录成功";
		DOWNLOAD_UMFILE;
	else
		#CLEAR_UP;
		echo "Login failed";
		exit 1;
	fi
fi
[ -f $storefile ] && [ $(wc -l $storefile | cut -d' ' -f1) -gt 50 ] || TRY_DOWNLOAD_AGAIN 0;
[ $MERGE -eq 1 ] && MERGE_URL;
[ $SEND_EMAIL -eq 1 ] && SEND_EMAIL 0;
[ $MC -eq 1 ] && MONTH_MISSION;
#合并完成
echo "<--FINISH-->" >> $TASKFILE;
