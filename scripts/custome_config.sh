#!/bin/bash

sed -i -e '/CONFIG_MAKE_TOOLCHAIN=y/d' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_IB=y/# CONFIG_IB is not set/g' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_SDK=y/# CONFIG_SDK is not set/g' configs/rockchip/01-nanopi

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