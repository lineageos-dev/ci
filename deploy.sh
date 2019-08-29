#!/bin/bash -e

prepare() {
  local api_url="https://api.github.com/repos/tcnksm/ghr/releases/latest"
  local download_tag=$(curl -sSL $api_url | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
  local download_url=$(curl -sSL $api_url | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)

  curl -sSL $download_url | sudo -E tar -zxf - -C /usr/local/bin/ ghr_${download_tag}_linux_amd64/ghr --strip-components 1
}

release() {
  mkdir release
  # TODO: loop copy for multi devices.
  cp lineageos/out/target/product/hammerhead/lineage-*.zip* release/ 2>/dev/null || true
}

deploy() {
  local release_version="$CIRCLE_BRANCH-$(date +'%Y%m%d')"

  ghr -t $GITHUB_TOKEN \
    -u $CIRCLE_PROJECT_USERNAME \
    -r $CIRCLE_PROJECT_REPONAME \
    -c $CIRCLE_SHA1 \
    -n $release_version \
    -delete \
    $release_version release
}

prepare
release
deploy
