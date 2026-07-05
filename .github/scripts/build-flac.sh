#!/bin/bash

echo "Build Flac"

FLAC_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_flac/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_flac/build.gradle"


## Fetch libflac

cd "${FLAC_MODULE_PATH}/jni"

git clone --depth=1  https://github.com/xiph/flac.git libflac



## Enable publishing

if [[ -f "$GD_PATH" ]]; then
    echo "apply from: '../../publish.gradle'">>"${GD_PATH}"
else
    echo 'apply(plugin = "media3.publish")'>>"${GD_PATH}.kts"
fi