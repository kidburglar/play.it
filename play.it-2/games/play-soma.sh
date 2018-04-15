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
# SOMA
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180415.2

# Set game-specific variables

GAME_ID='soma'
GAME_NAME='SOMA'

ARCHIVE_HUMBLE='SOMA_Humble_Linux_1109.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/soma'
ARCHIVE_HUMBLE_MD5='63f4c611fed4df25bee3fb89177ab57f'
ARCHIVE_HUMBLE_VERSION='1109-humble1'
ARCHIVE_HUMBLE_SIZE='22000000'
ARCHIVE_HUMBLE_TYPE='zip'

ARCHIVE_DOC_DATA_PATH='Linux'
ARCHIVE_DOC_DATA_FILES='./README.linux'

ARCHIVE_GAME_BIN_PATH='Linux'
ARCHIVE_GAME_BIN_FILES='./Soma.bin.x86_64 ./lib64'

ARCHIVE_GAME_DATA_PATH='Linux'
ARCHIVE_GAME_DATA_FILES='./billboards ./combos ./config ./core ./detail_meshes ./fonts ./graphics ./gui ./hps_api.hps ./hps_syntax.xml ./hps.xml ./Icon.bmp ./lang ./lights ./MainEditorSettings.cfg ./maps ./materials.cfg ./music ./particles ./resources.cfg ./script ./_shadersource ./_shadersource ./static_objects ./_supersecret.rar ./terminals ./textures ./undergrowth'

ARCHIVE_GAME_ENTITIES_PATH='Linux'
ARCHIVE_GAME_ENTITIES_FILES='./entities'

ARCHIVE_GAME_SOUNDS_PATH='Linux'
ARCHIVE_GAME_SOUNDS_FILES='./sounds'

CONFIG_FILES='./*.cfg'
CONFIG_DIRS='./config'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='Soma.bin.x86_64'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='./Icon.bmp'
APP_MAIN_ICON_RES='96'

PACKAGES_LIST='PKG_BIN PKG_DATA PKG_ENTITIES PKG_SOUNDS'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_ENTITIES_ID="${GAME_ID}-entities"
PKG_ENTITIES_DESCRIPTION='entities'

PKG_SOUNDS_ID="${GAME_ID}-sounds"
PKG_SOUNDS_DESCRIPTION='sounds'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS="$PKG_DATA_ID $PKG_ENTITIES_ID $PKG_SOUNDS_ID glu sdl2"

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
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout

PKG='PKG_DATA'
extract_and_sort_icons_from 'APP_MAIN'

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
