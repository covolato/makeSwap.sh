#!/bin/sh
######################################################
# Shell script to create swap file, if not exist.
# If not, create swap of the same RAM size (Default).
#
# if you want a different size of the RAM size,
# especify it in bytes at command line as $1,
# example for 4Gb (1024 * 1024 * 4 = 4194304):
# $ makeSwap.sh 4194304
# Tip: To translate 4Gb in bytes try "echo $((1024 * 1024 * 4))"
#
# This script is not full tested, Use at your own risk.
#
# Autor: julio@psi.com.br
# $Date: Qui Abr 12 16:23:20 BRT 2018
# Licence: GPL2
######################################################
if free | awk '/^Swap:/ {exit !$2}'; then
        SWAP=$(free -m | awk '/^Swap:/ {print $2}')
        echo "Server already has swap of $SWAP Mb"
        cat /proc/swaps
else
        if [ -z $1 ]; then
                MEM=$(free | awk '/^Mem:/ {print $2}')
        else
                MEM=$1
        fi
        echo "No swap, creating swap file of $MEM bytes"
        if [ -f /swapfile ]; then
                echo "File /swapfile exist, exiting!"
                exit 1
        fi
        # fallocate command is much faster then dd!
        if type fallocate >/dev/null 2>&1; then
                fallocate -l $MEM /swapfile
        else
                dd if=/dev/zero of=/swapfile bs=1024 count=$MEM
        fi
        chmod 0600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        # test if fstab ends with blank line
        if [ -z $(tail -c 1 /etc/fstab) ]; then
                echo "/swapfile none swap defaults 0 0" >> /etc/fstab
        else
                echo "" >> /etc/fstab
                echo "/swapfile none swap defaults 0 0" >> /etc/fstab
        fi
        # Test swap activation
        echo "##################################################################"
        echo " Test swap activation :"
        free -m
        echo "##################################################################"
        cat /proc/swaps
        echo "##################################################################"
fi
