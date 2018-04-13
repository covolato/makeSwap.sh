# makeSwap.sh
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
