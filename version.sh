SOURCE_UPSTREAM_VRSION=6.1
SOURCE_NAME=linux-$SOURCE_UPSTREAM_VRSION
DEBIAN_REF=debian/6.1.8-1
DEBIAN_MAIN_REF=e8e43f8550743f0f5603b6bb4f551f3c35416d88
#UPSTREAM_VERSION_OVERRIDE=

DEBIAN_REPO=https://salsa.debian.org/kernel-team/linux.git
UPSTREAM_REPO=https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

function upstream_version() {
  if [[ ${UPSTREAM_VERSION_OVERRIDE:-} ]]; then
    echo "$UPSTREAM_VERSION_OVERRIDE"
  else
    git ls-remote --tags $UPSTREAM_REPO | perl -ne 'if (m#refs/tags/v(\Q'"$SOURCE_UPSTREAM_VRSION"'\E\.[0-9.]+)$#) { print $1."\n"; }' | sort -r -V | head -n 1
  fi
}
