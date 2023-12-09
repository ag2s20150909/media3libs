#!/bin/bash
set -eux

echo $ANDROID_NDK_HOME
echo $NDK_PATH

git clone --depth=1 -b release  https://github.com/androidx/media
cd media
MEDIA3_PATH="$(pwd)"

chmod +x ${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-av1.sh
${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
${ROOT_DIR}/.github/scripts/build-av1.sh