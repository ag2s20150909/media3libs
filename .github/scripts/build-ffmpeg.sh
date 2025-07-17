#!/bin/bash
set -eu

FFMPEG_MODULE_PATH="${MEDIA3_PATH}/libraries/decoder_ffmpeg/src/main"
GD_PATH="${MEDIA3_PATH}/libraries/decoder_ffmpeg/build.gradle"

echo "
android {
    namespace 'androidx.media3.decoder.ffmpeg'

    publishing {
        singleVariant('release') {
            withSourcesJar()
        }
    }
}
ext {
     releaseArtifactId = 'media3-decode-ffmpeg'
     releaseName = 'Media3 ffmpeg module'
     }
     apply from: '../../publish.gradle'
">>"${GD_PATH}"

#cat "${GD_PATH}"

echo "Build FFmpeg"
echo $ANDROID_NDK_HOME
echo $NDK_PATH
ANDROID_ABI=21
HOST_PLATFORM="linux-x86_64"
ENABLED_DECODERS=(vorbis opus flac alac pcm_mulaw pcm_alaw mp3 aac ac3 eac3 dca mlp truehd)


echo "NDK path is ${NDK_PATH}"
echo "FFMPEG_MODULE_PATH is ${FFMPEG_MODULE_PATH}"
echo "Host platform is ${HOST_PLATFORM}"
echo "ANDROID_ABI is ${ANDROID_ABI}"
echo "Enabled decoders are ${ENABLED_DECODERS[@]}"


cd "${FFMPEG_MODULE_PATH}/jni"

rm -rf ffmpeg

git clone --depth=1 -b release/6.0  git://source.ffmpeg.org/ffmpeg
cd ffmpeg
FFMPEG_PATH="$(pwd)"
pwd

JOBS=$(nproc 2> /dev/null || sysctl -n hw.ncpu 2> /dev/null || echo 4)
echo "Using $JOBS jobs for make"


COMMON_OPTIONS="
    --target-os=android
    --enable-static
    --disable-shared
    --disable-doc
    --disable-programs
    --disable-everything
    --disable-avdevice
    --disable-avformat
    --disable-swscale
    --disable-postproc
    --disable-avfilter
    --disable-symver
    --enable-swresample
    --extra-ldexeflags=-pie
    --disable-v4l2-m2m
    --disable-vulkan
    "
TOOLCHAIN_PREFIX="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/bin"
for decoder in "${ENABLED_DECODERS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-decoder=${decoder}"
done

ARMV7_CLANG="${TOOLCHAIN_PREFIX}/armv7a-linux-androideabi${ANDROID_ABI}-clang"
if [[ -e "${TOOLCHAIN_PREFIX}" && ! -e "$ARMV7_CLANG" ]]
then
    echo "AVMv7 Clang compiler with path $ARMV7_CLANG does not exist"
    echo "It's likely your NDK version doesn't support ANDROID_ABI $ANDROID_ABI"
    echo "Either use older version of NDK or raise ANDROID_ABI (be aware that ANDROID_ABI must not be greater than your application's minSdk)"
    exit 1
fi
ANDROID_ABI_64BIT="$ANDROID_ABI"
if [[ "$ANDROID_ABI_64BIT" -lt 21 ]]
then
    echo "Using ANDROID_ABI 21 for 64-bit architectures"
    ANDROID_ABI_64BIT=21
fi

./configure \
    --libdir=android-libs/armeabi-v7a \
    --arch=arm \
    --cpu=armv7-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/armv7a-linux-androideabi${ANDROID_ABI}-" \
    --nm="${TOOLCHAIN_PREFIX}/llvm-nm" \
    --ar="${TOOLCHAIN_PREFIX}/llvm-ar" \
    --ranlib="${TOOLCHAIN_PREFIX}/llvm-ranlib" \
    --strip="${TOOLCHAIN_PREFIX}/llvm-strip" \
    --extra-cflags="-march=armv7-a -mfloat-abi=softfp" \
    --extra-ldflags="-Wl,--fix-cortex-a8" \
    ${COMMON_OPTIONS}
make -j$JOBS
make install-libs
make clean
./configure \
    --libdir=android-libs/arm64-v8a \
    --arch=aarch64 \
    --cpu=armv8-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/aarch64-linux-android${ANDROID_ABI_64BIT}-" \
    --nm="${TOOLCHAIN_PREFIX}/llvm-nm" \
    --ar="${TOOLCHAIN_PREFIX}/llvm-ar" \
    --ranlib="${TOOLCHAIN_PREFIX}/llvm-ranlib" \
    --strip="${TOOLCHAIN_PREFIX}/llvm-strip" \
    ${COMMON_OPTIONS}
make -j$JOBS
make install-libs
make clean
./configure \
    --libdir=android-libs/x86 \
    --arch=x86 \
    --cpu=i686 \
    --cross-prefix="${TOOLCHAIN_PREFIX}/i686-linux-android${ANDROID_ABI}-" \
    --nm="${TOOLCHAIN_PREFIX}/llvm-nm" \
    --ar="${TOOLCHAIN_PREFIX}/llvm-ar" \
    --ranlib="${TOOLCHAIN_PREFIX}/llvm-ranlib" \
    --strip="${TOOLCHAIN_PREFIX}/llvm-strip" \
    --disable-asm \
    ${COMMON_OPTIONS}
make -j$JOBS
make install-libs
make clean
./configure \
    --libdir=android-libs/x86_64 \
    --arch=x86_64 \
    --cpu=x86-64 \
    --cross-prefix="${TOOLCHAIN_PREFIX}/x86_64-linux-android${ANDROID_ABI_64BIT}-" \
    --nm="${TOOLCHAIN_PREFIX}/llvm-nm" \
    --ar="${TOOLCHAIN_PREFIX}/llvm-ar" \
    --ranlib="${TOOLCHAIN_PREFIX}/llvm-ranlib" \
    --strip="${TOOLCHAIN_PREFIX}/llvm-strip" \
    --disable-asm \
    ${COMMON_OPTIONS}
make -j$JOBS
make install-libs
make clean
