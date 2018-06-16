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
# GHost Master
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='ghost-master'
GAME_NAME='Ghost Master'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD'

ARCHIVE_GOG='setup_ghost_master_20171020_(15806).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/ghost_master'
ARCHIVE_GOG_MD5='bbc7b8d6ed9b08c54cba6f2b1048a0fd'
ARCHIVE_GOG_SIZE='680000'
ARCHIVE_GOG_VERSION='1.1-gog15806'

ARCHIVE_GOG_OLD='setup_ghost_master_2.0.0.3.exe'
ARCHIVE_GOG_OLD_MD5='f581e0e08d7d9dfc89838c3ac892611a'
ARCHIVE_GOG_OLD_SIZE='650000'
ARCHIVE_GOG_OLD_VERSION='1.1-gog2.0.0.3'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./*.pdf ./*.txt'

ARCHIVE_GAME_BIN_PATH='app/ghostdata'
ARCHIVE_GAME_BIN_FILES='./*.cfg ./*.dll ./*.exe'

ARCHIVE_GAME_DATA_PATH='app/ghostdata'
ARCHIVE_GAME_DATA_FILES='./*.txt ./characters ./cursors ./fonts ./icons ./levels ./movies ./music ./new_animations ./otherobjects ./psparams ./pstextures ./scenarios ./screenshots ./scripts ./sound ./text ./ui ./voice'

CONFIG_FILES='./*.cfg'
DATA_DIRS='./screenshots'
DATA_FILES='./*.log'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='ghost.exe'
APP_MAIN_ICON='ghost.exe'
APP_MAIN_ICON_RES='16 32 48'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine"

# Load common functions

target_version='2.2'

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

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Store saved games outside of WINE prefix

for file in "${PKG_BIN_PATH}${PATH_BIN}"/*; do
	sed --in-place 's#cp --force --recursive --symbolic-link --update "$PATH_GAME"/\* "$PATH_PREFIX"#&\n\tmkdir --parents "$WINEPREFIX/drive_c/users/Public/Documents/Ghost Master/SaveGames/"\n\tmkdir --parents "$PATH_DATA/savegames"\n\tln --symbolic "$PATH_DATA/savegames" "$WINEPREFIX/drive_c/users/Public/Documents/Ghost Master/SaveGames/"#' "$file"
done

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
