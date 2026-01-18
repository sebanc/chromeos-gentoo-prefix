#!/usr/bin/env bash

rm -rf ./chroot
mkdir ./chroot

if [ -f ../chromiumos-stage3/chromiumos_stage3.tar.gz ]; then
	echo "Using local ChromiumOS Stage3"
	cp ../chromiumos-stage3/chromiumos_stage3.tar.gz ./chromiumos_stage3.tar.gz
else
	curl -L $(curl -L -s "https://api.github.com/repos/sebanc/chromiumos-stage3/releases/latest" | grep browser_download_url | tr -d '"' | sed 's#browser_download_url: ##g') -o ./chromiumos_stage3.tar.gz
fi
tar xf ./chromiumos_stage3.tar.gz -C ./chroot

echo 'nameserver 1.1.1.1' > ./chroot/etc/resolv.conf

mount -t proc none ./chroot/proc
mount --bind -o ro /sys ./chroot/sys
mount --make-slave ./chroot/sys
mount --bind /dev ./chroot/dev
mount --make-slave ./chroot/dev
mount --bind /dev/pts ./chroot/dev/pts
mount --make-slave ./chroot/dev/pts
mount -t tmpfs -o mode=1777 none ./chroot/dev/shm

cp ./update ./chroot/init
if [ -f ./chromeos_gentoo_prefix.tar.gz ]; then
	mkdir -p ./chroot/usr/local
	tar zxf ./chromeos_gentoo_prefix.tar.gz -C ./chroot/usr/local
	echo -e '#!/bin/bash\n\nbash' > ./chroot/init
fi

env -i PATH=/usr/sbin:/usr/bin:sbin:/bin chroot --userspec=1000:1000 ./chroot /init

for ROOT in $(find /proc/*/root 2>/dev/null); do
	LINK="$(readlink -f ${ROOT})"
	if echo "${LINK}" | grep -q $(realpath ./chroot); then
		PID=$(basename $(dirname "${ROOT}"))
		kill -STOP ${PID} 2>/dev/null
	fi
done
sleep 2
for ROOT in $(find /proc/*/root 2>/dev/null); do
	LINK="$(readlink -f ${ROOT})"
	if echo "${LINK}" | grep -q $(realpath ./chroot); then
		PID=$(basename $(dirname "${ROOT}"))
		kill -9 ${PID} 2>/dev/null
	fi
done
sleep 5

if mountpoint -q ./chroot/dev/shm; then umount ./chroot/dev/shm; fi
if mountpoint -q ./chroot/dev/pts; then umount ./chroot/dev/pts; fi
if mountpoint -q ./chroot/dev; then umount ./chroot/dev; fi
if mountpoint -q ./chroot/sys; then umount ./chroot/sys; fi
if mountpoint -q ./chroot/proc; then umount ./chroot/proc; fi

if [ -f ./chroot/usr/local/.finished ]; then
	rm -f ./chroot/usr/local/.finished ./chromeos_gentoo_prefix.tar.gz ./chromeos_gentoo_prefix_"$(date +"%Y%m%d")".tar.gz
	tar zcf ./chromeos_gentoo_prefix_"$(date +"%Y%m%d")".tar.gz -C ./chroot/usr/local .
	ln -s ./chromeos_gentoo_prefix_"$(date +"%Y%m%d")".tar.gz ./chromeos_gentoo_prefix.tar.gz
	chown ${SUDO_UID}:$(id -g ${SUDO_UID}) ./chromeos_gentoo_prefix.tar.gz ./chromeos_gentoo_prefix_"$(date +"%Y%m%d")".tar.gz
fi

