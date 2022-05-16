#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/kluctl/kluctl/releases/download
APP=kluctl

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="${APP}_v${ver}_${platform}.${archive_type}"
    local url=$MIRROR/v$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    # https://github.com/kluctl/kluctl/releases/download/v2.10.2/kluctl_v2.10.2_checksums.txt
    local checksums="${APP}_v${ver}_checksums.txt"
    local url=$MIRROR/v$ver/$checksums
    local lchecksums="$DIR/${checksums}"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums darwin arm64
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums windows amd64 zip
}

dl_ver ${1:-2.10.2}
