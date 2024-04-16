#!/bin/bash
# 一键搭建socks5/ss/vmess/vless四协议代理
# 运行代码是：sudo curl -s -L https://raw.githubusercontent.com/tt8296065/awsv2/main/xray-multi-protocol-setup.sh | sudo bash
# 定义端口号和密码/UUID
# 35.92.143.38:21081:tudou:tudou666888
# ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpzYWRTRGdkZjFTYw==@35.92.143.38:21082#XD-SS_PORT
# vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlhELVZNRVNTX1BPUlQtY2xvbmUiLA0KICAiYWRkIjogIjM0LjIxMi4yMC44NiIsDQogICJwb3J0IjogIjIxMDgzIiwNCiAgImlkIjogIjgzMmY4OGEwLTE5NWItNDljNi04ZWQ3LTIxODgzNzA4NzI5MSIsDQogICJhaWQiOiAiMCIsDQogICJzY3kiOiAiYXV0byIsDQogICJuZXQiOiAid3MiLA0KICAidHlwZSI6ICJub25lIiwNCiAgImhvc3QiOiAiIiwNCiAgInBhdGgiOiAiL3ZtZXNzIiwNCiAgInRscyI6ICIiLA0KICAic25pIjogIiIsDQogICJhbHBuIjogIiINCn0=
# vless://832f88a0-195b-49c6-8ed7-218837087291@18.236.90.59:21084?encryption=none&security=none&type=ws&path=%2Fvless#XD-VLESS_PORT

# 定义端口号和密码/UUID
SOCKS_PORT=21081
SS_PORT=21082
VMESS_PORT=21083
VLESS_PORT=21084

SOCKS_USER="tudou"
SOCKS_PASS="tudou666888"
SS_PASSWORD="sadSDgdf1Sc"
VMESS_UUID="832f88a0-195b-49c6-8ed7-218837087291"
VLESS_UUID="832f88a0-195b-49c6-8ed7-218837087291"

# 安装 Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

cat > /usr/local/etc/xray/config.json <<EOF
{
  "inbounds": [
    {
      "port": $SOCKS_PORT,
      "protocol": "socks",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "$SOCKS_USER",
            "pass": "$SOCKS_PASS"
          }
        ],
        "udp": true
      }
    },
    {
      "port": $SS_PORT,
      "protocol": "shadowsocks",
      "settings": {
        "method": "chacha20-ietf-poly1305",
        "password": "$SS_PASSWORD",
        "level": 0
      }
    },
    {
      "port": $VMESS_PORT,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$VMESS_UUID",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vmess"
        }
      }
    },
    {
      "port": $VLESS_PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$VLESS_UUID"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vless"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

systemctl restart xray
systemctl enable xray

echo "Xray 安装和配置完成!"
echo "Socks5 端口: $SOCKS_PORT, 用户名: $SOCKS_USER, 密码: $SOCKS_PASS"
echo "Shadowsocks 端口: $SS_PORT, 密码: $SS_PASSWORD"
echo "VMess 端口: $VMESS_PORT, UUID: $VMESS_UUID"
echo "VLESS 端口: $VLESS_PORT, UUID: $VLESS_UUID"
