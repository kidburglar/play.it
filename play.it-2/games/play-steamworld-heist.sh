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
# Steamworld Heist
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='steamworld-heist'
GAME_NAME='Steamworld Heist'

ARCHIVES_LIST='ARCHIVE_HUMBLE'

ARCHIVE_HUMBLE='SteamWorldHeist.tar.gz'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/steamworld-heist'
ARCHIVE_HUMBLE_MD5='79a499459c09d7881efeb95be7abc559'
ARCHIVE_HUMBLE_VERSION='1.0-humble1'
ARCHIVE_HUMBLE_SIZE='200000'

ARCHIVE_DOC_PATH='SteamWorldHeist'
ARCHIVE_DOC_FILES='./*.txt ./Licenses'

ARCHIVE_GAME_BIN_PATH='SteamWorldHeist'
ARCHIVE_GAME_BIN_FILES='./Heist'

ARCHIVE_GAME_DATA_PATH='SteamWorldHeist'
ARCHIVE_GAME_DATA_FILES='./Bundle ./icon.png ./icon.bmp'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='Heist'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON APP_MAIN_ICON_BMP'
APP_MAIN_ICON='icon.png'
APP_MAIN_ICON_BMP='icon.bmp'
APP_MAIN_ICON_RES='48'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID libstdc++ glx"

# Load common functions

target_version='2.3'

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
set_standard_permissions "$PLAYIT_WORKDIR/gamedata"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
