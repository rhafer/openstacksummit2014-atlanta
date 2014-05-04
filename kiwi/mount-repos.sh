#!/bin/bash

function bind_mount {
  src="$1" mnt="$2"
  if ! mount | grep -q " $mnt "; then
    if ! mount --bind "$src" "$mnt"; then
      echo >&2 "Failed to mount $src on $mnt"
      exit 1
    fi
  fi
}

function setup_overlay {
  : ${MIRROR_DIR:=/data/install/mirrors}
  here=`dirname $0`
  tftpboot=$here/source/root/srv/tftpboot
  bind_mount /mnt/sles-11-sp3  $tftpboot/suse-11.3/install
  bind_mount /mnt/suse-cloud-3 $tftpboot/repos/Cloud
  for repo in {{SLES11,SLE11-HAE}-SP3,SUSE-Cloud-3.0}-{Pool,Updates}; do
    bind_mount $MIRROR_DIR/$repo $tftpboot/repos/${repo/3.0/3}
  done
}

setup_overlay
