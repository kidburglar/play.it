#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2016, Antoine Le Gonidec
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
# Psychonauts
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

SCRIPT_DEPS='convert'

GAME_ID='psychonauts'
GAME_NAME='Psychonauts'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_psychonauts_2.0.0.4.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/psychonauts'
ARCHIVE_GOG_MD5='7fc85f71494ff5d37940e9971c0b0c55'
ARCHIVE_GOG_SIZE='5200000'
ARCHIVE_GOG_VERSION='1.04-gog2.0.0.4'
ARCHIVE_GOG_TYPE='mojosetup_unzip'

ARCHIVE_DOC1_PATH='data/noarch/docs'
ARCHIVE_DOC1_FILES='./*'

ARCHIVE_DOC2_PATH='data/noarch/game/Documents'
ARCHIVE_DOC2_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./Psychonauts ./lib*.so.* ./*.ini'

ARCHIVE_GAME_SOUNDS_PATH='data/noarch/game'
ARCHIVE_GAME_SOUNDS_FILES='./WorkResource/Sounds'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./icon.bmp ./PsychonautsData2.pkg ./psychonauts.png ./WorkResource'

CONFIG_FILES='./DisplaySettings.ini ./psychonauts.ini'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='Psychonauts'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON1'
APP_MAIN_ICON1='psychonauts.png'
APP_MAIN_ICON1_RES='512'
APP_MAIN_ICON2='icon.bmp'
APP_MAIN_ICON2_RES='64'

PACKAGES_LIST='PKG_SOUNDS PKG_DATA PKG_BIN'

PKG_SOUNDS_ID="${GAME_ID}-sounds"
PKG_SOUNDS_DESCRIPTION='sounds'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_SOUNDS_ID, $PKG_DATA_ID, libc6, libstdc++6, libgl1-mesa-glx | libgl1"
PKG_BIN_DEPS_ARCH="$PKG_SOUNDS_ID $PKG_DATA_ID lib32-glibc lib32-gcc-libs lib32-libgl"

# Load common functions

target_version='2.1'

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

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_SOUNDS'
organize_data 'GAME_SOUNDS' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC1'      "$PATH_DOC"
organize_data 'DOC2'      "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

res="$APP_MAIN_ICON2_RES"
PATH_ICON="$PATH_ICON_BASE/${res}x${res}/apps"
extract_icon_from "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON2"
mkdir --parents "${PKG_DATA_PATH}${PATH_ICON}"
mv "$PLAYIT_WORKDIR/icons/${APP_MAIN_ICON2%.bmp}.png" "${PKG_DATA_PATH}${PATH_ICON}/$GAME_ID.png"

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
