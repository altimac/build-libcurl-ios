Main Goal of this branch
=================
The master branch goal was to provide a new XCFramework to use the very last tools provided by Apple. Unfortunately XCFramework seems not to be compatible with legacy iOS architectures such as armv7 (and armv7s?). This is ridiculous and I spent too much time fighting with these tools...
So I changed my mind and created this branch called "no_XCFramework_but_with_armv7" which basically goes back in history and build a static library for each architectures and merge them with lipo in a final libcurl.a library.


libcurl for iOS
=================
Build libcurl for iOS development.  
This script will generate static library for armv7 armv7s arm64 i386 and x86_64.  
Bitcode support.  
Darwin native ssl support.
Should work with almost any libcurl version but consider 7.69.1 as a minimum
  please download libcurl from here: http://curl.haxx.se/download.html  
  
Tested Xcode 11.4 on macOS 10.15.3  
Tested curl 7.69.1 

Note
=================
the build_libcurl_dist.sh script contains a harcoded reference to the untared directory "curl-7.69.1". So you must update this in case you use another libcurl version.

Usage
=================
```
curl -O https://curl.haxx.se/download/curl-7.69.1.tar.gz
tar xf curl-7.69.1.tar.gz
bash build_libcurl_dist.sh

```
Find the result dist directory that is at the root of this project.
Note that the script is a bit messy and the intermediate products of the build are put at the root of this project and are not cleaned... so please look at the "dist/" folder after the build to find:
- the headers of libcurl placed in the "dist/include" folder.
- the binary of libcurl placed in the "dist/lib" folder.