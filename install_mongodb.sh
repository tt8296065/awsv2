#!/bin/bash

# 导入MongoDB公钥
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

# 创建MongoDB列表文件
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# 更新本地包数据库
sudo apt-get update

# 安装MongoDB包
sudo apt-get install -y mongodb-org

# 启动MongoDB服务
sudo systemctl start mongod

# 设置MongoDB在启动时自动运行
sudo systemctl enable mongod


# 运行代码:sudo curl -s -L https://raw.githubusercontent.com/tt8296065/awsv2/main/install_mongodb.sh | sudo bash
# 这是检查盲狗是否搭建成功的命令：sudo systemctl status mongod
