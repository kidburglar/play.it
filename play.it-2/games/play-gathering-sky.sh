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
# Gathring Sky
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180506.1

# Set game-specific variables

GAME_ID='gathering-sky'
GAME_NAME='Gathering Sky'

ARCHIVES_LIST='ARCHIVE_HUMBLE'

ARCHIVE_HUMBLE='GatheringSky_Linux_64bit.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/gathering-sky'
ARCHIVE_HUMBLE_MD5='c590edce835070a1ac2ae47ac620dc48'
ARCHIVE_HUMBLE_SIZE='1200000'
ARCHIVE_HUMBLE_VERSION='1.0-humble1'
ARCHIVE_HUMBLE_TYPE='zip_unclean'

ARCHIVE_DOC_DATA_PATH='packr/linux/GatheringSky'
ARCHIVE_DOC_DATA_FILES='jre/ASSEMBLY_EXCEPTION jre/LICENSE jre/THIRD_PARTY_README'

ARCHIVE_GAME_BIN_PATH='packr/linux/GatheringSky'
ARCHIVE_GAME_BIN_FILES='./config.json ./desktop-0.1.jar ./GatheringSky'

ARCHIVE_GAME_DATA_PATH='packr/linux/GatheringSky'
ARCHIVE_GAME_DATA_FILES='./jre/lib'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='GatheringSky'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS="$PKG_DATA_ID glibc"

# Load common functions

target_version='2.8'

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

ARCHIVE_HUMBLE_TYPE='tar.gz'
extract_data_from "$PLAYIT_WORKDIR/gamedata/GatheringSky.tar.gz"
rm "$PLAYIT_WORKDIR/gamedata/GatheringSky.tar.gz"

set_standard_permissions "$PLAYIT_WORKDIR/gamedata"

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
