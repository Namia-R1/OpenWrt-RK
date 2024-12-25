#!/bin/bash
# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# 以下均为lean 最新的luci2配置老luci不知为啥用不了-----------------------------------------------------------------------------------------
# 如果你不懂不要瞎碰，我更改完后已经够你用了，你不懂并且你不够用或者缺啥邮箱或者提交问题我弄或者tG群联系我---https://t.me/RileyK9880---------------------

# 开始DIY✔️--------------------------------------------------------------------------------------------------------------------------

# 1----------------------------------------------------------------------------------------------------------------------------------
# 修改主机名字，把 OpenWrt-RK 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/OpenWrt-RK/g' package/base-files/files/bin/config_generate
sed -i "s/'LEDE'/'OpenWrt-RK'/g" package/base-files/files/bin/config_generate    
# 修改系统内核
sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.12/g' target/linux/rockchip/Makefile

# 2----------------------------------------------------------------------------------------------------------------------------------
# 修改默认IP
# 新版LUCI的ip修改wan口IP
# sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
# 新版LUCI的ip修改lan口IP
sed -i 's/192.168.1.1/192.168.10.1/g' ./package/base-files/luci2/bin/config_generate

# 3----------------------------------------------------------------------------------------------------------------------------------
# 更改无密码登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 5----------------------------------------------------------------------------------------------------------------------------------
# 移除要替换的包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan

# 6----------------------------------------------------------------------------------------------------------------------------------
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 7----------------------------------------------------------------------------------------------------------------------------------
# 添加额外插件
git clone --depth=1 https://github.com//luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 https://github.com/sirpdboy/luci-app-netdata package/luci-app-netdata

# 8---------------------------------------------------------------------------------------------------------------------------------
# 科学上网插件
git_sparse_clone dev https://github.com/vernesong/OpenClash luci-app-openclash
git_sparse_clone main https://github.com/morytyann/OpenWrt-mihomo luci-app-mihomo mihomo
git clone --depth=1 https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy
# git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall

# 9----------------------------------------------------------------------------------------------------------------------------------
# 个性化主题插件
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth=1 https://github.com//luci-theme-design package/luci-theme-design

# 10----------------------------------------------------------------------------------------------------------------------------------
# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;
# 更改 Argon 主题背景或者其他支持更改的主题，详情看images文件里面有啥主题或者你自己找你喜欢的主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# 新版LUCI主题无密码登录
sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# 11----------------------------------------------------------------------------------------------------------------------------------
# 随身路由AT工具和拨号调制器
git clone --depth=1 https://github.com/ouyangzq/sendat package/sendat
git clone --depth=1 https://github.com/ouyangzq/luci-app-cpe package/luci-app-cpe
git_sparse_clone main https://github.com/kenzok8/jell luci-app-modemband sms-tool modemband
# git_sparse_clone main https://github.com/1/5G-Modem-Support luci-app-modem sendat sms-tool luci-app-hypermodem

# git clone --depth=1 https://github.com/obsy/sms_tool package/sms_tool sms_tool


# 12----------------------------------------------------------------------------------------------------------------------------------
# SmartDNS
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# 13----------------------------------------------------------------------------------------------------------------------------------
# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# 14----------------------------------------------------------------------------------------------------------------------------------
# MosDNS
git clone --depth=1 -b v5-lua https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns
git clone --depth=1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 15----------------------------------------------------------------------------------------------------------------------------------
# Alist
git clone --depth=1 -b lua https://github.com/sbwml/luci-app-alist package/luci-app-alist

# 16----------------------------------------------------------------------------------------------------------------------------------
# DDNS-GO
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# 17----------------------------------------------------------------------------------------------------------------------------------
# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# 18----------------------------------------------------------------------------------------------------------------------------------
#OLED
git clone --depth=1 https://github.com/natelol/luci-app-oled package/luci-app-oled

# 19----------------------------------------------------------------------------------------------------------------------------------
# 在线用户
git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# 20----------------------------------------------------------------------------------------------------------------------------------
# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 21----------------------------------------------------------------------------------------------------------------------------------
# 修改版本为编译日期
#date_version=$(date +"%y.%m.%d")
#orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by NAmia-R/g" package/lean/default-settings/files/zzz-default-settings

# 22----------------------------------------------------------------------------------------------------------------------------------
# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 23----------------------------------------------------------------------------------------------------------------------------------
# 调整 V2ray服务器 到 VPN 菜单
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

# 24----------------------------------------------------------------------------------------------------------------------------------
# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/qmi_wwan_q.c package/wwan/driver/quectel_QMI_WWAN/src/qmi_wwan_q.c

# 25----------------------------------------------------------------------------------------------------------------------------------
# 修复 armv8 设备 xfsprogs 报错
sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile

# 26----------------------------------------------------------------------------------------------------------------------------------
# 修复 uboot报错
sed  -i 's/^UBOOT\_TARGETS\ \:\=\ rk3528\-evb\ rk3588\-evb/#UBOOT\_TARGETS\ \:\=\ rk3528\-evb\ rk3588\-evb/g' package/boot/uboot-rk35xx/Makefile

# 27----------------------------------------------------------------------------------------------------------------------------------
# 设置wan口上网方式为PPPOE
# sed -i 's/2:-dhcp/2:-pppoe/g' package/base-files/files/lib/functions/uci-defaults.sh
# 设置PPPOE上网的账号和密码
# sed -i 's/username='"'"'username'"'"'/username='"'"'403'"'"'/g; s/password='"'"'password'"'"'/password='"'"'8888'"'"'/g' package/base-files/files/bin/config_generate

# 28----------------------------------------------------------------------------------------------------------------------------------
# 设置无线的国家代码为CN,wifi的默认功率为20
sed -i 's/country=US/country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.radio${devidx}.disabled=0/a\\t\t\tset wireless.radio${devidx}.txpower=20' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 29----------------------------------------------------------------------------------------------------------------------------------
# 设置wifi加密方式为psk2+ccmp,wifi密码为12345678
sed -i 's/encryption=none/encryption=psk2+ccmp/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=psk2+ccmp/a\\t\t\tset wireless.default_radio${devidx}.key=12345678' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 30----------------------------------------------------------------------------------------------------------------------------------
# 设置默认开启MU-MIMO
# sed -i '/set wireless.radio${devidx}.disabled=0/a\\t\t\tset wireless.radio${devidx}.mu_beamformer=1' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 31----------------------------------------------------------------------------------------------------------------------------------
# 调整菜单路径
sed -i 's|/services/|/system/|' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's|/services/|/nas/|' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json
sed -i 's|/services/|/nas/|' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json
sed -i 's|/services/|/network/|' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's|/services/|/network/|' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

# 32----------------------------------------------------------------------------------------------------------------------------------
# 优先级
sed -i 's/("Pass Wall"), -1)/("Pass Wall"), -9)/g' feeds/luci/applications/luci-app-passwall/luasrc/controller/passwall.lua
sed -i 's/("PassWall 2"), 0)/("PassWall 2"), -8)/g' feeds/luci/applications/luci-app-passwall2/luasrc/controller/passwall2.lua

# 33----------------------------------------------------------------------------------------------------------------------------------
# 重命名系统菜单
sed -i 's/"概览"/"系统概览"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"备份与升级"/"备份升级"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"路由"/"路由映射"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"管理权"/"权限管理"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"重启"/"立即重启"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
# sed -i 's/"挂载点"/"挂载路径"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"启动项"/"启动管理"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"软件包"/"软件管理"/g' $(grep "软件包" -rl ./)
sed -i 's/"终端"/"TTYD 终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po
# sed -i 's/"AList"/"Alist列表"/g' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json

# 结束✔️----------------------------------------------------------------------------------------------------------------------------------
./scripts/feeds update -a
./scripts/feeds install -a
