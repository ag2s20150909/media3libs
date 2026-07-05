#!/bin/bash

echo "Build Opus"

OPUS_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_opus/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_opus/build.gradle"


#Fetch libopus:

cd "${OPUS_MODULE_PATH}/jni" 
git clone --depth=1 https://gitlab.xiph.org/xiph/opus.git libopus

## Enable publishing

if [[ -f "$GD_PATH" ]]; then
    echo "apply from: '../../publish.gradle'">>"${GD_PATH}"
else
    echo 'apply(plugin = "media3.publish")'>>"${GD_PATH}.kts"
fi