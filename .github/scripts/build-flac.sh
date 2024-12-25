#!/bin/bash

echo "Build Flac"

FLAC_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_flac/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_flac/build.gradle"


## Fetch libflac

cd "${FLAC_MODULE_PATH}/jni"

git clone --depth=1  https://github.com/xiph/flac.git libflac



## Enable publishing

echo "
android {
    namespace 'androidx.media3.decoder.flac'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-flac'
     releaseName = 'Media3 flac module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"