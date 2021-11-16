# 1. Install script

## 1.1 Download script 
Download the script `openvpn.sh` from the repository root path                 
`wget https://github.com/hccpw007/openvpnallinone/raw/main/openvpn.sh`                  
or        
`vi openvpn.sh`          
and then copy the code in the file
## 1.2 isntall openvpn server
execute        
`sh openvpn.sh -i`  
intalled the openvpn server,if it finished.       
you can use         
`netstat -tnlp | grep 1194`        
check the service is doing. It maybe view 
```text
[root@vps ~]# netstat -tnlp | grep 1194
tcp        0      0 0.0.0.0:1194            0.0.0.0:*               LISTEN      16760/openvpn       
```
# 2. How to use
```text
[root@vps ~]# sh openvpn.sh 
     -i                            install    一键安装                 (done)
     -a [用户名] [密码]            adduser    一键增加用户             (done)
     -g                            getuser    一键查看所有用户         (done)
     -s [用户名] [ip最后一段]      solid-ip   一键固定客户端IP         (done)
     -u                            update     一键更新脚本             (doing)
     -r                            remove     一键卸载OpenVpn          (doing)
     -h                            help       一键查看帮助             (doing)
```
## 2.1 Add the user 
commond:               
`sh openvpn.sh -a username password`         
add the user ,it will add to a user in the file "/etc/openvpn/server/user/psw-file"  
for example         
`sh openvpn.sh -a user001 password001`       
`sh openvpn.sh -a user002 password002`       
## 2.2 Show all users
You can show all users of the command             
`sh openvpn.sh -g`   or  `cat /etc/openvpn/server/user/psw-file`           
show users and password 
## 2.3 Solid static inner IP
commond: 
sh openvpn.sh -s username 'the last part of ip'        
Some time ，you need solid static ip for team work, you can solid the vpn inner ip.        
for example,you can do it for solid static ip of  user001 and user002      
`sh openvpn.sh -s user001 16`         
`sh openvpn.sh -s user002 231`               
the user user001's ip will solid:  10.8.0.16      
the user user002's ip will solid:  10.8.0.231          
Tips: the scope is  2 ~ 254        
## 2.4 Export config files
The config files in the directory `/etc/openvpn/client-conf`         
you can export they.          
then, use the openvpn client app connect.




