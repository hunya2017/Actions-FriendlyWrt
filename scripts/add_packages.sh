#!/bin/bash

# {{ Add luci-app-momo
(cd friendlywrt/package && {
    [ -d luci-app-momo ] && rm -rf luci-app-momo
    git clone https://github.com/nikkinikki-org/OpenWrt-momo.git --depth=1 -b main
})
echo "CONFIG_PACKAGE_luci-app-momo=y" >> configs/rockchip/01-nanopi
# }}

# {{ Add luci-app-diskman
(cd friendlywrt && {
    mkdir -p package/luci-app-diskman
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile.old -O package/luci-app-diskman/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_luci-i18n-diskman-zh-cn=y
CONFIG_PACKAGE_smartmontools=y
EOL
# }}

# {{ Add luci-theme-argon
(cd friendlywrt/package && {
    [ -d luci-theme-argon ] && rm -rf luci-theme-argon
    git clone https://github.com/jerrykuku/luci-theme-argon.git --depth=1 -b master
})
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> configs/rockchip/01-nanopi
sed -i -e 's/function init_theme/function old_init_theme/g' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
cat > /tmp/appendtext.txt <<EOL
function init_theme() {
    if uci get luci.themes.Argon >/dev/null 2>&1; then
        uci set luci.main.mediaurlbase="/luci-static/argon"
        uci commit luci
    fi
}
EOL
sed -i -e '/boardname=/r /tmp/appendtext.txt' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
# }}

# {{ Add iStore
(cd friendlywrt/package && {
    [ -d istore ] && rm -rf istore
    git clone https://github.com/linkease/istore.git --depth=1
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_istore=y
CONFIG_PACKAGE_luci-app-istore=y
EOL
# }}

# {{ Add luci-app-argon-config
(cd friendlywrt/package && {
    [ -d luci-app-argon-config ] && rm -rf luci-app-argon-config
    git clone https://github.com/jerrykuku/luci-app-argon-config.git --depth=1
})
echo "CONFIG_PACKAGE_luci-app-argon-config=y" >> configs/rockchip/01-nanopi
# }}

# {{ Add ZeroTier
(cd friendlywrt/package && {
    [ -d luci-app-zerotier ] && rm -rf luci-app-zerotier
    git clone https://github.com/immortalwrt/luci.git --depth=1 -b openwrt-24.10 applications/luci-app-zerotier
})
(cd friendlywrt/package && {
    [ -d zerotier ] && rm -rf zerotier
    git clone https://github.com/immortalwrt/packages.git --depth=1 -b openwrt-24.10 net/zerotier
})
echo "CONFIG_PACKAGE_luci-app-zerotier=y" >> configs/rockchip/01-nanopi
echo "CONFIG_PACKAGE_zerotier=y" >> configs/rockchip/01-nanopi
# }}

# {{ Add vlmcsd
(cd friendlywrt/package && {
    [ -d vlmcsd ] && rm -rf vlmcsd
    git clone https://github.com/immortalwrt/packages.git --depth=1 -b openwrt-24.10 net/vlmcsd
})
(cd friendlywrt/package && {
    [ -d luci-app-vlmcsd ] && rm -rf luci-app-vlmcsd
    git clone https://github.com/immortalwrt/luci.git --depth=1 -b openwrt-24.10 applications/luci-app-vlmcsd
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_vlmcsd=y
CONFIG_PACKAGE_luci-app-vlmcsd=y
EOL
# }}

# {{ Add sing-box
(cd friendlywrt/package && {
    [ -d sing-box ] && rm -rf sing-box
    git clone https://github.com/SagerNet/sing-box.git --depth=1
})
echo "CONFIG_PACKAGE_sing-box=y" >> configs/rockchip/01-nanopi
# }}