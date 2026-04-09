#!/bin/bash

# 1. 移除 SNAPSHOT 标签
sed -i 's/-SNAPSHOT//g' include/version.mk
sed -i 's/-SNAPSHOT//g' package/base-files/image-config.in

# 2. ------------------
git clone https://github.com/MatJehey/autocore-arm-x86.git package/new/luci-app-autocore
git clone https://github.com/4IceG/luci-app-3ginfo-lite.git package/new/luci-app-3ginfo-lite

# 3. -----------------------
sed -i 's/CONFIG_IPV6=y/# CONFIG_IPV6 is not set/g' .config
sed -i '/ip6tables/d' .config
sed -i '/odhcpd-ipv6only/d' .config

# --------------------------------
sed -i '/CONFIG_PACKAGE_kcptun/d' .config
sed -i '/CONFIG_PACKAGE_simple-obfs/d' .config
sed -i '/CONFIG_PACKAGE_unzip/d' .config

# 4. ------------------------------------
echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-passwall-en=y" >> .config
echo "CONFIG_PACKAGE_xray-core=y" >> .config
echo "CONFIG_PACKAGE_luci-app-firewall4=y" >> .config
echo "CONFIG_PACKAGE_kmod-nft-tproxy=y" >> .config
