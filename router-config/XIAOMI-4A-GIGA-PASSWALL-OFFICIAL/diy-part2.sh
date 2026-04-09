#!/bin/bash

# 1. 移除 SNAPSHOT 标签 
sed -i 's/-SNAPSHOT//g' include/version.mk
sed -i 's/-SNAPSHOT//g' package/base-files/image-config.in

# 2. Add an additional app.
git clone https://github.com/MatJehey/autocore-arm-x86.git package/new/luci-app-autocore
git clone https://github.com/4IceG/luci-app-3ginfo-lite.git package/new/luci-app-3ginfo-lite

# 3. Manage IPv6 radically (add the odhcp6c remover to reclaim space).
sed -i 's/CONFIG_IPV6=y/# CONFIG_IPV6 is not set/g' .config
sed -i '/ip6tables/d' .config
sed -i '/odhcpd-ipv6only/d' .config
sed -i '/odhcp6c/d' .config

# 4. Remove space-consuming packages (add Coreutils and clean up redundant iptables)
# Remove Coreutils (use Busybox instead, which is sufficient for general use and much smaller)
sed -i '/CONFIG_PACKAGE_coreutils/d' .config

# Delete old proxy versions and unused tools.
sed -i '/CONFIG_PACKAGE_kcptun/d' .config
sed -i '/CONFIG_PACKAGE_simple-obfs/d' .config
sed -i '/CONFIG_PACKAGE_unzip/d' .config
sed -i '/CONFIG_PACKAGE_tcping/d' .config

# Delete remnants of iptables (since version 23.05 primarily uses fw4/nftables)
sed -i '/CONFIG_PACKAGE_iptables/d' .config
sed -i '/CONFIG_PACKAGE_kmod-ipt/d' .config
sed -i '/CONFIG_PACKAGE_kmod-nf-ipt/d' .config

#5. Mandatory selection of PassWall and Firewall4 (maintained and with added Thai language support in case you need it).
echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-passwall-en=y" >> .config
# echo "CONFIG_PACKAGE_luci-i18n-passwall-zh-cn=n" >> .config # Turn off Chinese language if it's enabled.
echo "CONFIG_PACKAGE_xray-core=y" >> .config
echo "CONFIG_PACKAGE_luci-app-firewall4=y" >> .config
echo "CONFIG_PACKAGE_kmod-nft-tproxy=y" >> .config
echo "CONFIG_PACKAGE_kmod-nft-socket=y" >> .config
