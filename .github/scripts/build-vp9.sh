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
echo "
android {
    namespace 'androidx.media3.decoder.vp9'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-vp9'
     releaseName = 'Media3 vp9 module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"
