#!/bin/bash

build_home_dir="/home/hawkinsw/"
flash_timestamp_file="$build_home_dir/timestamp"
flash_log_dir="$build_home_dir/logs/"
nodes="2 3 4 5 6 8"
node_tmp_dir="/tmp"

function need_flash {
	compare=$1
	
	if [ -z "$compare" ]; then
		return 0
	fi

	for i in `find builds -cnewer $compare -or -anewer $compare`; do
		return 1
	done
	return 0
}

function upload_image {
	node=$1
	image=$2

	if [ -z "$node" -o -z "$image" ]; then
		echo "Need node and image."
		return 0
	fi
	echo "node:" $node
	echo "image:" $image
	scp $image root@$node:/$node_tmp_dir/ >> "$ts_flash_log_dir"/"$node".log
}

function flash_image {
	node=$1
	image=$2

	image=`basename $image`
	if [ -z "$node" -o -z "$image" ]; then
		echo "Need node and image."
		return 0
	fi
	echo "node:" $node
	echo "image:" $image
	ssh root@$node -o ServerAliveInterval=5 -C "sysupgrade -n /$node_tmp_dir/$image" >> "$ts_flash_log_dir"/"$node".log &
}
function upload_images {
	base=$1
	nodes=$2
	image=$3
	
	for i in $nodes; do
		upload_image "192.168.1.$i" $image
	done
}

function flash_images {
	base=$1
	nodes=$2
	image=$3
	
	for i in $nodes; do
		flash_image "192.168.1.$i" $image
	done
}

need_flash $flash_timestamp_file
is_need_flash=$?
if [ $is_need_flash -eq 0 ]; then
	exit 0
fi

echo "Beginning flash process."

ts_flash_log_dir="$flash_log_dir"/`date "+%m%d%y%H%M%S"`
mkdir -p $ts_flash_log_dir

upload_images "192.168.1." "$nodes" "$build_home_dir/builds/openwrt-ar71xx-generic-ubnt-bullet-m-squashfs-sysupgrade.bin"
flash_images "192.168.1." "$nodes" "$build_home_dir/builds/openwrt-ar71xx-generic-ubnt-bullet-m-squashfs-sysupgrade.bin"

wait
touch $flash_timestamp_file

echo "Flash complete."
