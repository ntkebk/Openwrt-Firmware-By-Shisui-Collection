# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in


# Autocore Stb
git clone https://github.com/MatJehey/autocore-arm-x86.git package/new/luci-app-autocore


# modem
# git clone https://github.com/4IceG/luci-app-3ginfo-lite.git package/new/luci-app-3ginfo-lite


# 1. Remove excess proxy files that are taking up space (so only the X-ray field remains).
sed -i '/CONFIG_PACKAGE_kcptun-client/d' .config
sed -i '/CONFIG_PACKAGE_kcptun-config/d' .config
sed -i '/CONFIG_PACKAGE_simple-obfs-client/d' .config

# 2. Completely disable IPv6 (this can significantly reduce the size of the system).
sed -i '/CONFIG_IPV6/d' .config
sed -i '/CONFIG_PACKAGE_ip6tables/d' .config
sed -i '/CONFIG_PACKAGE_kmod-ip6tables/d' .config
sed -i '/CONFIG_PACKAGE_luci-proto-ipv6/d' .config
sed -i '/CONFIG_PACKAGE_odhcpd-ipv6only/d' .config

#3. Delete miscellaneous tools.
sed -i '/CONFIG_PACKAGE_unzip/d' .config
sed -i '/CONFIG_PACKAGE_tcping/d' .config
sed -i '/CONFIG_PACKAGE_coreutils-base64/d' .config

# 4. Emphasize that the system compiles PassWall and X-Ray (to prevent skipping).
echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-passwall-en=y" >> .config
echo "CONFIG_PACKAGE_xray-core=y" >> .config

# 5. (Additional) Cut other unused Cores in PassWall to save space.
echo "# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray-core is not set" >> .config
echo "# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan-go is not set" >> .config

#########################################################

# Shut down the program that crashed due to the lack of Rust or its dependencies in 21.02.
sed -i 's/CONFIG_PACKAGE_shadowsocks-rust=y/# CONFIG_PACKAGE_shadowsocks-rust is not set/g' .config
sed -i 's/CONFIG_PACKAGE_shadow-tls=y/# CONFIG_PACKAGE_shadow-tls is not set/g' .config
sed -i 's/CONFIG_PACKAGE_sing-box=y/# CONFIG_PACKAGE_sing-box is not set/g' .config

# If you're not using a modem to read SMS, disable this as well so the warning will disappear.
sed -i 's/CONFIG_PACKAGE_luci-app-3ginfo-lite=y/# CONFIG_PACKAGE_luci-app-3ginfo-lite is not set/g' .config

# Force the use of a version of Xray-core that compiles successfully on older Go versions.
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.8.24/g' feeds/passwall_pkg/xray-core/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/passwall_pkg/xray-core/Makefile

# Force the Makefile to use Go 1.23 to match the build system.
# sed -i 's/GO_PKG_GO_VERSION:=.*/GO_PKG_GO_VERSION:=1.23/g' feeds/passwall_pkg/xray-core/Makefile
sed -i '/$(Build\/Patch)/a \	sed -i "s/go 1.21.4/go 1.23/g" $(PKG_BUILD_DIR)/go.mod' Makefile
popd
