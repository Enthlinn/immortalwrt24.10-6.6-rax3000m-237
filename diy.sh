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
#在这里添加想要的软件源吧
#建议先搜索rax3000m.config文件确认是否默认源里已经存在想要的软件包
#更新golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
#直接添加太多软件包容易抽风，所以这里下载到项目外面再单独复制自己想要的软件包进去
git clone https://github.com/kenzok8/jell.git ../jell
mkdir -p package/jell
cp -r ../jell/quickstart package/jell/quickstart
cp -r ../jell/luci-app-quickstart package/jell/luci-app-quickstart
cp -r ../jell/floatip package/jell/floatip
cp -r ../jell/luci-app-floatip package/jell/luci-app-floatip
cp -r ../jell/ddns-go package/jell/ddns-go
cp -r ../jell/luci-app-ddns-go package/jell/luci-app-ddns-go
#其实jell源里也有watchdog，但我懒得改了
git clone https://github.com/sirpdboy/luci-app-watchdog.git package/watchdog
#强制更新ddns-go软件包,好像并不需要直接编译就行
#./scripts/feeds install -f luci-app-ddns-go
#./scripts/feeds install -f ddns-go
#修复ddns-go无法在升级时保留配置
echo "/etc/ddns-go" >> package/base-files/files/etc/sysupgrade.conf
#修复libxcrypt无法编译
sed -i '3i PKG_FORTIFY_SOURCE=0' package/feeds/packages/libxcrypt/Makefile
#修复quickstart温度显示
wget -O package/jell/luci-app-quickstart/luasrc/controller/istore_backend.lua https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/istore_backend.lua
#修复可能存在的ddns-go无法从luci启动
wget -O package/jell/ddns-go/file/ddns-go.init https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/ddns-go.init
