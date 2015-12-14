PRODUCT_BRAND ?= antos

PRODUCT_BOOTANIMATION := vendor/antos/prebuilt/common/bootanimation/bootanimation.zip

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=dd-MM-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/antos/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/antos/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/antos/prebuilt/common/bin/50-ant.sh:system/addon.d/50-ant.sh \
    vendor/antos/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

#Root by default
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1

#extras
PRODUCT_COPY_FILES += \
    vendor/antos/prebuilt/common/etc/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/antos/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon 

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/antos/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/antos/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/antos/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/antos/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# CM-specific init file
PRODUCT_COPY_FILES += \
    vendor/antos/prebuilt/common/etc/init.local.rc:root/init.antos.rc

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/antos/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is CM!
PRODUCT_COPY_FILES += \
    vendor/antos/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Theme engine
include vendor/antos/config/themes_common.mk

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    BluetoothExt \
    Profiles

# Optional CM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji \
    Terminal

# Custom CM packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    AudioFX \
    OTAUpdates \
    Eleven \
    LockClock \
    CyanogenSetupWizard \
    CMSettingsProvider \
    ExactCalculator

# CM Platform Library
PRODUCT_PACKAGES += \
    org.cyanogenmod.platform-res \
    org.cyanogenmod.platform \
    org.cyanogenmod.platform.xml

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    tune2fs \
    nano \
    htop \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# TCM (TCP Connection Management)
PRODUCT_PACKAGES += \
    tcmiface

PRODUCT_BOOT_JARS += \
    tcmiface

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

PRODUCT_PACKAGE_OVERLAYS += vendor/antos/overlay/common

# Ant-OS version
ANT_RELEASE = false
ANT_VERSION_MAJOR = 6.0
ANT_VERSION_MINOR = 1

# Release
ifeq ($(ANT_RELEASE),true)
    ANT_VERSION := ant-$(ANT_VERSION_MAJOR).$(ANT_VERSION_MINOR)-$MILESTONE-$(shell date -u +%d%m%Y)-$(ANT_BUILD)
else
    ANT_VERSION := ant-$(ANT_VERSION_MAJOR).$(ANT_VERSION_MINOR)-$(shell date -u +%d%m%Y)-$(ANT_BUILD)
endif

ANT_DISPLAY_VERSION := $(ANT_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.ant.version=$(ANT_VERSION) \
  ro.modversion=$(ANT_VERSION) \

PRODUCT_PROPERTY_OVERRIDES += \
  ro.ant.display.version=$(ANT_DISPLAY_VERSION)

-include vendor/ant-priv/keys/keys.mk

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

ifndef CM_PLATFORM_SDK_VERSION
  # This is the canonical definition of the SDK version, which defines
  # the set of APIs and functionality available in the platform.  It
  # is a single integer that increases monotonically as updates to
  # the SDK are released.  It should only be incremented when the APIs for
  # the new release are frozen (so that developers don't write apps against
  # intermediate builds).
  CM_PLATFORM_SDK_VERSION := 4
endif

ifndef CM_PLATFORM_REV
  # For internal SDK revisions that are hotfixed/patched
  # Reset after each CM_PLATFORM_SDK_VERSION release
  # If you are doing a release and this is NOT 0, you are almost certainly doing it wrong
  CM_PLATFORM_REV := 0
endif

# OTA Updates
PRODUCT_PROPERTY_OVERRIDES += \
  ro.ota.romname=$(ANT_VERSION) \
  ro.ota.version=$(shell date -u +%d%m%Y) \
  ro.ota.manifest=https://leonevorom.co.nf/ota/shamu/shamu.xml

# CyanogenMod Platform SDK Version
PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.build.version.plat.sdk=$(CM_PLATFORM_SDK_VERSION)

# CyanogenMod Platform Internal
PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.build.version.plat.rev=$(CM_PLATFORM_REV)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
