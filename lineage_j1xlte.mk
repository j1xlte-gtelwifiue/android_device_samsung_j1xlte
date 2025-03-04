#
# Copyright (C) 2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := device/samsung/j1xlte

# Inherit from those products. Most specific first.
$(call inherit-product, $(LOCAL_PATH)/device.mk)

### Ubuntu Touch ###
#$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
#$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_l_mr1.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/runtime_libart.mk)
$(call inherit-product, vendor/halium/config/halium.mk)

# Inherit common Lineage phone.
#$(call inherit-product, vendor/lineage/config/common_full_phone.mk)
### End Ubuntu Touch ###

# Set those variables here to overwrite the inherited values.
PRODUCT_NAME := lineage_j1xlte
PRODUCT_DEVICE := j1xlte
PRODUCT_MODEL := SM-J120F
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_GMS_CLIENTID_BASE := android-samsung

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=j1xltejt \
    PRIVATE_BUILD_DESC="j1xltejt-user 5.1.1 LMY47X J120FXXU2AQH1 release-keys"

BUILD_FINGERPRINT := samsung/j1xltejt/j1xlte:5.1.1/LMY47X/J120FXXU2AQH1:user/release-keys

