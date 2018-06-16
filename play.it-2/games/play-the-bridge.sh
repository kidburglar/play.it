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
# The Bridge
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180415.1

# Set game-specific variables

GAME_ID='the-bridge'
GAME_NAME='The Bridge'

ARCHIVE_HUMBLE='TheBridgeLinux_1410196636.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/the-bridge'
ARCHIVE_HUMBLE_MD5='6d3f5e7ff8d10d47f04ffabb8b9a031e'
ARCHIVE_HUMBLE_VERSION='1.0-humble1'
ARCHIVE_HUMBLE_SIZE='310000'
ARCHIVE_HUMBLE_TYPE='zip'

ARCHIVE_GAME_BIN_PATH='TheBridgeLinux/TheBridge'
ARCHIVE_GAME_BIN_FILES='./TheBridge.x86 ./*_Data/*/x86'

ARCHIVE_GAME_DATA_PATH='TheBridgeLinux/TheBridge'
ARCHIVE_GAME_DATA_FILES='*_Data/PlayerConnectionConfigFile *_Data/mainData *_Data/Managed *_Data/Mono/etc *_Data/*.assets *_Data/ScreenSelector.pngi *_Data/Resources'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='TheBridge.x86'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='TheBridge_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID glu xcursor libxrandr"

# Load common functions

target_version='2.7'

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

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
