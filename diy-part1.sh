#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# 添加软件源
git clone https://github.com/kenzok8/jell.git ../jell
cp -r ../jell/quickstart package/jell/quickstart
cp -r ../jell/luci-app-quickstart package/jell/luci-app-quickstart
cp -r ../jell/ddns-go package/jell/ddns-go
cp -r ../jell/luci-app-ddns-go package/jell/luci-app-ddns-go
git clone https://github.com/sirpdboy/luci-app-watchdog.git package/watchdog
