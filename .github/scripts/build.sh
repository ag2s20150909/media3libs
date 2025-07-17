#!/bin/bash
set -eux

echo $ANDROID_NDK_HOME
echo $NDK_PATH

chmod +x ${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-av1.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-flac.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-opus.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-vp9.sh
chmod +x ${ROOT_DIR}/.github/scripts/build-iamf.sh

cd media
export MEDIA3_PATH="$(pwd)"


${ROOT_DIR}/.github/scripts/build-ffmpeg.sh
${ROOT_DIR}/.github/scripts/build-av1.sh
${ROOT_DIR}/.github/scripts/build-flac.sh
${ROOT_DIR}/.github/scripts/build-opus.sh
${ROOT_DIR}/.github/scripts/build-vp9.sh
${ROOT_DIR}/.github/scripts/build-iamf.sh
cd ${MEDIA3_PATH}
./gradlew publishToMavenLocal



cd ${ROOT_DIR}
mkdir -p repo
mv ~/.m2/repository/* repo


git config --local user.email "github-action@users.noreply.github.com"
git config --local user.name "GitHub Action"
git add repo/**
git commit -m "build aar"
