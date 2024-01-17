#!/bin/bash
set -eux

echo $ANDROID_NDK_HOME
echo $NDK_PATH

chmod +x ${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-av1.sh

git clone   https://github.com/androidx/media
cd media
git checkout 324e1be
export MEDIA3_PATH="$(pwd)"


${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
${ROOT_DIR}/.github/scripts/build-av1.sh
cd ${MEDIA3_PATH}
./gradlew publishToMavenLocal



cd ${ROOT_DIR}
mkdir -p repo
mv ~/.m2/repository/* repo
tree
git add repo/**
