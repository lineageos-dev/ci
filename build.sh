#!/bin/bash -e

CUR_DIR=$(pwd)

mkdir lineageos
mkdir release

get_sources() {
  cd lineageos

  repo init -u https://github.com/LineageOS/android.git -b cm-14.1 --depth 1
  curl -sSL --create-dirs -o .repo/local_manifests/vendor.xml https://github.com/lineageos-dev/android_local_manifests/raw/cm-14.1/vendor.xml
  curl -sSL --create-dirs -o .repo/local_manifests/remove.xml https://github.com/lineageos-dev/android_local_manifests/raw/cm-14.1/remove.xml
  repo sync -c --no-tags --no-clone-bundle -j8

  cd $CUR_DIR
}

build_firmware() {
  cd lineageos

  #source build/envsetup.sh
  #breakfast lineage_hammerhead-userdebug
  #brunch lineage_hammerhead-userdebug

  # workaround: https://review.lineageos.org/#/c/162577/
  source build/envsetup.sh
  breakfast lineage_hammerhead-userdebug
  lunch lineage_hammerhead-userdebug
  make org.cyanogenmod.platform-res
  make -j$(nproc) bacon

  cd $CUR_DIR
}

dist_release() {
  cp lineageos/out/target/product/hammerhead/lineage-*.zip* release/ 2>/dev/null || true
}

get_sources
build_firmware
dist_release
