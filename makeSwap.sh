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
