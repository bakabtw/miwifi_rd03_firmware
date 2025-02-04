#!/bin/sh

FAIL_ACTION=$1
IMAGE_PATH=$2

# in RA80 and RA81, this is a stub function
secboot_upgd_sign_check() {
    return 0
}

[ -f /lib/upgrade/secboot_img_check.sh ] && {
    . /lib/upgrade/secboot_img_check.sh
}

# $FAIL_ACTION: "fail_return" or "fail_reboot"
# $IMAGE_PATH: /tmp/custom.bin
secboot_upgd_sign_check $FAIL_ACTION $IMAGE_PATH
