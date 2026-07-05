#!/bin/bash

echo "Build Vp9"

VP9_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_vp9/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_vp9/build.gradle"


cd "${VP9_MODULE_PATH}/jni"

git clone --depth=1 -b v1.8.0 https://chromium.googlesource.com/webm/libvpx libvpx

chmod +x ./generate_libvpx_android_configs.sh
./generate_libvpx_android_configs.sh

${NDK_PATH}/ndk-build APP_ABI=all -j4


## Enable publishing

if [[ -f "$GD_PATH" ]]; then
    echo "apply from: '../../publish.gradle'">>"${GD_PATH}"
else
    echo 'apply(plugin = "media3.publish")'>>"${GD_PATH}.kts"
fi



