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
# Shadowrun: Hong Kong
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180227.1

# Set game-specific variables

GAME_ID='shadowrun-hong-kong'
GAME_NAME='Shadowrun: Hong Kong'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_shadowrun_hong_kong_extended_edition_2.8.0.11.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/shadowrun_hong_kong_extended_edition'
ARCHIVE_GOG_MD5='643ba68e47c309d391a6482f838e46af'
ARCHIVE_GOG_SIZE='12000000'
ARCHIVE_GOG_VERSION='3.1.2-gog2.8.0.11'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./ShadowrunEditor ./SRHK ./SRHK_Data/Mono ./SRHK_Data/Plugins'

ARCHIVE_GAME_DATA_BERLIN_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_BERLIN_FILES='./SRHK_Data/StreamingAssets/standalone/berlin'

ARCHIVE_GAME_DATA_HONGKONG_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_HONGKONG_FILES='./SRHK_Data/StreamingAssets/standalone/hongkong'

ARCHIVE_GAME_DATA_SEATTLE_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_SEATTLE_FILES='./SRHK_Data/StreamingAssets/standalone/seattle'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./dictionary ./SRHK_Data'

DATA_DIRS='./DumpBox ./logs'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='SRHK'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='./SRHK_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_DATA_BERLIN PKG_DATA_HONGKONG PKG_DATA_SEATTLE PKG_DATA PKG_BIN'

PKG_DATA_BERLIN_ID="${GAME_ID}-data-berlin"
PKG_DATA_BERLIN_DESCRIPTION='data - Berlin'

PKG_DATA_HONGKONG_ID="${GAME_ID}-data-hongkong"
PKG_DATA_HONGKONG_DESCRIPTION='data - Hong Kong'

PKG_DATA_SEATTLE_ID="${GAME_ID}-data-seattle"
PKG_DATA_SEATTLE_DESCRIPTION='data - Seattle'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_BERLIN $PKG_DATA_HONGKONG $PKG_DATA_SEATTLE $PKG_DATA_ID glu xcursor libxrandr alsa"

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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"
chmod +x "${PKG_BIN_PATH}${PATH_GAME}/ShadowrunEditor"

PKG='PKG_DATA_BERLIN'
organize_data 'GAME_DATA_BERLIN' "$PATH_GAME"

PKG='PKG_DATA_HONGKONG'
organize_data 'GAME_DATA_HONGKONG' "$PATH_GAME"

PKG='PKG_DATA_SEATTLE'
organize_data 'GAME_DATA_SEATTLE' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC'       "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_DATA_BERLIN' 'PKG_DATA_SEATTLE' 'PKG_DATA_HONGKONG' 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
