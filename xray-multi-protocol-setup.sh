#!/bin/bash
# 一键搭建socks5/ss/vmess/vless四协议代理

# 定义端口号和密码/UUID
SOCKS_PORT=1081
SS_PORT=1082
VMESS_PORT=1083
VLESS_PORT=1084

SOCKS_USER="user"
SOCKS_PASS="password"
SS_PASSWORD="password1"
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
