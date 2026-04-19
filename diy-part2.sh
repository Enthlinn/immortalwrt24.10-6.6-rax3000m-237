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
#更新golang,ddns-go
rm -rf feeds/packages/lang/golang feeds/packages/net/ddns-go feeds/luci/applications/luci-app-ddns-go
git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
./scripts/feeds install -a -f
#强制更新ddns-go软件包
#./scripts/feeds install -f luci-app-ddns-go ddns-go
#修复ddns-go无法在升级时保留配置
echo "/etc/ddns-go" >> package/base-files/files/etc/sysupgrade.conf
#修复libxcrypt无法编译
sed -i '3i PKG_FORTIFY_SOURCE=0' package/feeds/packages/libxcrypt/Makefile
#修复quickstart温度显示
wget -O package/jell/luci-app-quickstart/luasrc/controller/istore_backend.lua https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/istore_backend.lua
#修复ddns-go无法从luci启动
wget -O package/jell/ddns-go/file/ddns-go.init https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/ddns-go.init
# 修复 libwebsockets 未启用 libuv 的问题（适配 ttyd 编译）
LIBWS_DIR="package/feeds/packages/libwebsockets"
# 检查 libwebsockets 的 Makefile 是否存在
if [ -f "${LIBWS_DIR}/Makefile" ]; then
    # 向 CMAKE_ARGS 中追加 -DLWS_WITH_LIBUV=ON
    sed -i '/CMAKE_ARGS/ s/$/ -DLWS_WITH_LIBUV=ON/' ${LIBWS_DIR}/Makefile
    # 可选：确保 libuv 被作为依赖添加（防止依赖缺失）
    sed -i '/DEPENDS/ s/$/ +libuv/' ${LIBWS_DIR}/Makefile
    echo "已为 libwebsockets 启用 libuv 支持"
else
    echo "警告：未找到 libwebsockets Makefile，路径可能错误"
fi
