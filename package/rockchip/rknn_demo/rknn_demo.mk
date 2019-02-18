################################################################################
#
# rknn demo
#
################################################################################

RKNN_DEMO_VERSION = 1.0.0
RKNN_DEMO_SITE = $(TOPDIR)/../external/rknn_demo
RKNN_DEMO_SITE_METHOD = local
RKNN_DEMO_DEPENDENCIES = jpeg libpng12 libv4l linux-rga minigui

ifeq ($(BR2_PACKAGE_RK1808),y)
	RKNN_DEMO_CONF_OPTS += -DNEED_RKNNAPI=0
	RKNN_DEMO_DEPENDENCIES += rknpu
endif

ifeq ($(BR2_PACKAGE_RK3399PRO),y)
	RKNN_DEMO_CONF_OPTS += -DNEED_RKNNAPI=1
define RKNN_DEMO_BUILD_CMDS
		$(INSTALL) -D -m 0644 $(@D)/rknn/rknn_api/librknn_api.so $(TARGET_DIR)/usr/lib
		$(INSTALL) -D -m 0644 $(@D)/rknn/rknn_api/librknn_api.so $(STAGING_DIR)/usr/lib
		$(TARGET_MAKE_ENV) $($(PKG)_MAKE_ENV) $($(PKG)_MAKE) $($(PKG)_MAKE_OPTS) -C $($(PKG)_BUILDDIR)
endef
endif

ifeq ($(BR2_PACKAGE_RKNN_DEMO_ENABLE_JOINT),y)
	RKNN_DEMO_CONF_OPTS += -DENABLE_JOINT=1
else
	RKNN_DEMO_CONF_OPTS += -DENABLE_SSD=1
endif


ifeq ($(BR2_PACKAGE_RKNN_DEMO_ENABLE_JOINT),y)
define RKNN_DEMO_INSTALL_TARGET_CMDS
		mkdir -p $(TARGET_DIR)/usr/share/rknn_demo/
		mkdir -p $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0644 $(@D)/rknn/joint/cpm.rknn $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/minigui/MiniGUI.cfg $(TARGET_DIR)/etc
		cp -r $(@D)/minigui/ $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0755 $(@D)/rknn_demo $(TARGET_DIR)/usr/bin
endef
else
ifeq ($(BR2_PACKAGE_RK1808),y)
define RKNN_DEMO_INSTALL_TARGET_CMDS
		mkdir -p $(TARGET_DIR)/usr/share/rknn_demo/
		mkdir -p $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/ssd_1808/ssd_inception_v2.rknn $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/ssd_1808/coco_labels_list.txt $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/ssd_1808/box_priors.txt $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/minigui/MiniGUI-1280x720.cfg $(TARGET_DIR)/etc/MiniGUI.cfg
		cp -r $(@D)/minigui/ $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0755 $(@D)/rknn_demo $(TARGET_DIR)/usr/bin
endef
else
define RKNN_DEMO_INSTALL_TARGET_CMDS
		mkdir -p $(TARGET_DIR)/usr/share/rknn_demo/
		mkdir -p $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/ssd_3399pro/mobilenet_ssd.rknn $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/ssd_3399pro/coco_labels_list.txt $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/rknn/ssd/ssd_3399pro/box_priors.txt $(TARGET_DIR)/usr/share/rknn_demo/
		$(INSTALL) -D -m 0644 $(@D)/minigui/MiniGUI-2048x1536.cfg $(TARGET_DIR)/etc/MiniGUI.cfg
		cp -r $(@D)/minigui/ $(TARGET_DIR)/usr/local/share/
		$(INSTALL) -D -m 0755 $(@D)/rknn_demo $(TARGET_DIR)/usr/bin
endef
endif
endif

$(eval $(cmake-package))