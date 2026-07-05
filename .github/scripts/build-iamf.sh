#!/bin/bash

echo "Build IAMF"

IAMF_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_iamf/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_iamf/build.gradle"

## Fetch libiamf
cd "${IAMF_MODULE_PATH}/jni"
git clone https://github.com/AOMediaCodec/iamf-tools.git iamf_tools 
cd iamf_tools 
git reset --hard de364b983

cd "${IAMF_MODULE_PATH}/jni"
./build_iamf_tools.sh ${IAMF_MODULE_PATH}




## Enable publishing

if [[ -f "$GD_PATH" ]]; then
    echo "apply from: '../../publish.gradle'">>"${GD_PATH}"
else
    echo 'apply(plugin = "media3.publish")'>>"${GD_PATH}.kts"
fi