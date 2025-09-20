#!/bin/bash
set -eux

echo "Build AV1"


AV1_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_av1/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_av1/build.gradle"

#Fetch cpu_features library:

cd "${AV1_MODULE_PATH}/jni"
git clone --depth=1 https://github.com/google/cpu_features

#Fetch libgav1:
cd "${AV1_MODULE_PATH}/jni"
git clone --depth=1 https://code.videolan.org/videolan/dav1d.git

cd "${AV1_MODULE_PATH}/jni"

HOST_PLATFORM="linux-x86_64"

./build_dav1d.sh \
  "${AV1_MODULE_PATH}" \
  "${NDK_PATH}" \
  "${HOST_PLATFORM}"




## Enable publishing
echo "
android {
    namespace 'androidx.media3.decoder.av1'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-av1'
     releaseName = 'Media3 av1 module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"

