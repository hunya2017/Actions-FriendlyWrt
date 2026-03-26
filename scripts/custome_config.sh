#!/bin/bash

# 添加 Target 配置
cat >> configs/rockchip/01-nanopi <<'EOF'
CONFIG_TARGET_rockchip=y
CONFIG_TARGET_rockchip_armv8=y
CONFIG_TARGET_rockchip_armv8_DEVICE_friendlyarm_nanopi-r3s=y
CONFIG_TARGET_PREINIT_BROADCAST="192.168.11.255"
CONFIG_TARGET_PREINIT_IP="192.168.8.1"
CONFIG_TARGET_PREINIT_NETMASK="255.255.252.0"
EOF

sed -i -e '/CONFIG_MAKE_TOOLCHAIN=y/d' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_IB=y/# CONFIG_IB is not set/g' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_SDK=y/# CONFIG_SDK is not set/g' configs/rockchip/01-nanopi

# 启用 sysupgrade 固件支持
sed -i -e 's/# CONFIG_TARGET_ROOTFS_TARGZ is not set/CONFIG_TARGET_ROOTFS_TARGZ=y/g' configs/rockchip/01-nanopi
sed -i -e 's/# CONFIG_TARGET_ROOTFS_CPIOGZ is not set/CONFIG_TARGET_ROOTFS_CPIOGZ=y/g' configs/rockchip/01-nanopi

# 添加99-default-settings初始化脚本
# LAN IP配置在此脚本中设置
mkdir -p friendlywrt/package/base-files/files/etc/uci-defaults
cat > friendlywrt/package/base-files/files/etc/uci-defaults/99-default-settings <<'EOF'
#!/bin/sh

# Beware! This script will be in /rom/etc/uci-defaults/ as part of the image.

# log potential errors
exec >/tmp/setup.log 2>&1

# Configure LAN with custom IP (CIDR notation: /22 = 255.255.252.0)
lan_ip_address="192.168.8.1/22"
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
fi

# Set default theme to Argon
uci set luci.main.mediaurlbase="/luci-static/argon"
uci commit luci

echo "All done!"
exit 0
EOF
chmod +x friendlywrt/package/base-files/files/etc/uci-defaults/99-default-settings