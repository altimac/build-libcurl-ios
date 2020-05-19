#!/bin/bash -euo pipefail

readonly XCODE_DEV="$(xcode-select -p)"
export DEVROOT="${XCODE_DEV}/Toolchains/XcodeDefault.xctoolchain"
DFT_DIST_DIR="${CURRENT_DIR}/dist"
DIST_DIR=${DIST_DIR:-$DFT_DIST_DIR}

function build_for_arch() {
  ARCH=$1
  HOST=$2
  SYSROOT=$3
  PREFIX=$4
  IPHONEOS_DEPLOYMENT_TARGET="10.0"
  export PATH="${DEVROOT}/usr/bin/:${PATH}"
  export CFLAGS="-DCURL_BUILD_IOS -arch ${ARCH} -pipe -Os -gdwarf-2 -isysroot ${SYSROOT} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -fembed-bitcode"
  export LDFLAGS="-arch ${ARCH} -isysroot ${SYSROOT}"
  ./curl-7.69.1/configure --disable-shared --without-zlib --enable-static --enable-ipv6 --enable-ftp --with-darwinssl --without-libidn2 --host="${HOST}" --prefix=${PREFIX} && make -j8 && make install
}

TMP_DIR=/tmp/build_libcurl_$$

build_for_arch i386 i386-apple-darwin ${XCODE_DEV}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk ${TMP_DIR}/i386 || exit 1
build_for_arch x86_64 x86_64-apple-darwin ${XCODE_DEV}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk ${TMP_DIR}/x86_64 || exit 2
build_for_arch arm64 arm-apple-darwin ${XCODE_DEV}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk ${TMP_DIR}/arm64 || exit 3
build_for_arch armv7s armv7s-apple-darwin ${XCODE_DEV}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk ${TMP_DIR}/armv7s || exit 4
build_for_arch armv7 armv7-apple-darwin ${XCODE_DEV}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk ${TMP_DIR}/armv7 || exit 5

mkdir -p ${TMP_DIR}/lib/
${DEVROOT}/usr/bin/lipo \
  -arch x86_64 ${TMP_DIR}/x86_64/lib/libcurl.a \
  -arch armv7 ${TMP_DIR}/armv7/lib/libcurl.a \
  -arch armv7s ${TMP_DIR}/armv7s/lib/libcurl.a \
  -arch arm64 ${TMP_DIR}/arm64/lib/libcurl.a \
  -output ${TMP_DIR}/lib/libcurl.a -create

cp -r ${TMP_DIR}/arm64/include ${TMP_DIR}/

mkdir -p ${DIST_DIR}
cp -r ${TMP_DIR}/include ${TMP_DIR}/lib ${DIST_DIR}

