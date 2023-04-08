#!/bin/bash

# 切换到root用户
sudo -i

# 设置root密码为Qq@@888999000
echo "root:Qq@@888999000" | chpasswd

# 退出root账户
exit
