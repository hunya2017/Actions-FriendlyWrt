#!/bin/bash

sed -i -e '/CONFIG_MAKE_TOOLCHAIN=y/d' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_IB=y/# CONFIG_IB is not set/g' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_SDK=y/# CONFIG_SDK is not set/g' configs/rockchip/01-nanopi

# 修改 LAN IP为 192.168.8.1，子网掩码255.255.252.0，广播地址192.168.11.255
sed -i 's/option ipaddr '\''192\.168\.[0-9]*\.[0-9]*'\''/option ipaddr '\''192.168.8.1'\''/g' friendlywrt/target/linux/rockchip/files/etc/config/network
sed -i 's/option netmask '\''255\.255\.[0-9]*\.[0-9]*'\''/option netmask '\''255.255.252.0'\''/g' friendlywrt/target/linux/rockchip/files/etc/config/network
sed -i '/option ipaddr/a\    option broadcast '\''192.168.11.255'\''' friendlywrt/target/linux/rockchip/files/etc/config/network

# 添加 99-default-settings 初始化脚本
mkdir -p friendlywrt/package/base-files/files/etc/uci-defaults
cat > friendlywrt/package/base-files/files/etc/uci-defaults/99-default-settings <<'EOF'
#!/bin/sh

# Beware! This script will be in /rom/etc/uci-defaults/ as part of the image.

# log potential errors
exec >/tmp/setup.log 2>&1

# Configure LAN with custom IP
lan_ip_address="192.168.8.1/22"
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci set network.lan.netmask="255.255.252.0"
  uci set network.lan.broadcast="192.168.11.255"
  uci commit network
fi

# Set default theme to Argon
uci set luci.main.mediaurlbase="/luci-static/argon"
uci commit luci

echo "All done!"
exit 0
EOF
chmod +x friendlywrt/package/base-files/files/etc/uci-defaults/99-default-settings