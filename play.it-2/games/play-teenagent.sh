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
# Teenagent
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='teenagent'
GAME_NAME='Teenagent'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_teenagent_1.0_(15595).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/teenagent'
ARCHIVE_GOG_MD5='95126a8eba61b60e12535ebaa020c01b'
ARCHIVE_GOG_SIZE='32000'
ARCHIVE_GOG_VERSION='1.0-gog15595'

ARCHIVE_GAME_MAIN_PATH='app'
ARCHIVE_GAME_MAIN_FILES='./*.res ./goggame-1207658753.ico'

APP_MAIN_TYPE='scummvm'
APP_MAIN_SCUMMID='teenagent'
APP_MAIN_ICON='goggame-1207658753.ico'
APP_MAIN_ICON_RES='16 32 48 256'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_DEPS='scummvm'

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


# Extract data from game

extract_data_from "$SOURCE_ARCHIVE"
tolower "$PLAYIT_WORKDIR/gamedata"

organize_data 'GAME_MAIN' "$PATH_GAME"

extract_and_sort_icons_from 'APP_MAIN'
rm "$PKG_MAIN_PATH/$PATH_GAME/$APP_MAIN_ICON"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
