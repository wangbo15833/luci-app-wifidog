include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-wifidog
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-wifidog
    SECTION:=luci
    CATEGORY:=LuCI
    SUBMENU:=3. Applications
    DEPENDS:=+wifidog +luci
    TITLE:=wifidog luci control interface
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-wifidog/install
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/etc/config/* $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/* $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) ./files/usr/lib/* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,luci-app-wifidog))
