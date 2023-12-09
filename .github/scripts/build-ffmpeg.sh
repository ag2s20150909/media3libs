echo "Build FFmpeg"
echo $ANDROID_NDK_HOME
echo $FFMPEG_MODULE_PATH
echo $NDK_PATH
echo $HOST_PLATFORM
echo $ENABLED_DECODERS

cd "${FFMPEG_MODULE_PATH}/jni"
git clone git://source.ffmpeg.org/ffmpeg
cd ffmpeg
git checkout release/4.2
FFMPEG_PATH="$(pwd)"
chmod +x ./build_ffmpeg.sh
./build_ffmpeg.sh "${FFMPEG_MODULE_PATH}" "${NDK_PATH}" "${HOST_PLATFORM}" "${ENABLED_DECODERS[@]}"