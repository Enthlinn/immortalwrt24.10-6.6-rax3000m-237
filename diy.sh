#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
#
#在这里添加想要的软件包吧
#建议先搜索rax3000m.config文件确认是否默认源里已经存在想要的软件包
#如果存在想要的软件包比如openclash
#可以直接在文件中将# CONFIG_PACKAGE_luci-app-openclash is not set改成CONFIG_PACKAGE_luci-app-openclash=y
#注意别忘了去掉前面的#
#理论上就可以直接编译了
#如果改了之后编译出来的固件中没有那个软件包就是依赖检查过不去被自动移除了
#也可以直接使用sed修改,比如下面这行代码
#sed -i 's|# CONFIG_PACKAGE_luci-app-openclash is not set|CONFIG_PACKAGE_luci-app-openclash=y|g' .config
#打包mate内核
#wget https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz
#tar zxvf clash-linux-arm64.tar.gz
#mkdir -p files/etc/openclash/core
#mv clash files/etc/openclash/core/clash_meta
#rm -rf clash-linux-arm64.tar.gz
#wget -O files/etc/openclash/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
#wget -O files/etc/openclash/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
#编译openclash太费劲了，还是不开了吧
#更新golang
rm -rf feeds/packages/lang/golang feeds/packages/net/ddns-go feeds/luci/applications/luci-app-ddns-go
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
#防止ddns-go无法在升级时保留配置
echo "/etc/ddns-go" >> package/base-files/files/etc/sysupgrade.conf
#防止openclash无法在升级时保留配置
echo "/etc/openclash" >> package/base-files/files/etc/sysupgrade.conf
#修复libxcrypt无法编译
sed -i '3i PKG_FORTIFY_SOURCE=0' package/feeds/packages/libxcrypt/Makefile
#修复quickstart温度显示
wget -O package/jell/luci-app-quickstart/luasrc/controller/istore_backend.lua https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/istore_backend.lua
#修复可能存在的ddns-go无法从luci启动
wget -O package/jell/ddns-go/file/ddns-go.init https://raw.githubusercontent.com/Enthlinn/immortalwrt24.10-6.6-rax3000m-237/refs/heads/openwrt-24.10-6.6/ddns-go.init
#移除登录界面自动填入root账号，仅对argon主题生效
sed -i 's|value="{{ entityencode(duser, true) }}"|value=""|g' package/feeds/luci/luci-theme-argon/ucode/template/themes/argon/sysauth.ut
#通过uci-defaults脚本把5GWIFI发射功率改成25
mkdir -p files/etc/uci-defaults
cat <<EOF > files/etc/uci-defaults/99-custom-e2p
#!/bin/sh
TARGET="/lib/firmware/e2p"
if [ -f "\$TARGET" ]; then
printf '\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b\x2b' | \
dd of="\$TARGET" bs=1 seek=\$((0x445)) conv=notrunc
fi
exit 0
EOF
