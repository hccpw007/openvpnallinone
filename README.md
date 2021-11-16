the auto script  
`bash <(curl -s -S -L https://github.com/hccpw007/openvpnallinone/raw/main/openvpn.sh) -install`

it maybe not work of the net eroor,you can do the following

1. download the script `openvpn.sh` from the repository root path
```bash
wget https://github.com/hccpw007/openvpnallinone/raw/main/openvpn.sh
```
or `vi openvpn.sh` and then copy the code in the file

2. execute `sh openvpn.sh` and select one
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
