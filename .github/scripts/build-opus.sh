#!/bin/bash

echo "Build Opus"

OPUS_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_opus/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_opus/build.gradle"


#Fetch libopus:

cd "${OPUS_MODULE_PATH}/jni" 
git clone --depth=1 https://gitlab.xiph.org/xiph/opus.git libopus

## Enable publishing
echo "
android {
    namespace 'androidx.media3.decoder.opus'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-opus'
     releaseName = 'Media3 opus module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"