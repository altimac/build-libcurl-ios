MOST OF THIS WORKED. Except the script was failing to grep the curl version.
My fix is simply to hardcode the CURL_VERSION number :

//AH: this does not work, so i've hardcoded the curl version instead
//CURL_VERSION=$(grep -i CURLVERSION "$CURLDIR/Makefile")
//CURL_VERSION="${CURL_VERSION//CURLVERSION = /}"
CURL_VERSION="7.69.1"

Also, if you have a problem when compiling such as "configure: error: C compiler cannot create executables", then
Ensures the path to Xcode.app bundle is without space or strange characters. I had Xcode installed in ~/Downloads/Last Dev Tools/ folder, so with spaces and renaming the folder to LastDevTools fixed this (after resetting xcode-select -p though)

I've also changed the way the framework is built so that it supports BITCODE that is more or less needed in 2020.

**I also wanted to target the armv7 architecture, but it seems it's not possible with XCFramework :-(
So i've added another branch "no_XCFramework_but_with_armv7" that simply creates a static lib, which supports armv7 :-( at the end this is the branch I'm using in most of my projects...**

# libcurl for iOS

Build libcurl for iOS development.
This script will generate a XCFramework with embedded static libraries for arm64 and x86_64 (simulator) architectures.

The SSL library used is SecureTransport.

Script only, please download libcurl from here: http://curl.haxx.se/download.html

Tested with:

- Xcode 11.4
- macOS 10.15.3
- curl 7.69.1

# Usage

```bash
curl -O https://curl.haxx.se/download/curl-7.69.1.tar.gz
tar xf curl-7.69.1.tar.gz
bash build_libcurl_dist.sh curl-7.69.1
```

The resulting `curl.xcframework` will be created in a `dist` directory in the current directory.

# Using the created XCFramework in your project

Add the framework in the "General" tab of your target, in the "Frameworks, Libraries, and Embedded Content" section.

See [WWDC 2019 Session 416 : Binary Frameworks in Swift](https://developer.apple.com/videos/play/wwdc2019/416/) for more info.
