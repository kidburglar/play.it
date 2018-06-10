#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2018, Antoine Le Gonidec
# Copyright (c) 2018, Solène Huault
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
# D: The Game
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180610.1

# Set game-specific variables

GAME_ID='d-the-game'
GAME_NAME='D: The Game'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_d_the_game_2.0.0.2.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/d_the_game'
ARCHIVE_GOG_MD5='4a9f18efc065a80723130b73c5327095'
ARCHIVE_GOG_SIZE='930000'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.2'

DATA_DIRS='./data'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*.txt'

ARCHIVE_GAME_BIN_PATH='data/noarch/data'
ARCHIVE_GAME_BIN_FILES='./*.EXE ./DS.DAT'

ARCHIVE_GAME_DATA_PATH='data/noarch/data'
ARCHIVE_GAME_DATA_FILES='./AVI ./BMP ./DRV ./EFC ./LAURA.PIF ./SOUND.BAT ./VESA.AVI'

GAME_IMAGE='DS.DAT'

APP_MAIN_TYPE='dosbox'
APP_MAIN_EXE='LAURA.EXE'
APP_MAIN_ICON='data/noarch/support/icon.png'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID dosbox"

# Load common functions

target_version='2.8'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	for path in\
		'./'\
		"$XDG_DATA_HOME/play.it/"\
		"$XDG_DATA_HOME/play.it/play.it-2/lib/"\
		'/usr/local/share/games/play.it/'\
		'/usr/local/share/play.it/'\
		'/usr/share/games/play.it/'\
		'/usr/share/play.it/'
	do
		if [ -z "$PLAYIT_LIB2" ] && [ -e "$path/libplayit2.sh" ]; then
			PLAYIT_LIB2="$path/libplayit2.sh"
			break
		fi
	done
	if [ -z "$PLAYIT_LIB2" ]; then
		printf '\n\033[1;31mError:\033[0m\n'
		printf 'libplayit2.sh not found.\n'
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout

# Extract icon

PKG='PKG_DATA'
get_icon_from_temp_dir 'APP_MAIN'

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
