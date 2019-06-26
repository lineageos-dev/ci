#!/bin/bash -e

CUR_DIR=$(pwd)

setup_environment() {
  git config --global user.name "Circle CI"
  git config --global user.email "sayhi@circleci.com"
  git config --global color.ui auto
  git config --global log.date iso

  ccache -M 30G
}

get_sources() {
  mkdir lineageos
  cd lineageos

  repo init -u https://github.com/LineageOS/android.git -b cm-14.1 --depth 1
  curl -sSL --create-dirs -o .repo/local_manifests/vendor.xml https://raw.githubusercontent.com/hammerhead-dev/android_local_manifests_for_ci/cm-14.1/local_manifest.xml
  curl -sSL --create-dirs -o .repo/local_manifests/remove.xml https://raw.githubusercontent.com/hammerhead-dev/android_local_manifests_for_ci/cm-14.1/remove.xml
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
  make -j2 bacon

  cd $CUR_DIR
}

dist_release() {
  mkdir release
  cp lineageos/out/target/product/hammerhead/*hammerhead* release || true
  cp lineageos/out/target/product/hammerhead/*.img release || true
  cp lineageos/out/target/product/hammerhead/*.txt release || true
  cp lineageos/out/target/product/hammerhead/*.json release || true
  cp lineageos/out/target/product/hammerhead/kernel release || true
}

while sleep 60s; do echo "keep building --> $SECONDS seconds"; done &
setup_environment
get_sources
build_firmware
dist_release
kill %1
