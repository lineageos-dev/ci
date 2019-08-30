#!/bin/bash -e

get_sources() {
  mkdir lineageos
  cd lineageos

  repo init -u https://github.com/LineageOS/android.git -b cm-14.1 --depth 1
  curl -sSL --create-dirs -o .repo/local_manifests/vendor.xml \
    https://github.com/lineageos-dev/android_local_manifests/raw/cm-14.1/vendor.xml
  curl -sSL --create-dirs -o .repo/local_manifests/remove.xml \
    https://github.com/lineageos-dev/android_local_manifests/raw/cm-14.1/remove.xml
  repo sync -c --no-tags --no-clone-bundle -j8 -q

  cd ..
}

build_firmware() {
  cd lineageos

  source build/envsetup.sh
  lunch lineage_hammerhead-userdebug
  mka bacon

  cd ..
}

get_sources
build_firmware
