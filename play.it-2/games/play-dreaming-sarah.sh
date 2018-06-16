#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2018, Antoine Le Gonidec
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# This software is provided by the copyright holders and contributors "as is"
# and any express or implied warranties, including, but not limited to, the
# implied warranties of merchantability and fitness for a particular purpose
# are disclaimed. In no event shall the copyright holder or contributors be
# liable for any direct, indirect, incidental, special, exemplary, or
# consequential damages (including, but not limited to, procurement of
# substitute goods or services; loss of use, data, or profits; or business
# interruption) however caused and on any theory of liability, whether in
# contract, strict liability, or tort (including negligence or otherwise)
# arising in any way out of the use of this software, even if advised of the
# possibility of such damage.
###

###
# Dreaming Sarah
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180310.2

# Set game-specific variables

GAME_ID='dreaming-sarah'
GAME_NAME='Dreaming Sarah'

ARCHIVES_LIST='ARCHIVE_HUMBLE_32 ARCHIVE_HUMBLE_64'

ARCHIVE_HUMBLE_32='DreamingSarah-linux32_1.3.zip'
ARCHIVE_HUMBLE_32_URL='https://www.humblebundle.com/store/dreaming-sarah'
ARCHIVE_HUMBLE_32_MD5='73682a545e979ad9a2b6123222ddb517'
ARCHIVE_HUMBLE_32_SIZE='200000'
ARCHIVE_HUMBLE_32_VERSION='1.3-humble1'

ARCHIVE_HUMBLE_64='DreamingSarah-linux64_1.3.zip'
ARCHIVE_HUMBLE_64_URL='https://www.humblebundle.com/store/dreaming-sarah'
ARCHIVE_HUMBLE_64_MD5='a68f3956eb09ea7b34caa20f6e89b60c'
ARCHIVE_HUMBLE_64_SIZE='200000'
ARCHIVE_HUMBLE_64_VERSION='1.3-humble1'

ARCHIVE_GAME_BIN_PATH_HUMBLE_32='DreamingSarah-linux32'
ARCHIVE_GAME_BIN_PATH_HUMBLE_64='DreamingSarah-linux64'
ARCHIVE_GAME_BIN_FILES='./lib ./nacl_helper ./nacl_helper_bootstrap ./nw'

ARCHIVE_GAME_DATA_PATH_HUMBLE_32='DreamingSarah-linux32'
ARCHIVE_GAME_DATA_PATH_HUMBLE_64='DreamingSarah-linux64'
ARCHIVE_GAME_DATA_FILES='./icudtl.dat ./locales ./natives_blob.bin ./nw_100_percent.pak ./nw_200_percent.pak ./package.nw ./resources.pak'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='nw'
APP_MAIN_LIB='lib'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH_HUMBLE_32='32'
PKG_BIN_ARCH_HUMBLE_64='64'
PKG_BIN_DEPS="$PKG_DATA_ID glibc libstdc++ libxrandr xcursor nss gconf gtk2"

# Load common functions

target_version='2.6'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	if [ -e "$XDG_DATA_HOME/play.it/play.it-2/lib/libplayit2.sh" ]; then
		PLAYIT_LIB2="$XDG_DATA_HOME/play.it/play.it-2/lib/libplayit2.sh"
	elif [ -e './libplayit2.sh' ]; then
		PLAYIT_LIB2='./libplayit2.sh'
	else
		printf '\n\033[1;31mError:\033[0m\n'
		printf 'libplayit2.sh not found.\n'
		exit 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
