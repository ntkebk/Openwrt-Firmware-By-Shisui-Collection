#!/bin/bash

# 1. Modify the Makefile (Xray compression) - This needs to be fixed in the source code.
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.8.4/g' feeds/passwall_pkg/xray-core/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/passwall_pkg/xray-core/Makefile

# Compress X-rays using UPX (a powerful tool for reducing file size)
sed -i '/^define Package\/xray-core\/install/,/^endef/ s/$(1)\/usr\/bin\/xray/$(1)\/usr\/bin\/xray; upx --lzma --best $(1)\/usr\/bin\/xray/' feeds/passwall_pkg/xray-core/Makefile || true

# 2. Edit the configuration file (it must be a .config file because the .yml file has already been affected by `mv`.
# Delete items that are taking up too much space.
sed -i '/CONFIG_PACKAGE_coreutils/d' .config
sed -i '/CONFIG_PACKAGE_unzip/d' .config
sed -i '/CONFIG_PACKAGE_tcping/d' .config
sed -i '/CONFIG_PACKAGE_simple-obfs/d' .config

# Delete IPv6 and iptables remnants.
sed -i '/odhcp6c/d' .config
sed -i '/odhcpd-ipv6only/d' .config
sed -i '/CONFIG_PACKAGE_iptables/d' .config
sed -i '/CONFIG_PACKAGE_kmod-ipt/d' .config

# 3. Force the addition of necessary values ​​for OpenWrt 23.05.
echo "CONFIG_PACKAGE_luci-app-firewall4=y" >> .config
echo "CONFIG_PACKAGE_kmod-nft-tproxy=y" >> .config
