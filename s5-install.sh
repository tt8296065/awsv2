#!/usr/bin/bash

#运行代码是：sudo curl -s -L https://raw.githubusercontent.com/tt8296065/awsv2/main/s5-install.sh | sudo bash
#查看运行状态 systemd status v2ray@socks5
#重启socks5 systemd restart v2ray@socks5
# need unzip and wget
apt update && apt install wget unzip -y

download_v2ray() {
  DOWNLOAD_LINK="https://github.com/tt8296065/awsv2/releases/download/v4.44.0/v2ray-linux-64.zip"
  wget $DOWNLOAD_LINK
}

install_v2() {
    unzip -d v2 v2ray-linux-64.zip
    `mv v2/v2ray /usr/bin`
    `rm -r v2`
    `mkdir -p /etc/v2ray`
    echo '{
  "log": {
    "access": "",
    "error": "",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 1080,
      "protocol": "socks",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "tudou",
            "pass": "tudou666",
            "email": "t@t.tt"
          }
        ],
        "udp": false
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}' > '/etc/v2ray/socks.json'
}

register_systemd() {
    echo "#register_system_service and optimized_network edit: 20220428
[Unit]
Description=v2ray SOCKS5 Proxy
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Type=simple
User=root
DynamicUser=true
ExecStart=/usr/bin/v2ray -c /etc/v2ray/%i.json
LimitCPU=infinity
LimitFSIZE=infinity
LimitDATA=infinity
LimitSTACK=infinity
LimitCORE=infinity
LimitRSS=infinity
LimitNOFILE=infinity
LimitAS=infinity
LimitNPROC=infinity
LimitMEMLOCK=infinity
LimitLOCKS=infinity
LimitSIGPENDING=infinity
LimitMSGQUEUE=infinity
LimitRTPRIO=infinity
LimitRTTIME=infinity
Restart=always
RestartSec=20

[Install]
WantedBy=multi-user.target" > '/etc/systemd/system/v2ray@.service'
`chmod 777 /etc/systemd/system/v2ray@.service`
}

main() {
    download_v2ray
    install_v2
    register_systemd
    `systemctl daemon-reload`
    `systemctl start v2ray@socks5`
    `systemctl enable v2ray@socks5`
    systemctl status v2ray@socks5
    `rm install.sh v2ray-linux-64.zip`
}

main




# 查看运行状态
# systemctl status v2ray@socks5

# 重启socks5服务
# systemctl restart v2ray@socks5
