#!/usr/bin/bash

#运行代码是：sudo curl -s -L https://raw.githubusercontent.com/tt8296065/awsv2/main/s5-install.sh | sudo bash
#配置文件示例：1.1.1.1:15678:tudou:tudou666
#查看运行状态 systemd status v2ray@vless
#重启vless systemd restart v2ray@vless
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
{
  "inbounds": [
    {
      "port": 15678,
      "protocol": "socks",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "tudou",
            "pass": "tudou666"
          }
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}

  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": []
  }
}' > '/etc/v2ray/vless.json'
}

register_systemd() {
    echo "#register_system_service and optimized_network edit: 20220428
[Unit]
Description=gost
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
    `systemctl start v2ray@vless`
    `systemctl enable v2ray@vless`
    systemctl status v2ray@vless
    `rm install.sh v2ray-linux-64.zip`
}

main


