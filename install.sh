#!/usr/bin/bash

# need unzip and wget
apt update && apt install wget unzip -y

download_v2ray() {
  DOWNLOAD_LINK="https://github.com/v2fly/v2ray-core/releases/download/v4.44.0/v2ray-linux-32.zip"
  wget $DOWNLOAD_LINK
}

install_v2() {
    unzip -d v2 v2ray-linux-32.zip
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
      "port": 47765,
      "protocol": "vmess",
      "settings": {
        "udp": false,
        "clients": [
          {
            "id": "595b1ec5-38f8-4573-ca0f-8767993fbc05",
            "alterId": 0,
            "email": "t@t.tt"
          }
        ],
        "allowTransparent": false
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/"
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
    `rm install.sh v2ray-linux-32.zip`
    systemctl status v2ray
}

main

