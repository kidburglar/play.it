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
# A Boy and His Blob
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='a-boy-and-his-blob'
GAME_NAME='A Boy and His Blob'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_a_boy_and_his_blob_2.1.0.2.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/a_boy_and_his_blob'
ARCHIVE_GOG_MD5='7025963a3a26f838877374f72ce3760d'
ARCHIVE_GOG_SIZE='1300000'
ARCHIVE_GOG_VERSION='20160421-gog2.1.0.2'

ARCHIVE_ICONS_PACK='a-boy-and-his-blob_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='2a555c1f6b02a45b8932c8e72a9c1dd6'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./Blob ./lib*.so.*'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./content'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./32x32 ./48x48 ./64x64'

APP_MAIN_TYPE='native'
APP_MAIN_LIBS='.'
APP_MAIN_EXE='Blob'
APP_MAIN_ICON_GOG='data/noarch/support/icon.png'
APP_MAIN_ICON_GOG_RES='256'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, libc6, libstdc++6, libsdl2-2.0-0, libgl1 | libgl1-mesa-glx"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID sdl2 libgl glew1.10"

# Load common functions

target_version='2.5'

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

# Try to load icons archive

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_ICONS' 'ARCHIVE_ICONS_PACK'
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
if [ "$ARCHIVE_ICONS" ]; then
	(
		ARCHIVE='ARCHIVE_ICONS'
		extract_data_from "$ARCHIVE_ICONS"
	)
fi

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC'       "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	organize_data 'ICONS' "$PATH_ICON_BASE"
else
	get_icon_from_temp_dir 'APP_MAIN'
fi

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
