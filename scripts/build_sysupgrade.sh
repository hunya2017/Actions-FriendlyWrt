#!/bin/bash

# 编译 sysupgrade 固件脚本
# 使用方法：在 friendlywrt 目录下运行此脚本

set -e

echo "=========================================="
echo "  编译 FriendlyWrt sysupgrade 固件"
echo "=========================================="

# 检查是否在正确的目录
if [ ! -f "./build.sh" ]; then
    echo "错误：请在 friendlywrt 根目录下运行此脚本"
    exit 1
fi

# 备份当前配置
if [ -f ".config" ]; then
    cp .config .config.backup.$(date +%Y%m%d_%H%M%S)
fi

# 应用自定义配置
echo "正在应用自定义配置..."
source ../scripts/custome_config.sh

# 编译 sysupgrade 固件
echo "正在编译 sysupgrade 固件..."
./build.sh sysupgrade

# 或者使用以下方式编译所有固件（包含 sysupgrade）
# ./build.sh all

echo "=========================================="
echo "  编译完成！"
echo "  sysupgrade 固件位置：out/"
echo "=========================================="
