#!/bin/bash
#	date   : 2017-10-30
#	author : kingtwoice
#	version: v1.0
#
#查找文件的通配符字符串
PWD=$(pwd);
#通配符文件
FILEPATH=/root/tp;
FIND_GZIP=$(cut -d" " -f1 $FILEPATH);
#查找解压后的文件通配符字符串
FIND_LOG=$(cut -d" " -f2 $FILEPATH);
#解压现有日志
function GZIPFILE {
GZFILES=$(find "$PWD" -name "$FIND_GZIP");
echo "开始解压文件";
for i in $GZFILES;do
	if gzip -d $i &> /dev/null;then
		echo "$i : 解压成功";
	else
		echo "$i : 解压失败";
	fi
	echo;
done
return 0;
}
#AWK 根据条件进行分析
function AWK_FUNC {
#$1 需要显示的列在日志中以空格分隔后的索引数组
#$2 是否进行URL过滤，0:不过滤;1:正向过滤(包含,多个字符串时为并且的关系即全包含);2:反向过滤(不包含，多个字符串时为不全包含);
#$3 是否进行Refer过滤，0:不过滤;1:正向过滤;2:反向过滤;
#$4 是否进行User-Agent过滤，0:不过滤;1:正向过滤;2:反向过滤;
#$5 是覆盖输出还是追加输出，1:覆盖;2:追加;
#$6 AWK输入文件
#$7 AWK输出文件
#$8 指定awk 分隔符FS 0为默认分隔符,1为\"(双引号),用来取完整的User-Agent,仅当用户只统计User-Agent一项数据时选择此分隔符进行计算
#$9 urlfilterstr ，url的过滤字符串，多个以空格分开
#$10 referfilterstr ，refer的过滤字符串，多个以空格分开
#$11 uafilterstr ，user-agent的过滤字符串，多个以空格分开
#$12 ttype,统计类型,0为统计次数,1为统计流量大小
#$13 是否进行HttpCode过滤,0不过滤,1正向过滤,2反向过滤;
#$14 codefilterstr,Http Code的过滤字符串,多个以空格分开
#$15 是否进行IP过滤,0不过滤,1过滤;
#$16 ipfilterstr,IP过滤字符串,多个以空格分开,可以用*通配符

#echo 1:$1;
#echo 2:$2;	
#echo 3:$3;	
#echo 4:$4;	
#echo 5:$5;	
#echo 6:$6;	
#echo 7:$7;	
#echo 8:$8;	
#echo 9:$9;	
#echo 10:${10};	
#echo 11:${11};	
#echo 12:${12};
#echo 13:${13};
#echo 14:${14};
#echo 15:${15};
#echo 16:${16};
#return 0;
#echo $(cat "$6" | wc -l);
	local AWKTEMPFILE=$(mktemp "$PWD"/awk.XXXXX);
	awk -v a="$1" -v uf="$2" -v rf="$3" -v uaf="$4" -v cf="${13}" -v ipf="${15}" -v s="$8" -v urlfilterstr="$9" -v referfilterstr="${10}" -v uafilterstr="${11}" -v codefilterstr="${14}" -v ipfilterstr="${16}" -v ttype="${12}" 'BEGIN{
		if(s==1){
			FS="\"";
		}
		len=split(a,arr," ");
		len0=split(ipfilterstr,ipstr," ");
		len1=split(urlfilterstr,urlstr," ");
		len2=split(referfilterstr,referstr," ");
		len3=split(uafilterstr,uastr," ");
		len4=split(codefilterstr,codestr," ");
	}
	{
	c="";
	for(j=1;j<=len;j++) 
		c=c" "$arr[j];
	if(s==0){
	f0=0;f1=0;f2=0;f3=0;f4=0;
	
	if(ipf>0){
		include=0;
		for(i=1;i<=len0;i++){
			j=split(ipstr[i],temip,".");
			split($1,temip2,".");
			flag=0;
			while(j>0){
				if(temip[j]!="*"){
					min=temip[j]-temip2[j];
					if(min==0){
						j--;
						continue;
					}else{
						flag=1;
						break;
					}
				}	
				j--;
			}
			if(flag==0)
				include++;
		}
		f0=include>0 ? 1:2;
	}

	if(uf>0){
	include=0;
	for(i=1;i<=len1;i++){
		if(match($7,urlstr[i])!=0)
			include++;
		}
		f1=include>0 ? 1:2;			
	}	

	if(rf>0){
		include=0;
		for(i=1;i<=len2;i++){
			if(match($11,referstr[i])!=0)
				include++;
		}
		f2=include>0 ? 1:2;			
	}

	if(uaf>0){
		include=0;
		for(i=1;i<=len3;i++){
			if(match($12,uastr[i])!=0)
				include++;
		}
		f3=include>0 ? 1:2;			
	}

	if(cf>0){
		include=0;
		for(i=1;i<=len4;i++){
			if(index(codestr[i],"x")>0){
				temp=codestr[i];
				templen=gsub("x",0,temp);
				tempnum=10;
				while(templen>1){
					tempnum *=10;
					templen--;
				}
				tempresult = $9-temp;
				if(tempresult>=0 && tempresult<tempnum)
					include++;
			}else{
				if($9==codestr[i])
					include++;
			}
		}
		f4=include>0 ? 1:2;
	}

	if(ipf==f0&&uf==f1&&rf==f2&&uaf==f3&&cf==f4){
		if(ttype==0)
			IP[c]++;
		else
			IP[c]+=$10;
	}
	}else{
		f3=0;
		if(uaf>0){
			include=0;
			for(i=1;i<=len3;i++){
				if(index($6,uastr[i])>0)
					include++;
			}		
			f3=include>0? 1:2;
		}
		if(uaf==f3){
			if(ttype==0)
				IP[c]++;
			else{
				split($3,size," ");
				IP[c]+=size[2];
			} 
		}
	}
	}
	END{
		for(i in IP){
			print IP[i],i;
		} }' $6 | sort -rn > $AWKTEMPFILE;


	if [ $5 -eq 1 ];then
		/bin/cp -rf $AWKTEMPFILE $7 &> /dev/null;
	else
		cat $AWKTEMPFILE >> $7;
	fi
	
	#[ -f $AWKTEMPFILE ] && rm -f $AWKTEMPFILE &> /dev/null;

}
#统计数据
function GET_DATA {
#	local arr=($1);
# 	let len=${#arr[*]}+1;
	STOREFILE=$PWD/$6.txt;
	echo "正在统计${10}数据...";
        TEMPFILE=$(mktemp "$PWD"/$6.XXXXX);
	LOGFILES=$(find "$PWD" -name "$FIND_LOG");
	local INDEX=1;
	for i in $LOGFILES;do
		local PARA=("$1" "$2" "$3" "$4" "$INDEX" $i $TEMPFILE "$5" "$URL_FILTER_STR" "$REFER_FILTER_STR" "$UA_FILTER_STR" "$7" "$8" "$CODE_FILTER_STR" "$9" "$IP_FILTER_STR");
		AWK_FUNC "${PARA[@]}";
		let INDEX+=1;
	done
	#return 0;
	if [ $INDEX -gt 1 ];then
		awk -v t="$7" 'BEGIN{
			size[0]="Byte";
			size[1]="KB";
			size[2]="MB";
			size[3]="GB";
			size[4]="TB";
		}	
		{
			c="";
			for(j=2;j<=NF;j++) 
				c=c" "$j;
			IP[c]+=$1;
		}
		END{
			total=0;
			for( i in IP){
				if(t<1){
					print IP[i],i;
				}else{
					x=IP[i];
					j=0;
					while(x>1024){
						x /=1024;
						j++;
					}
					x=x""size[j];
					print IP[i],x,i;
				}
				total+=IP[i];
			}
			if(t<1){
				print total,"总次数";
			}else{
				x=total;
				j=0;
				while(x>1024){
					x /=1024;
					j++;
				}
				x=x""size[j];
				print total,x,"总流量";
			}
		}' $TEMPFILE | sort -rn > $STOREFILE
	else
		mv $TEMPFILE $STOREFILE;
	fi
	echo "统计结果存放在:$STOREFILE";
}
#设置auto的值
#function SET_AUTO { 
#	if [[ $1 -ge 0 && $1 -le 1 ]];then
#		 auto=$1;
#		return 0;
#	else 
#		return 1;
#	fi
#}
#设置item的值
function SET_ITEM {
	if [[ $1 == "ua" || $1 == "UA" ]];then
		item=$item" "$UA_INDEX_1;
		seperator=1;
		return 0;
	fi
	OLD_IFS="$IFS"; 
	IFS="," ;
	local arr=($1); 
	IFS="$OLD_IFS";
	item="";
	for s in ${arr[@]};do
 		 case "$s" in
		 ip|IP)
		   item=$item" "$IP_INDEX;
		;;
		 time|TIME)
		   item=$item" "$TIME_INDEX;
		;;
		 url|URL)
		   item=$item" "$URL_INDEX;
		;;
		 code|CODE)
		   item=$item" "$CODE_INDEX;
		;;
		 refer|REFER)
		   item=$item" "$REFER_INDEX;
		;;
		 ua|UA)
		   item=$item" "$UA_INDEX;
		  #let seperator=1;
		;;
		 pv|PV)
		   item=$item" "$URL_INDEX;
		   urlfilter=1;
		   referfilter=2;
		   uafilter=2;
		;;
		*)
		  return 1;
		 esac
	done
	return 0;
}
#设置urlfilter的值
#function SET_FILTER {
#eval $2=$1;
#return $?;
	#if [[ $1 == 0 || $1 == 1 || $1 == 2 ]];then
	#	eval $2=$1;
#		return 0;
#	else 
#		return 1;
#	fi
#}

#设置referfilter的值
#function SET_REFERFILTER {
#	if [[ $1 -ge 0 && $1 -le 2 ]];then
#		 referfilter=$1;
#		return 0;
#	else 
#		return 1;
#	fi
#}
#设置uafilter的值
#function SET_UAFILTER {
#	if [[ $1 -ge 0 && $1 -le 2 ]];then
#		 uafilter=$1;
#		return 0;
#	else 
#		return 1;
#	fi
#}

#设置type auto的值
function SET_VAL {
eval $2=$1;
return $?;
#	if [[ $1 == 0 || $1 == 1 ]];then
#		eval $2=$1;
#		return 0;
#	else 
#		return 1;
#	fi
}
#赋值出错时打印使用方法
function PRINT_ERR {
	echo -ne "\033[31m";
	echo "Usage(用法): $0 -a|--auto={0|1} -t|--type={0|1} -i|--item={ip|url|time|code|refer|ua} -uf|--url-filter={0|1|2} -rf|--refer-filter={0|1|2} -uaf|--ua-filter={0|1|2} -cf|--code-filter={0|1|2} -ipf|--ip-filter=*{0|1|2} -f|--out-file={filename} -d|--delete-logfile={0|1} -s|--send-mail={0|1} -to {email-address} -mc {0|1} -cfg File";
	echo -ne "\033[0m";
	echo -ne "\033[32m";
	echo "-a|--auto 是否开启自动统计,0为不开启(默认),1为开启,开启后其余参数自动设置";
	echo "-t|--type 统计类型,0统计次数(默认),1统计流量";
	echo "-i|--item 统计项目,可以是单项数据如 ip,可以是多项数据ip,url;参数以逗号分开,参数意义为同一IP对同一URL的次数统计,参数之间在统计时是并且的关系";
        echo "-uf|--url-filter 是否开启URL过滤,0为不开启(默认),1为正向过滤包含,多个时只要包含其中一个即可;2为反向过滤不包含,多个时所有都同时不包含";
	echo "-rf|--refer-filter 是否开启过滤非正常Refer,0不开启(默认),1为正向,2为反向";
	echo "-uaf|--ua-filter 是否开启过滤非正常User-Agent,0不开启(默认),1为正向,2为反向";
	echo "-cf|--code-filter 是否开启过滤HTTP CODE,0不开启(默认),1为正向,2为反向";
	echo "-ipf|--ip-filter 是否开启过滤IP,0不开启(默认),1为正向,2为反向";
	echo "-f|--out-file 输出文件名";
	echo "-d|--delete-logfile 完成统计后是否删除日志文件,0不删除(默认),1删除";
	echo "-s|--semd-mail 统计完成后是否发送邮件,0不开启(默认),1开启";
	echo "-to 'email-address' 邮件发送地址,默认值为$(cat /root/emailuser1),多个以逗号分开"; 
	echo "-mc 是否开启月自动统计,0为不开启(默认),1为开启";
	echo "-cfg 文件名，手动引入配置文件";
	echo -e "\033[0m";
	return 0;
}
function CHECK_EXIT {
	if [[ $1 -ne 0 ]];then
		PRINT_ERR;
		exit 2;
	fi
}

function RM_LOGFILE {
	for i in $LOGFILES;do
		[ -f $i ] && rm -f $i &> /dev/null;
	done
	return 0;
}

function SEND_EMAIL {
	#SUBJECT="CDN数据统计";
	#DATE=$(date -d '1 day ago' +%Y-%m-%d);
	#echo "这是$DATE，CDN上的日志统计数据，包含栏目页和内容页，httpcode为2xx和3xx，User-Agent为正常用户值。请查收！" | mailx -s $SUBJECT -a $STOREFILE $EMAILUSER
	#合并任务
	[[ -f $STOREFILE ]] && echo $STOREFILE >> $TASKFILE;
}

function CLEAR_UP {
	[ -f $TEMPFILE ] && rm -f $TEMPFILE &> /dev/null;
	[ -f $AWKTEMPFILE ] && rm -f $AWKTEMPFILE &> /dev/null;
}

function CHECK_MONTH_FIRSTDAY {
	local tests=$(date +%d);
	if [[ "$tests" == "01" ]];then
       		local incre=1;
		local index=0;
        	local temp=$(date -d $incre' day ago' +%d);
		local lastmonth=$(date -d '1 month ago' +%Y-%m);
        	while [ "$temp" != "01" ];do
                	logdate[$index]=$PWD/$lastmonth-$temp.txt;
                	let incre++;
                	temp=$(date -d $incre' day ago' +%d);
			let index++;
        	done
        	logdate[$index]=$PWD/$lastmonth-$temp.txt;
		LAST_MONTH_FILE=$lastmonth.txt;
		LAST_MONTH_FILE_TEMP=$(mktemp $PWD/$LAST_MONTH_FILE.XXXXX);
		if [ $auto -eq 1 ];then
			echo "wait for..";	
		else
			[ -f $LAST_MONTH_FILE ] && cat /dev/null  > $LAST_MONTH_FILE;
			for f in ${logdate[*]};do
				[ -f $f ] && sed '1d' $f >> $LAST_MONTH_FILE_TEMP;
			done
			awk '{
                        	c="";
                        	for(j=2;j<=NF;j++) 
                                	c=c" "$j;
                       	 	IP[c]+=$1;

                	     }END{
				total=0;
                        	for( i in IP){
					print IP[i],i;
					total+=IP[i];			
			     }
				print total,"总记录数";
			     }' $LAST_MONTH_FILE_TEMP | sort -rn > $LAST_MONTH_FILE
	
		fi
		[ -f $LAST_MONTH_FILE_TEMP ] && rm -f $LAST_MONTH_FILE_TEMP &> /dev/null;
		tar -zcf $lastmonth.cdn.tar.gz $lastmonth*.txt;
		#SUBJECT="$lastmonth，CDN月数据统计";
		#echo "这是$lastmonth月,CDN上一个月的日志统计数据总和，压缩包tar.gz为$lastmonth月中每一天的统计数据,用作留底检查。请查收！" | mailx -s $SUBJECT -a $LAST_MONTH_FILE -a $lastmonth.cdn.tar.gz $EMAILUSER
		#[ -d /usr/king/ ] || mkdir -p /usr/king
                #mv $lastmonth.cdn.tar.gz /usr/king/
		#rm -f $lastmonth*.txt &> /dev/null;
		#合并任务
		[[ -f $LAST_MONTH_FILE ]] && echo $LAST_MONTH_FILE >> $TASKFILE;
		[[ -f $lastmonth.cdn.tar.gz ]] && echo $lastmonth.cdn.tar.gz >> $TASKFILE;
		fi
}

function SET_AUTO_VALUES {
	filename=$(date -d '1 day ago' +%Y-%m-%d)_$1.txt;
	ttype=0;
	seperator=0;
	urlfilter=0;
        referfiler=0;
        uafilter=0;
        codefilter=0;
        ipfilter=0;
        seperator=0;
case "$1" in
IP)
	item=$IP_INDEX; 
	ipfilter=2;
;;
CODE)
	item=$CODE_INDEX; 
;;
IP_TIME)
	item=$IP_INDEX" "$TIME_INDEX;
;;
IP_URL)
	item=$IP_INDEX" "$URL_INDEX;
;;
URL_TIME)
	item=$URL_INDEX" "$TIME_INDEX;
;;
IP_TIME_URL)
	item=$IP_INDEX" "$URL_INDEX" "$TIME_INDEX;
;;
PV_CODE_OK)
	item=$URL_INDEX;
	urlfilter=1;
	codefilter=1;
;;
PV_CODE_UA_OK)
	item=$URL_INDEX;
	urlfilter=1;
	uafilter=1;
	codefilter=1;
;;
INNER_IP_HTML)
	item=$IP_INDEX" "$URL_INDEX;
	urlfilter=1;
	ipfilter=1;
;;
OUTTER_IP_HTML)
	item=$IP_INDEX" "$URL_INDEX;
	urlfilter=1;
	ipfilter=2;
;;
UA_ERROR)
	item=$UA_INDEX_1;
	seperator=1;
	uafilter=2;
;;
UA_HTML_ERROR)
	item=$URL_INDEX" "$UA_INDEX;
	uafilter=2;
;;
esac
}

#ip在日志中以空格分隔后的索引
IP_INDEX="1";
#time在日志中以空格分隔后的索引
TIME_INDEX="4 5"
#url在日志中以空格分隔后的索引
URL_INDEX="7"
#code在日志中以空格分隔后的索引
CODE_INDEX="9"
#refer在日志中以空格分隔后的索引
REFER_INDEX="11"
#ua在日志中以空格分隔后的索引
UA_INDEX="12"
#ua在日志中以\"分隔后的索引
UA_INDEX_1="6"

#URL过滤默认关闭
urlfilter=0;
#Refer过滤默认关闭
referfilter=0;
#User-Agent过滤默认关闭
uafilter=0;
#Http Code过滤默认关闭
codefilter=0;
#IP 过滤默认关闭
ipfilter=0;
#URL过滤字符串默认值
URL_FILTER_STR="\\\.html /$";
#Refer过滤字符串默认值
REFER_FILTER_STR="http";
#User-Agent过滤字符串默认值
UA_FILTER_STR="Mozilla AppleCoreMedia Safari Opera Chrome WeChat Dalvik";
#Http Code过滤字符串默认值
CODE_FILTER_STR="20x 30x";
#IP过滤字符串默认值
IP_FILTER_STR="182.150.46.143 220.182.4.137 218.2.102.114";
#seperator AWK分隔符, 0默认，1为\"(双引号)
seperator=0;
#自动统计默认关闭
auto=0;
#统计结果文件保存名 默认值
filename=$(date -d '1 day ago' +%Y-%m-%d);
#删除日志文件
deletelog=0;
#是否发送邮件
sendmail=0;
#邮件用户文件
EMAILFILE=$PWD/emailuser;
#邮件发送地址;
EMAILUSER=$(cat $EMAILFILE);
#统计类型,0为统计次数 默认值 
ttype=0;
item="7";
#是否开启月统计
monthcheck=0;
#自动统计文件名
AUTO_FILE=("IP" "CODE" "IP_URL" "IP_TIME" "URL_TIME" "IP_TIME_URL" "PV_CODE_OK" "PV_CODE_UA_OK" "INNER_IP_HTML" "OUTTER_IP_HTML" "UA_ERROR" "UA_HTML_ERROR");
#配置文件
cfgfile=$PWD/tongji.conf;
#邮件任务文件
TASKFILE=$PWD/emailtask/task_cdnpv;
if [[ $# == 0 ]];then
	 urlfilter=1;
	 codefilter=1;
fi

while [ $# != 0 ];do
case "$1" in
-a)
	shift;
	SET_VAL $1 "auto";
	CHECK_EXIT $?;
	shift;
;;
--auto=*)
	SET_VAL ${1#*=} "auto";
	CHECK_EXIT $?;
	shift;
;;
-t)
	shift;
	SET_VAL $1 "ttype";
	CHECK_EXIT $?;
	shift;
;;
--type=*)
	SET_VAL ${1#*=} "ttype";
	CHECK_EXIT $?;
	shift;
;;
-i)
	shift;
	SET_ITEM $1;
	CHECK_EXIT $?;
	shift;
;;
--item=*)
	SET_ITEM ${1#*=};
	CHECK_EXIT $?;
	shift;
;;
-uf)
	shift;
	SET_VAL $1 "urlfilter";
	CHECK_EXIT $?;
	shift;
	
;;

--url-filter=*)
	SET_VAL ${1#*=} "urlfilter";
	CHECK_EXIT $?;
	shift;
;;

-rf)
	shift;
	SET_VAL $1 "referfilter";
	CHECK_EXIT $?;
	shift;

;;

--refer-filter=*)
	SET_VAL ${1#*=} "referfilter";
	CHECK_EXIT $?;
	shift;
;;

-uaf)
	shift;
	SET_VAL $1 "uafilter";
	CHECK_EXIT $?;
	shift;

;;

--ua-filter=*)
	SET_VAL ${1#*=} "uafilter";
	CHECK_EXIT $?;
	shift;
;;
-cf)
	shift;
	SET_VAL $1 "codefilter";
	CHECK_EXIT $?;
	shift;
;;

--code-filter=*)
	SET_VAL ${1#*=} "codefilter";
	CHECK_EXIT $?;
	shift;
;;

-ipf)
	shift;
	SET_VAL $1 "ipfilter";
	CHECK_EXIT $?;
	shift;
;;

--ip-filter=*)
	SET_VAL ${1#*=} "ipfilter";
	CHECK_EXIT $?;
	shift;
;;

-f)
	shift;
	filename=$1;	
	shift;
;;
--out-file=*)
	filename=${1#*=};
	shift;
;;
-d)
	shift;
	SET_VAL $1 "deletelog";
	CHECK_EXIT $?;
	shift;
;;
--delete-logfile=*)
	SET_VAL ${1#*=} "deletelog";
	CHECK_EXIT $?;
	shift;
;;
-s)
	shift;
	SET_VAL $1 "sendmail";
	CHECK_EXIT $?;
	shift;
;;
--send-mail=*)
	SET_VAL ${1#*=} "sendmail";
	CHECK_EXIT $?;
	shift;
;;
-to)
	shift;
	EMAILUSER=$1;
	shift;
;;
-mc)
	shift;
	SET_VAL $1 "monthcheck";
	CHECK_EXIT $?;
	shift;
;;
-cfg) 
	shift;
	SET_VAL $1 "cfgfile";
	CHECK_EXIT $?;
	shift;
;;
*)
	CHECK_EXIT 1;
;;
esac
done
trap 'CLEAR_UP' INT EXIT QUIT ABOR KILL TERM;
#[ -f ./tongji.conf ] && . ./tongji.conf;
#[ -f ./tongji.index ] && . ./tongji.index;
if [ -f $cfgfile ]; then
        . $cfgfile
fi
GZIPFILE
if [ $auto -eq 1 ];then
#	deletelog=0;
#	sendmail=0;
	for i in ${AUTO_FILE[@]};do
		SET_AUTO_VALUES $i;
		PARA=("$item" "$urlfilter" "$referfilter" "$uafilter" "$seperator" "$filename" "$ttype" "$codefilter" "$ipfilter" "$i");
		GET_DATA "${PARA[@]}"
	done
else
	PARA=("$item" "$urlfilter" "$referfilter" "$uafilter" "$seperator" "$filename" "$ttype" "$codefilter" "$ipfilter" "相关");
	GET_DATA "${PARA[@]}"
fi

[ $deletelog -eq 1 ] && RM_LOGFILE

[ $sendmail -eq 1 ] && SEND_EMAIL

[ $monthcheck -eq 1 ] && CHECK_MONTH_FIRSTDAY
#合并完成
echo "<--FINISH-->" >> $TASKFILE;
#echo "urlfilter:$urlfilter";
#echo "referfilter:$referfilter";
#echo "uafilter:$uafilter";
#echo "item:${item[*]}";
#echo "seperator:$seperator";
#echo "auto:$auto";
#echo "codefilter:$codefilter";
