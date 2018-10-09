#!/bin/bash
userfile=/root/nowapiuser;
usernm=$(cut -d" " -f1 $userfile);
passwd=$(cut -d" " -f2 $userfile);
loginurl="https://www.nowapi.com/index.php?ajax=1"
returnstr=$(curl -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -X POST -d 'usernm='$usernm'&passwd='$passwd'&tourl=&app=accountr.aja_login' $loginurl -c ./nowapi.cookie);
echo $returnstr;
curl -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -b ./nowapi.cookie "https://www.nowapi.com/?app=control" &>/dev/null;
curl -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -b ./nowapi.cookie "https://www.nowapi.com/?app=account.setup&uid=28897" &>/dev/null;
returnstr=$(curl -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" -X POST -d 'app=buyr.aja_package_buy&intid=509&pk=renew&t=1&months=3' $loginurl -b ./nowapi.cookie);
echo $returnstr;

