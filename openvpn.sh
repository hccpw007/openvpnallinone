#!/bin/bash
if [ "$1" == '-h' -o ! -n "$1" ]; then
  echo "     -i                            install    一键安装                 (done)"
  echo "     -a [用户名] [密码]            adduser    一键增加用户             (done)"
  echo "     -g                            getuser    一键查看所有用户         (done)"
  echo "     -s [用户名] [ip最后一段]      solid-ip   一键固定客户端IP         (done)"
  echo "     -o                            output     一键导出配置文件         (done)"
  echo "     -u                            update     一键更新脚本             (doing)"
  echo "     -r                            remove     一键卸载OpenVpn          (doing)"
  echo "     -h                            help       一键查看帮助             (doing)"
  exit 0
fi

#更新脚本
if [ "$1" == '-u' ]; then
  echo "========> 更新脚本脚本开始..."
  echo "========> 更新脚本脚本开始..."
  echo "========> 更新脚本脚本结束..."
  echo "========> 更新脚本脚本结束..."
  echo "========> 更新脚本脚本结束..."
  exit 0
fi

#一键固定客户端IP
if [ "$1" == '-s' ]; then
  echo "========> 一键固定客户端IP( 10.8.0.2 ~ 10.8.0.252 )..."
  #判断 用户名 密码是否存在
  if [ ! -n "$2" ]; then
    echo "========> 用户名不能为空"
    exit 0
  fi
  if [ ! -n "$3" ]; then
    echo "========> IP不能为空"
    exit 0
  fi
echo
  echo "ifconfig-push 10.8.0.$3 10.8.0.`expr $3 + 1`" > /etc/openvpn/server/user/ccd/$2
  echo "========> 创建固定$2的ip地址: `cat /etc/openvpn/server/user/ccd/$2`"
  exit 0

  exit 0
fi

#一键查看所有用户
if [ "$1" == '-g' ]; then
  echo "========> 当前系统用户..."
  cat /etc/openvpn/server/user/psw-file
  echo "========> 当前系统用户..."
  exit 0
fi


#一键导出配置文件
if [ "$1" == '-o' ]; then
  echo "========> 一键导出配置文件..."
  mkdir -p /etc/openvpn/client-conf

  /bin/cp -rf /etc/openvpn/server/easy-rsa/ta.key /etc/openvpn/client-conf/ta.key
  /bin/cp -rf /etc/openvpn/server/easy-rsa/pki/ca.crt /etc/openvpn/client-conf/ca.crt
  /bin/cp -rf /etc/openvpn/server/easy-rsa/pki/issued/client.crt /etc/openvpn/client-conf/client.crt
  /bin/cp -rf /etc/openvpn/server/easy-rsa/pki/private/client.key /etc/openvpn/client-conf/client.key
  ovpn='IyAKY2xpZW50CnByb3RvIHRjcC1jbGllbnQKZGV2IHR1bgphdXRoLXVzZXItcGFzcwpyZW1vdGUg5pys5ZywSVAgMTE5NApjYSBjYS5jcnQKY2VydCBjbGllbnQuY3J0CmtleSBjbGllbnQua2V5CnRscy1hdXRoIHRhLmtleSAxCnJlbW90ZS1jZXJ0LXRscyBzZXJ2ZXIKYXV0aC1ub2NhY2hlCnBlcnNpc3QtdHVuCnBlcnNpc3Qta2V5CmNvbXByZXNzIGx6bwp2ZXJiIDQKbXV0ZSAxMA=='
  echo $ovpn | base64 -d >/etc/openvpn/client-conf/client.ovpn
  ip=`curl curl icanhazip.com`
  sed -i "s/本地IP/$ip/g" /etc/openvpn/client-conf/client.ovpn
  echo "scp -r ${USER}@$ip:/etc/openvpn/client-conf 本地位置"
  exit 0
fi

#一键增加用户
if [ "$1" == '-a' ]; then
  echo "========> 一键增加用户..."
  #判断 用户名 密码是否存在
  if [ ! -n "$2" ]; then
    echo "========> 用户名不能为空"
    exit 0
  fi
  if [ ! -n "$3" ]; then
    echo "========> 密码不能为空"
    exit 0
  fi

  echo "$2 $3" >> /etc/openvpn/server/user/psw-file
  echo "========> 创建成功: 用户名: $2, 密码: $3"
  exit 0
fi

#一键安装
if [ "$1" == '-i' ]; then
  echo "========> 一键安装OpenVpn开始..."
  mkdir -p /etc/openvpn
  #  安装expect
  yum install expect -y >/etc/openvpn/aaa.log
  #  安装epel源
  yum install -y epel-release >/etc/openvpn/aaa.log
  echo "========> 更新系统组件..."
  #  yum update -y ;
  #  安装必要组件 ==> yum install -y openssl lzo pam openssl-devel lzo-devel pam-devel
  yum install -y openssl lzo pam openssl-devel lzo-devel pam-devel >/etc/openvpn/aaa.log

  echo "========> 安装easy-rsa..."
  yum install -y easy-rsa >/etc/openvpn/aaa.log
  echo "========> 安装openvpn..."
  yum install -y openvpn >/etc/openvpn/aaa.log

  echo "========> 复制easy-rsa至/etc/openvpn/server..."
  cp -rf /usr/share/easy-rsa/3.0.* /etc/openvpn/server/easy-rsa

  cd /etc/openvpn/server/easy-rsa
  echo "========> 初始化pki..."
  #  ./easyrsa init-pki
  expect -c '
    set timeout 10;
    spawn ./easyrsa init-pki
    expect {
      "Confirm removal" {send "yes\r"; exp_continue}
    }
    interact
    '
  echo "========> 初始化ca..."
  #  ./easyrsa build-ca nopass
  expect -c '
    set timeout 10;
    spawn ./easyrsa build-ca nopass
    expect {
      "Easy-RSA CA" {send "auto\r"; exp_continue}
    }
    interact
    '

  echo "========> 初始化server..."
  ./easyrsa build-server-full server nopass
  echo "========> 初始化client..."
  ./easyrsa build-client-full client nopass
  echo "========> 初始化dh.pem,此过程会比较长..."
  #  ./easyrsa gen-dh

  expect -c '
    set timeout 10;
    spawn ./easyrsa gen-dh
    expect {
      "Overwrite" {send "yes\r"; exp_continue}
    }
    interact
    '

  #  expect <<EOF
  #set timeout 30
  #spawn ./easyrsa gen-dh
  #expect {
  #        "Overwrite" {send "yes\r"; exp_continue}
  #}
  #expect eof
  #EOF

  echo "========> ta.key..."
  openvpn --genkey --secret ta.key

  echo "========> 日志存放目录 /var/log/openvpn/ ..."
  mkdir -p /var/log/openvpn/
  echo "========> 配置权限  ..."
  chown openvpn:openvpn /var/log/openvpn
  echo "========> 用户管理目录 /etc/openvpn/server/user ..."
  mkdir -p /etc/openvpn/server/user
  mkdir -p /etc/openvpn/server/user/ccd
  echo "========> 创建Server配置文件 /etc/openvpn/server/server.conf ..."
  #server_config => server.conf的Base64编码
  server_config='IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwojIFRoaXMgZmlsZSBpcyBmb3IgdGhlIHNlcnZlciBzaWRlICAgICAgICAgICAgICAjCiMgb2YgYSBtYW55LWNsaWVudHMgPC0+IG9uZS1zZXJ2ZXIgICAgICAgICAgICAgICMKIyBPcGVuVlBOIGNvbmZpZ3VyYXRpb24uICAgICAgICAgICAgICAgICAgICAgICAgIwojICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAjCiMgQ29tbWVudHMgYXJlIHByZWNlZGVkIHdpdGggJyMnIG9yICc7JyAgICAgICAgICMKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwpwb3J0IDExOTQKcHJvdG8gdGNwLXNlcnZlcgojIyBFbmFibGUgdGhlIG1hbmFnZW1lbnQgaW50ZXJmYWNlCiMgbWFuYWdlbWVudC1jbGllbnQtYXV0aAojIG1hbmFnZW1lbnQgbG9jYWxob3N0IDc1MDUgL2V0Yy9vcGVudnBuL3VzZXIvbWFuYWdlbWVudC1maWxlCmRldiB0dW4gICAgICMgVFVOL1RBUCB2aXJ0dWFsIG5ldHdvcmsgZGV2aWNlCnVzZXIgb3BlbnZwbgpncm91cCBvcGVudnBuCmNhIC9ldGMvb3BlbnZwbi9zZXJ2ZXIvZWFzeS1yc2EvcGtpL2NhLmNydApjZXJ0IC9ldGMvb3BlbnZwbi9zZXJ2ZXIvZWFzeS1yc2EvcGtpL2lzc3VlZC9zZXJ2ZXIuY3J0CmtleSAvZXRjL29wZW52cG4vc2VydmVyL2Vhc3ktcnNhL3BraS9wcml2YXRlL3NlcnZlci5rZXkKZGggL2V0Yy9vcGVudnBuL3NlcnZlci9lYXN5LXJzYS9wa2kvZGgucGVtCnRscy1hdXRoIC9ldGMvb3BlbnZwbi9zZXJ2ZXIvZWFzeS1yc2EvdGEua2V5IDAKIyMgVXNpbmcgU3lzdGVtIHVzZXIgYXV0aC4KIyBwbHVnaW4gL3Vzci9saWI2NC9vcGVudnBuL3BsdWdpbnMvb3BlbnZwbi1wbHVnaW4tYXV0aC1wYW0uc28gbG9naW4KIyMgVXNpbmcgU2NyaXB0IFBsdWdpbnMKYXV0aC11c2VyLXBhc3MtdmVyaWZ5IC9ldGMvb3BlbnZwbi9zZXJ2ZXIvdXNlci9jaGVja3Bzdy5zaCB2aWEtZW52CnNjcmlwdC1zZWN1cml0eSAzCiMgY2xpZW50LWNlcnQtbm90LXJlcXVpcmVkICAjIERlcHJlY2F0ZWQgb3B0aW9uCnZlcmlmeS1jbGllbnQtY2VydAp1c2VybmFtZS1hcy1jb21tb24tbmFtZQojIyBDb25uZWN0aW5nIGNsaWVudHMgdG8gYmUgYWJsZSB0byByZWFjaCBlYWNoIG90aGVyIG92ZXIgdGhlIFZQTi4KY2xpZW50LXRvLWNsaWVudAojIyBBbGxvdyBtdWx0aXBsZSBjbGllbnRzIHdpdGggdGhlIHNhbWUgY29tbW9uIG5hbWUgdG8gY29uY3VycmVudGx5IGNvbm5lY3QuCmR1cGxpY2F0ZS1jbgpjbGllbnQtY29uZmlnLWRpciAvZXRjL29wZW52cG4vc2VydmVyL3VzZXIvY2NkCiMgaWZjb25maWctcG9vbC1wZXJzaXN0IGlwcC50eHQKc2VydmVyIDEwLjguMC4wIDI1NS4yNTUuMjU1LjAKcHVzaCAiZGhjcC1vcHRpb24gRE5TIDExNC4xMTQuMTE0LjExNCIKcHVzaCAiZGhjcC1vcHRpb24gRE5TIDEuMS4xLjEiCnB1c2ggInJvdXRlIDEwLjkzLjAuMCAyNTUuMjU1LjI1NS4wIgojIGNvbXAtbHpvIC0gREVQUkVDQVRFRCBUaGlzIG9wdGlvbiB3aWxsIGJlIHJlbW92ZWQgaW4gYSBmdXR1cmUgT3BlblZQTiByZWxlYXNlLiBVc2UgdGhlIG5ld2VyIC0tY29tcHJlc3MgaW5zdGVhZC4KY29tcHJlc3MgbHpvCiMgY2lwaGVyIEFFUy0yNTYtQ0JDCm5jcC1jaXBoZXJzICJBRVMtMjU2LUdDTTpBRVMtMTI4LUdDTSIKIyMgSW4gVURQIGNsaWVudCBtb2RlIG9yIHBvaW50LXRvLXBvaW50IG1vZGUsIHNlbmQgc2VydmVyL3BlZXIgYW4gZXhpdCBub3RpZmljYXRpb24gaWYgdHVubmVsIGlzIHJlc3RhcnRlZCBvciBPcGVuVlBOIHByb2Nlc3MgaXMgZXhpdGVkLgojIGV4cGxpY2l0LWV4aXQtbm90aWZ5IDEKa2VlcGFsaXZlIDEwIDEyMApwZXJzaXN0LWtleQpwZXJzaXN0LXR1bgp2ZXJiIDMKbG9nIC92YXIvbG9nL29wZW52cG4vc2VydmVyLmxvZwpsb2ctYXBwZW5kIC92YXIvbG9nL29wZW52cG4vc2VydmVyLmxvZwpzdGF0dXMgL3Zhci9sb2cvb3BlbnZwbi9zdGF0dXMubG9n'
  #控制台显示配置内容
  # echo $server_config | base64 -d | tee /etc/openvpn/server/server.conf
  #控制台不显示配置内容
  echo $server_config | base64 -d >/etc/openvpn/server/server.conf

  echo "========> 注意！！！ 这里创建完配置文件后，需要做个配置文件的软连接，因为当前版本的 openvpn systemd 启动文件中读取的是.service.conf配置。 ..."
  cd /etc/openvpn/server/
  ln -sf server.conf .service.conf

  echo "========> 创建用户密码文件  ..."
  echo "========> 格式是用户 密码以空格分割即可  ..."
  echo "========> 默认用户名: test，默认密码: test  ..."
  tee /etc/openvpn/server/user/psw-file <<EOF
test test
EOF
  chmod 600 /etc/openvpn/server/user/psw-file
  chown openvpn:openvpn /etc/openvpn/server/user/psw-file

  echo "========> 创建密码检查脚本  ..."
  #checkpsw => 密码检查脚本的Base64编码
  checkpsw='IyEvYmluL3NoCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCiMgY2hlY2twc3cuc2ggKEMpIDIwMDQgTWF0aGlhcyBTdW5kbWFuIDxtYXRoaWFzQG9wZW52cG4uc2U+CiMKIyBUaGlzIHNjcmlwdCB3aWxsIGF1dGhlbnRpY2F0ZSBPcGVuVlBOIHVzZXJzIGFnYWluc3QKIyBhIHBsYWluIHRleHQgZmlsZS4gVGhlIHBhc3NmaWxlIHNob3VsZCBzaW1wbHkgY29udGFpbgojIG9uZSByb3cgcGVyIHVzZXIgd2l0aCB0aGUgdXNlcm5hbWUgZmlyc3QgZm9sbG93ZWQgYnkKIyBvbmUgb3IgbW9yZSBzcGFjZShzKSBvciB0YWIocykgYW5kIHRoZW4gdGhlIHBhc3N3b3JkLgpQQVNTRklMRT0iL2V0Yy9vcGVudnBuL3NlcnZlci91c2VyL3Bzdy1maWxlIgpMT0dfRklMRT0iL3Zhci9sb2cvb3BlbnZwbi9wYXNzd29yZC5sb2ciClRJTUVfU1RBTVA9JChkYXRlICIrJVktJW0tJWQgJVQiKQojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwppZiBbICEgLXIgIiR7UEFTU0ZJTEV9IiBdOyB0aGVuCiAgZWNobyAiJHtUSU1FX1NUQU1QfTogQ291bGQgbm90IG9wZW4gcGFzc3dvcmQgZmlsZSBcIiR7UEFTU0ZJTEV9XCIgZm9yIHJlYWRpbmcuIiA+PiAgJHtMT0dfRklMRX0KICBleGl0IDEKZmkKQ09SUkVDVF9QQVNTV09SRD0kKGF3ayAnIS9eOy8mJiEvXiMvJiYkMT09Iicke3VzZXJuYW1lfScie3ByaW50ICQyO2V4aXR9JyAke1BBU1NGSUxFfSkKaWYgWyAiJHtDT1JSRUNUX1BBU1NXT1JEfSIgPSAiIiBdOyB0aGVuCiAgZWNobyAiJHtUSU1FX1NUQU1QfTogVXNlciBkb2VzIG5vdCBleGlzdDogdXNlcm5hbWU9XCIke3VzZXJuYW1lfVwiLCBwYXNzd29yZD0KXCIke3Bhc3N3b3JkfVwiLiIgPj4gJHtMT0dfRklMRX0KICBleGl0IDEKZmkKaWYgWyAiJHtwYXNzd29yZH0iID0gIiR7Q09SUkVDVF9QQVNTV09SRH0iIF07IHRoZW4KICBlY2hvICIke1RJTUVfU1RBTVB9OiBTdWNjZXNzZnVsIGF1dGhlbnRpY2F0aW9uOiB1c2VybmFtZT1cIiR7dXNlcm5hbWV9XCIuIiA+PiAke0xPR19GSUxFfQogIGV4aXQgMApmaQplY2hvICIke1RJTUVfU1RBTVB9OiBJbmNvcnJlY3QgcGFzc3dvcmQ6IHVzZXJuYW1lPVwiJHt1c2VybmFtZX1cIiwgcGFzc3dvcmQ9ClwiJHtwYXNzd29yZH1cIi4iID4+ICR7TE9HX0ZJTEV9CmV4aXQgMQ=='
  #控制台显示脚本内容
  #cho $checkpsw | base64 -d | tee /etc/openvpn/server/user/checkpsw.sh
  #控制台不显示脚本内容
  echo $checkpsw | base64 -d >/etc/openvpn/server/user/checkpsw.sh

  chmod 777 /etc/openvpn/server/user/checkpsw.sh

  echo "========> 启动服务  ..."
  # 查看service名
  #  rpm -ql openvpn | grep service
  # 启动
  systemctl start openvpn-server@.service.service
  #  开机自启
  systemctl enable openvpn-server@.service.service
  #  查看状态
  #  systemctl status openvpn-server@.service.service
  netstat -tnlp | grep 1194
  echo "========> 如果1194端口启动起来了,则表示安装成功  ..."

  rm -f /etc/openvpn/aaa.log
  exit 0
fi
