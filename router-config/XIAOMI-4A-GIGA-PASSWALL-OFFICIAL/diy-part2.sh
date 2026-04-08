# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in


# Autocore Stb
git clone https://github.com/MatJehey/autocore-arm-x86.git package/new/luci-app-autocore


# modem
git clone https://github.com/4IceG/luci-app-3ginfo-lite.git package/new/luci-app-3ginfo-lite


# 1. ----------------------
sed -i '/CONFIG_PACKAGE_kcptun-client/d' .config
sed -i '/CONFIG_PACKAGE_kcptun-config/d' .config
sed -i '/CONFIG_PACKAGE_simple-obfs-client/d' .config

# 2. ------------------------
sed -i '/CONFIG_IPV6/d' .config
sed -i '/CONFIG_PACKAGE_ip6tables/d' .config
sed -i '/CONFIG_PACKAGE_kmod-ip6tables/d' .config
sed -i '/CONFIG_PACKAGE_luci-proto-ipv6/d' .config
sed -i '/CONFIG_PACKAGE_odhcpd-ipv6only/d' .config

# 3. ------------------------
sed -i '/CONFIG_PACKAGE_unzip/d' .config
sed -i '/CONFIG_PACKAGE_tcping/d' .config
sed -i '/CONFIG_PACKAGE_coreutils-base64/d' .config
