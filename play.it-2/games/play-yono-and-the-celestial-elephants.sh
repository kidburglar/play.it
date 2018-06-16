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
# Yono and the Celestial Elephants
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180321.2

# Set game-specific variables

GAME_ID='yono-and-the-celestial-elephants'
GAME_NAME='Yono and the Celestial Elephants'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_yono_and_the_celestial_elephants_01.01_(15299).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/yono_and_the_celestial_elephants'
ARCHIVE_GOG_MD5='c16fddaa24eded544fb9ee42d5b4e2a2'
ARCHIVE_GOG_SIZE='1200000'
ARCHIVE_GOG_VERSION='01.01-gog15299'
ARCHIVE_GOG_TYPE='innosetup'

DATA_DIRS='./logs'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./yono?and?the?celestial?elephants.exe *_data/mono *_data/plugins *_data/managed'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='*_data/resources *_data/level* *_data/resources.assets.ress *_data/globalgamemanagers *_data/*.assets *_data/sharedassets* *_data/gi *_data/screenselector.bmp *_data/streamingassets ./player_win_x86.pdb ./player_win_x86_s.pdb'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='yono and the celestial elephants.exe'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log -force-d3d9'
APP_MAIN_ICON='yono and the celestial elephants.exe'
APP_MAIN_ICON_RES='16 24 32 48 64 96 128 192 256'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine"

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

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "${PLAYIT_WORKDIR}"

# Print instructions

print_instructions

exit 0
