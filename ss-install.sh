#!/usr/bin/bash

#运行代码是：sudo curl -s -L https://raw.githubusercontent.com/tt8296065/awsv2/main/ss-install.sh | sudo bash
#查看运行状态 systemctl status v2ray@shadowsocks
#重启service systemctl restart v2ray@shadowsocks
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
      "port": 8833,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-256-gcm",
        "password": "tudou666",
        "network": "tcp,udp",
        "level": 1
      },
      "tag":"ss-in"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "ss-out"
    }
  ],
  "routing":{
    "domainStrategy":"IPOnDemand",
    "rules":[
      {
        "type":"field",
        "outboundTag":"ss-out",
        "domain":[
          "geosite:cn"
        ]
      }
    ]
  }
}' > '/etc/v2ray/shadowsocks.json'
}

register_systemd() {
    echo "#register_system_service and optimized_network edit: 20220428
[Unit]
Description=v2ray Shadowsocks Proxy
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
    `systemctl start v2ray@shadowsocks`
    `systemctl enable v2ray@shadowsocks`
    systemctl status v2ray@shadowsocks
    `rm install.sh v2ray-linux-64.zip`
}

main
