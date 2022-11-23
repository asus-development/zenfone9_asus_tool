#!/bin/bash


if [ "$1" == "all" ]; then
	rm -rf kernel_platform/out/
	rm -rf device/qcom/taro-kernel/
	rm -rf out/
	git checkout *.bp  *.mk
	rm -rf system/
	rm -r exports.txt
fi


# copy_target <to> <from>
function copy_target() {
	if [ -f "$1" -o -d "$1" ];then
		folder=$2
		mkdir -p $folder
		cp -r $1 $2
	else
		echo "[asus] $1 doesn't exist!"
		exit
	fi
}



set -e

export LTO=thin
export ANDROID_BUILD_TOP=$PWD
export TARGET_BOARD_PLATFORM=taro
export TARGET_BUILD_VARIANT=user
export ASUS_BUILD_PROJECT=AI2202
export ASUS_AI2202_AUDIO=y
export ASUS_AI2202_CAMERA=y
export ASUS_AI2202_DISPLAY=y
export ASUS_FTM=y
export ASUS_FTM_AUDIO=y
export ASUS_FTM_BUILD=y
export BUILD_VENDOR_DLKM=y
export ASUS_GKI_BUILD=y

export ANDROID_PRODUCT_OUT=${ANDROID_BUILD_TOP}/out/target/product/taro

echo "[asus]ANDROID_BUILD_TOP=$ANDROID_BUILD_TOP; TARGET_BOARD_PLATFORM=$TARGET_BOARD_PLATFORM"

./kernel_platform/build/android/prepare_vendor.sh waipio gki


echo "[asus] start build module"
cd kernel_platform

function build_vendor_ko()
{
#1
OUT_DIR=..//out/target/product/taro/obj/DLKM_OBJ/kernel_platform  KERNEL_KIT=..//device/qcom/taro-kernel ./build/build_module.sh MMRM_ROOT=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/mmrm-driver BOARD_PLATFORM=taro ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#2
EXT_MODULES=..//vendor/qcom/opensource/datarmnet-ext/sch ./build/build_module.sh ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#3
EXT_MODULES=..//vendor/qcom/opensource/datarmnet-ext/wlan ./build/build_module.sh  ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#4
EXT_MODULES=..//vendor/qcom/opensource/mmrm-driver ./build/build_module.sh  MMRM_ROOT=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/mmrm-driver BOARD_PLATFORM=taro ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}


copy_target ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/opensource/mmrm-driver/Module.symvers ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/mmrm-module-symvers_intermediates/
copy_target ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/opensource/mmrm-driver/Module.symvers ${ANDROID_BUILD_TOP}/out/target/product/taro/dlkm/lib/modules/
copy_target ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/opensource/mmrm-driver/driver/msm-mmrm.ko ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/msm-mmrm.ko_intermediates/
copy_target ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/opensource/mmrm-driver/driver/msm-mmrm.ko ${ANDROID_BUILD_TOP}/out/target/product/taro/dlkm/lib/modules/
copy_target ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/opensource/mmrm-driver             ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM_OBJ/vendor/qcom/opensource/

#5
EXT_MODULES=..//vendor/qcom/opensource/audio-kernel ./build/build_module.sh  AUDIO_ROOT=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/audio-kernel MODNAME=audio_dlkm BOARD_PLATFORM=taro ASUS_AI2202_AUDIO=y ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#6
EXT_MODULES=..//vendor/qcom/opensource/datarmnet/core ./build/build_module.sh ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#7
EXT_MODULES=..//vendor/qcom/opensource/cvp-kernel  ./build/build_module.sh  KBUILD_EXTRA_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/mmrm-module-symvers_intermediates/Module.symvers ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#8
EXT_MODULES=..//vendor/qcom/opensource/eva-kernel ./build/build_module.sh  KBUILD_EXTRA_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/mmrm-module-symvers_intermediates/Module.symvers  ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#9
EXT_MODULES=..//vendor/qcom/opensource/datarmnet-ext/aps   ./build/build_module.sh RMNET_CORE_INC_DIR=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/datarmnet/core RMNET_CORE_PATH=vendor/qcom/opensource/datarmnet/core DATARMNET_CORE_PATH=datarmnet/core ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#10
EXT_MODULES=..//vendor/qcom/opensource/datarmnet-ext/offload   ./build/build_module.sh  RMNET_CORE_INC_DIR=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/datarmnet/core RMNET_CORE_PATH=vendor/qcom/opensource/datarmnet/core DATARMNET_CORE_PATH=datarmnet/core  ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}

#11
EXT_MODULES=..//vendor/qcom/opensource/datarmnet-ext/perf_tether  ./build/build_module.sh RMNET_CORE_INC_DIR=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/datarmnet/core RMNET_CORE_PATH=vendor/qcom/opensource/datarmnet/core DATARMNET_CORE_PATH=datarmnet/core ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}

#12
EXT_MODULES=..//vendor/qcom/opensource/video-driver ./build/build_module.sh VIDEO_ROOT=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/video-driver MODNAME=msm_video BOARD_PLATFORM=taro CONFIG_MSM_VIDC_V4L2=m KBUILD_EXTRA_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/mmrm-module-symvers_intermediates/Module.symvers ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}

#13
EXT_MODULES=..//vendor/qcom/opensource/datarmnet-ext/shs   ./build/build_module.sh  RMNET_CORE_INC_DIR=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/datarmnet/core RMNET_CORE_PATH=vendor/qcom/opensource/datarmnet/core DATARMNET_CORE_PATH=datarmnet/core  ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#14
EXT_MODULES=..//vendor/qcom/opensource/datarmnet-ext/perf   ./build/build_module.sh  RMNET_CORE_INC_DIR=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/datarmnet/core RMNET_CORE_PATH=vendor/qcom/opensource/datarmnet/core DATARMNET_CORE_PATH=datarmnet/core RMNET_SHS_INC_DIR=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/datarmnet-ext/shs RMNET_SHS_PATH=vendor/qcom/opensource/datarmnet-ext/shs DATARMNET_SHS_PATH=datarmnet-ext/shs    ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}

#15
EXT_MODULES=..//vendor/qcom/opensource/dataipa/drivers/platform/msm ./build/build_module.sh  ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#16
EXT_MODULES=..//vendor/qcom/opensource/camera-kernel ./build/build_module.sh  CAMERA_KERNEL_ROOT=${ANDROID_BUILD_TOP}/vendor/qcom/opensource/camera-kernel KERNEL_ROOT=${ANDROID_BUILD_TOP}/kernel/msm-5.10/  MODNAME=camera BOARD_PLATFORM=taro KBUILD_EXTRA_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/mmrm-module-symvers_intermediates/Module.symvers ASUS_AI2202_CAMERA=y ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#17
EXT_MODULES=..//vendor/qcom/opensource/display-drivers/msm  ./build/build_module.sh  DISPLAY_ROOT=./vendor/qcom/opensource/display-drivers MODNAME=msm_drm BOARD_PLATFORM=taro CONFIG_DRM_MSM=m KBUILD_EXTRA_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/mmrm-module-symvers_intermediates/Module.symvers ASUS_AI2202_DISPLAY=y   ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
#18
EXT_MODULES=..//vendor/qcom/opensource/wlan/qcacld-3.0/.qca6490  ./build/build_module.sh  WLAN_ROOT=vendor/qcom/opensource/wlan/qcacld-3.0/.qca6490 WLAN_COMMON_ROOT=cmn WLAN_COMMON_INC=vendor/qcom/opensource/wlan/qcacld-3.0/cmn WLAN_FW_API=vendor/qcom/opensource/wlan/fw-api WLAN_PROFILE=qca6490 DYNAMIC_SINGLE_CHIP= MODNAME=qca6490 DEVNAME=qca6490 BOARD_PLATFORM=taro CONFIG_QCA_CLD_WLAN=m WLAN_CTRL_NAME=wlan CONFIG_CNSS_QCA6490=y    ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}

mv ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/opensource/wlan/qcacld-3.0/.qca6490/qca6490.ko ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/opensource/wlan/qcacld-3.0/.qca6490/qca_cld3_qca6490.ko
}
build_vendor_ko
echo "[asus] build kos success"

cd ${ANDROID_BUILD_TOP}


kernel_kos=`find ${ANDROID_BUILD_TOP}/device/qcom/taro-kernel/vendor_dlkm/ -name "*.ko"`
vendor_kos=`find ${ANDROID_BUILD_TOP}/kernel_platform/out/vendor/qcom/ -name "*.ko"`
prebuild_kos=`find ${ANDROID_BUILD_TOP}/prebuilts/tuxera/module/ -name "*.ko"`


rm -rf ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates
mkdir -p ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates/lib/modules/0.0/vendor/lib/modules/

rm -rf ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/
mkdir -p ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/
LLVM_STRIP=${ANDROID_BUILD_TOP}/kernel_platform/prebuilts-master/clang/host/linux-x86/clang-r416183c/bin/llvm-strip


function strip_kos(){
	for module in ${kernel_kos}
	do
		ko_name=$(basename $module)
		${LLVM_STRIP} -o  ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/${ko_name} --strip-debug ${module}
		echo "${LLVM_STRIP} -o  ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/${ko_name} --strip-debug ${module}"
	cp ${module} ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates/lib/modules/0.0/vendor/lib/modules/
	done

	for module in ${vendor_kos}
	do
		ko_name=$(basename $module)
		${LLVM_STRIP} -o  ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/${ko_name} --strip-debug ${module}
		echo "${LLVM_STRIP} -o  ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/${ko_name} --strip-debug ${module}"
	cp ${module} ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates/lib/modules/0.0/vendor/lib/modules/
	done

	for module in ${prebuild_kos}
	do
		ko_name=$(basename $module)
		${LLVM_STRIP} -o  ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/${ko_name} --strip-debug ${module}
		echo "${LLVM_STRIP} -o  ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/${ko_name} --strip-debug ${module}"
	cp ${module} ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates/lib/modules/0.0/vendor/lib/modules/
	done

	rm -rf ${ANDROID_BUILD_TOP}/out/target/product/taro/vendor_dlkm/lib/modules/
	mkdir -p ${ANDROID_BUILD_TOP}/out/target/product/taro/vendor_dlkm/lib/modules/
	cp -r ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_vendor_stripped_intermediates/*.ko ${ANDROID_BUILD_TOP}/out/target/product/taro/vendor_dlkm/lib/modules/
}

strip_kos

function depmod_kos(){
	mkdir -p ${ANDROID_BUILD_TOP}/out/target/product/taro/vendor_dlkm
	all_kos=`find ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates/lib/modules/0.0/vendor/lib/modules/ -name "*.ko"`
	for module in ${all_kos}
	do
		basename ${module} >> ${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates/lib/modules/0.0/modules.load

	done

	mkdir -p ${ANDROID_BUILD_TOP}/out/target/product/taro/vendor_dlkm/lib/modules/

	#for modules.blocklist
	rm -f ${ANDROID_BUILD_TOP}/out/target/product/taro/vendor_dlkm/lib/modules/modules.blocklist
	awk <"${ANDROID_BUILD_TOP}/device/qcom/taro-kernel/vendor_dlkm/modules.blocklist" >"${ANDROID_BUILD_TOP}/out/target/product/taro/vendor_dlkm/lib/modules/modules.blocklist"  '/^#/ { print; next } NF == 0 { next } NF != 2 || $1 != "blocklist"  { print "Invalid blocklist line " FNR ": "$0 >"/dev/stderr"; exit_status = 1; next } { $1 = $1; print } END { exit exit_status} '


}
depmod_kos

#########################################################################################################################################################
VENDOR_BOOT_DEST=device/qcom/taro-kernel/vendor_boot
rm -rf ${VENDOR_BOOT_DEST}
mkdir -p ${VENDOR_BOOT_DEST}

MODULES_OPENSOURCE_SRC=${ANDROID_BUILD_TOP}/out/target/product/taro/obj/DLKM/msm-mmrm.ko_intermediates
MODULES_OPENSOURCE_SRC1=${ANDROID_BUILD_TOP}/out/target/product/taro/obj/PACKAGING/depmod_VENDOR_intermediates/lib/modules/0.0/vendor/lib/modules
vendor_boot_kos=`find ${ANDROID_BUILD_TOP}/kernel_platform/out/msm-waipio-waipio-gki/dist/ -name "*.ko"`

cp ${MODULES_OPENSOURCE_SRC}/msm-mmrm.ko ${VENDOR_BOOT_DEST}
cp ${MODULES_OPENSOURCE_SRC1}/msm_drm.ko ${VENDOR_BOOT_DEST}

MODULES_STAGING_DIR=./

for FILE in ${vendor_boot_kos}; do
      ko_name=$(basename $FILE)
      ${LLVM_STRIP} -o ${VENDOR_BOOT_DEST}/${ko_name} --strip-debug ${FILE}
done

echo "[asus] vendor_boot ko success"
#########################################################################################################################################################

echo "[asus] custom build script success"
