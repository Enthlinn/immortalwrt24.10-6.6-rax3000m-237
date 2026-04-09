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
./scripts/feeds update -a && rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,sing*,smartdns} feeds/packages/utils/v2dat feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
./scripts/feeds install -a
#修复libxcrypt无法编译
sed -i '3i PKG_FORTIFY_SOURCE=0' package/feeds/packages/libxcrypt/Makefile
#修复quickstart温度显示
wget -O package/kenzo/luci-app-quickstart/luasrc/controller/istore_backend.lua https://gist.githubusercontent.com/puteulanus/1c180fae6bccd25e57eb6d30b7aa28aa/raw/51ae1464e068fadc348c0b577f8ffd338bbd7ee5/istore_backend.lua
#修复ddns-go
cp ../ddns-go /home/enthlinn/rax3000m/package/kenzo/ddns-go/file/ddns-go.init
