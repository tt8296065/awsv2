#!/usr/bin/env bash
#运行代码是：sudo curl -s -L https://raw.githubusercontent.com/tt8296065/awsv2/main/install-socks5.sh | sudo bash
#导入或者参数是：1.1.1.1:10180:tudou:tudou666


# 设置端口和用户名
PORT=11882
USERNAME="tudou"
PASSWORD="tudou666"

# 更新软件包列表并安装Dante SOCKS5服务器
apt-get update
apt-get install -y dante-server

# 配置Dante SOCKS5服务器
cat <<EOF > /etc/danted.conf
logoutput: syslog
internal: eth0 port = $PORT
external: eth0
method: username none
user.privileged: proxy
user.notprivileged: nobody
user.libwrap: nobody
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    command: bind connect udpassociate
    log: connect disconnect error
    socksmethod: username
}
EOF

# 创建用户名和密码文件
echo "$USERNAME: $PASSWORD" > /etc/danted.conf

# 启动Dante SOCKS5服务器并设置开机启动
systemctl start danted.service
systemctl enable danted.service

# 显示Dante SOCKS5服务器状态
systemctl status danted.service
