#!/usr/bin/bash

# need unzip and wget
#运行代码是：sudo curl -s -L https://raw.githubusercontent.com/tt8296065/awsv2/main/install.sh | sudo bash
#导入代理软件：vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlhETUVTUy0xREFJIiwNCiAgImFkZCI6ICIzNC4yMjEuMTc4LjI0MSIsDQogICJwb3J0IjogIjIzNDU2IiwNCiAgImlkIjogIjE5Njk5YjlhLTQyZmEtNGFmMy04Nzc3LWJhNWNmODdmNzkzMyIsDQogICJhaWQiOiAiMCIsDQogICJzY3kiOiAiYXV0byIsDQogICJuZXQiOiAid3MiLA0KICAidHlwZSI6ICJub25lIiwNCiAgImhvc3QiOiAiIiwNCiAgInBhdGgiOiAiL3RkdjUiLA0KICAidGxzIjogIiIsDQogICJzbmkiOiAiIiwNCiAgImFscG4iOiAiIiwNCiAgImZwIjogIiINCn0=

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
      "port": 23456,
      "protocol": "vmess",
      "settings": {
        "udp": false,
        "clients": [
          {
            "id": "19699b9a-42fa-4af3-8777-ba5cf87f7933",
            "alterId": 0,
            "email": "t@t.tt"
          }
        ],
        "allowTransparent": false
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/tdv5"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    },
    {
      "tag": "block",
      "protocol": "blackhole",
      "settings": {}
    }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": []
  }
}' > '/etc/v2ray/config.json'
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
ExecStart=/usr/bin/v2ray -c /etc/v2ray/config.json
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
WantedBy=multi-user.target" > '/etc/systemd/system/v2ray.service'
`chmod 777 /etc/systemd/system/v2ray.service`
}

main() {
    download_v2ray
    install_v2
    register_systemd
    `systemctl daemon-reload`
    `systemctl start v2ray`
    `systemctl enable v2ray`
    `rm install.sh v2ray-linux-64.zip`
    systemctl status v2ray
}

main

