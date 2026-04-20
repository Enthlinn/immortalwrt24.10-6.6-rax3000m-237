#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#更新golang,ddns-go
rm -rf feeds/packages/lang/golang feeds/packages/net/ddns-go feeds/luci/applications/luci-app-ddns-go
git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
#强制更新ddns-go软件包
./scripts/feeds install -f luci-app-ddns-go ddns-go
#修复ddns-go无法在升级时保留配置
echo "/etc/ddns-go" >> package/base-files/files/etc/sysupgrade.conf
#修复libxcrypt无法编译
sed -i '3i PKG_FORTIFY_SOURCE=0' package/feeds/packages/libxcrypt/Makefile
#修复quickstart温度显示
wget -O package/jell/luci-app-quickstart/luasrc/controller/istore_backend.lua https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/istore_backend.lua
#修复可能存在的ddns-go无法从luci启动
wget -O package/jell/ddns-go/file/ddns-go.init https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/ddns-go.init
