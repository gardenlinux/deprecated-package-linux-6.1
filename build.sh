#!/usr/bin/env bash
set -exuo pipefail

thisDir="$(dirname "$(readlink -f "$BASH_SOURCE")")"

function ask {
    read -p "$1 [yY]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        return 0
    else
        return 1
    fi    
}

function spawn_container(){
    WORKSPACE=$(pwd)
    CONTAINER_IMAGE="vincinator/devcontainer-amd64:latest"

    [ ! -d "$WORKSPACE" ] && echo "$WORKSPACE does not exist." && exit 1

    docker run \
        -u $(id -u):$(id -g)  \
        -ti \
        --device /dev/fuse \
        --privileged \
        -v ~/.ssh:/home/vincinator/.ssh \
        -v "${WORKSPACE}":/workspace \
        --rm \
        -w /workspace \
        "${CONTAINER_IMAGE}" \
        $1
}


if ask 'You should execute build in a container. Spawn container and continue in container? yY'; then
  spawn_container $0
fi


# Requirements (please install yourself)
#  apt-get install -qy --no-install-recommends curl devscripts git kernel-wedge pristine-lfs python3-debian python3-jinja2 quilt rsync
#

export JOB_HOST_ARCH=${JOB_HOST_ARCH:-amd64}
export DEB_BUILD_OPTIONS="${DEB_BUILD_OPTIONS:-} nodoc terse"
export DEB_BUILD_PROFILES="${DEB_BUILD_PROFILES:-} nodoc nopython pkg.linux.nokerneldbg"
export DEBFULLNAME="Garden Linux builder"
export DEBEMAIL="contact@gardenlinux.io"

# Creates _output dir containing source package
./prepare-source


# Cross Build
if [[ $JOB_HOST_ARCH != $(dpkg --print-architecture) ]]; then
  export DEB_BUILD_OPTIONS="${DEB_BUILD_OPTIONS:-} nocheck"
  export DEB_BUILD_PROFILES="${DEB_BUILD_PROFILES:-} cross"
fi

cd _output
dpkg-source -x *.dsc src
sudo chown nobody -R .
cd src
sudo su -s /bin/sh -c "set -euE; dpkg-buildpackage -B -a $JOB_HOST_ARCH" nobody

