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
git clone --depth=1 https://chromium.googlesource.com/codecs/libgav1

#Fetch Abseil:
cd "${AV1_MODULE_PATH}/jni/libgav1" && \
git clone https://github.com/abseil/abseil-cpp.git third_party/abseil-cpp -b 20250512.0


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

