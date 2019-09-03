#!/bin/bash -e

get_sources() {
  mkdir lineage
  cd lineage

  repo init -u https://github.com/LineageOS/android.git -b lineage-15.1 --depth 1
  git clone https://github.com/lineageos-dev/android_local_manifests.git --single-branch -b lineage-15.1 .repo/local_manifests
  repo sync -c --no-tags --no-clone-bundle -j8 -q

  cd ..
}

build_firmware() {
  cd lineage

  source build/envsetup.sh
  lunch lineage_hammerhead-userdebug
  #mka bacon
  make -j8 bacon

  cd ..
}

get_sources
build_firmware
