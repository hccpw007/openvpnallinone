# install script

## download script 
download the script `openvpn.sh` from the repository root path        
`wget https://github.com/hccpw007/openvpnallinone/raw/main/openvpn.sh`            
or `vi openvpn.sh` and then copy the code in the file
## 2. execute `sh openvpn.sh` and select one
```text
[root@vps ~]# sh openvpn.sh 
     -i                            install    一键安装                 (done)
     -a [用户名] [密码]            adduser    一键增加用户             (done)
     -g                            getuser    一键查看所有用户         (done)
     -s [用户名] [ip最后一段]      solid-ip   一键固定客户端IP         (done)
     -o                            output     一键导出配置文件         (done)
     -u                            update     一键更新脚本             (doing)
     -r                            remove     一键卸载OpenVpn          (doing)
     -h                            help       一键查看帮助             (doing)
```
for example `sh openvon.sh -i` will install the openvpn server auto 
# how to use
#### sh openvpn.sh -i
intall the openvpn server,if finish.you can use `netstat -tnlp | grep 1194` check the service is doing  
#### sh openvpn.sh -a username password
add the user ,it will add to a user in the file "/etc/openvpn/server/user/psw-file"

`sh openvpn.sh -a user001 password001`  

`sh openvpn.sh -a user002 password002`

## sh openvpn.sh -g or cat /etc/openvpn/server/user/psw-file
show users and password 

## sh openvpn.sh -s username 'the last part of ip' 
some time ，you need solid static ip for team work, you can solid the vpn inner ip.

for example,

if you add a user "user002" of `sh openvpn.sh -a user001 password001` 

you can do it for solid static ip of user user002

`sh openvpn.sh -s user001 '16'`  

`sh openvpn.sh -s user002 '231'`  

the user user001's ip will solid 

