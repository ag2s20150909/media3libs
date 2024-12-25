#!/bin/bash

echo "Build IAMF"

IAMF_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_iamf/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_iamf/build.gradle"

## Fetch libiamf
cd "${IAMF_MODULE_PATH}/jni"
git clone --depth=1  https://github.com/AOMediaCodec/libiamf.git libiamf



## Enable publishing

echo "
android {
    namespace 'androidx.media3.decoder.iamf'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-iamf'
     releaseName = 'Media3 iamf module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"