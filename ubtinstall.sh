#!/bin/bash

# 切换到root用户
sudo -i

# 设置root密码为Qq@@888678
echo "root:Qq@@888678" | chpasswd

# 退出root账户
exit
