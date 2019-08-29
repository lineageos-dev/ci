#!/bin/bash -e

get_sources() {
  mkdir lineageos
  cd lineageos

  repo init -u https://github.com/LineageOS/android.git -b lineage-15.1 --depth 1
  curl -sSL --create-dirs -o .repo/local_manifests/vendor.xml \
    https://github.com/lineageos-dev/android_local_manifests/raw/lineage-15.1/vendor.xml
  curl -sSL --create-dirs -o .repo/local_manifests/remove.xml \
    https://github.com/lineageos-dev/android_local_manifests/raw/lineage-15.1/remove.xml
  repo sync -c --no-tags --no-clone-bundle -j8

  cd ..
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
  #make org.cyanogenmod.platform-res
  make -j$(nproc) bacon

  cd ..
}

get_sources
build_firmware
