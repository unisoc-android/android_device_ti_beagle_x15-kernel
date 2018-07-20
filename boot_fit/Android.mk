ifneq ($(filter beagle_x15%, $(TARGET_DEVICE)),)
ifeq ($(TARGET_BOOTIMAGE_FIT), true)

MKIMAGE := $(HOST_OUT_EXECUTABLES)/mkimage
DTC_FLAGS_MKIMAGE = -I dts -O dtb -p 500 -Wno-unit_address_vs_reg
BOARD_DIR := device/ti/beagle_x15
FIT_DIR := $(PRODUCT_OUT)/obj/fit
ITS := beagle_x15.its
BOOTIMG_FIT := $(PRODUCT_OUT)/boot_fit.img

$(BOOTIMG_FIT): $(INSTALLED_KERNEL_TARGET) $(INSTALLED_RAMDISK_TARGET) $(BOARD_DIR)/$(ITS) $(MKIMAGE)
	mkdir -p $(FIT_DIR)
	cp $(BOARD_DIR)/$(ITS) $(FIT_DIR)
	cp $(INSTALLED_RAMDISK_TARGET) $(FIT_DIR)
	cp $(INSTALLED_KERNEL_TARGET) $(FIT_DIR)/zImage
	cp $(LOCAL_KERNEL)/*.dtb $(FIT_DIR)
	$(MKIMAGE) -D "$(DTC_FLAGS_MKIMAGE)" -f $(FIT_DIR)/$(ITS) $@

include $(CLEAR_VARS)
LOCAL_MODULE := bootfitimage
LOCAL_ADDITIONAL_DEPENDENCIES := $(BOOTIMG_FIT)
include $(BUILD_PHONY_PACKAGE)

endif
endif
