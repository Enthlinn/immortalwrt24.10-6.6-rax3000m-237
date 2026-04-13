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
sudo apt install libfuse-dev
./scripts/feeds update -a 
#dapnet-gateway编译不起来，先删了吧
rm -rf feeds/packages/lang/golang package/jell/dapnet-gateway/
git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
./scripts/feeds install -a
#修复libxcrypt无法编译
sed -i '3i PKG_FORTIFY_SOURCE=0' package/feeds/packages/libxcrypt/Makefile
#修复quickstart温度显示
wget -O package/jell/luci-app-quickstart/luasrc/controller/istore_backend.lua https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/istore_backend.lua
#修复ddns-go
wget -O package/jell/ddns-go/file/ddns-go.init https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/ddns-go
#修改os-release
wget -O package/base-files/files/usr/lib/os-release https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/os-release
#临时修复smartdns源码下载地址错误
#sed -i 's/Release47.1/47.1/g' package/jell/smartdns/Makefile
