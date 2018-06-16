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
# Monkey Island 3: The Curse of Monkey Island
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180401.1

# Set game-specific variables

GAME_ID='monkey-island-3'
GAME_NAME='Monkey Island 3: The Curse of Monkey Island'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_the_curse_of_monkey_island_1.0_(18253).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_curse_of_monkey_island'
ARCHIVE_GOG_MD5='20c74e5f60bd724182ec2bdbae6d9a49'
ARCHIVE_GOG_SIZE='1200000'
ARCHIVE_GOG_VERSION='1.0-gog18253'
ARCHIVE_GOG_TYPE='innosetup'

ARCHIVE_DOC_MAIN_PATH='app'
ARCHIVE_DOC_MAIN_FILES='./*.pdf'

ARCHIVE_GAME0_MAIN_PATH='app'
ARCHIVE_GAME0_MAIN_FILES='./comi.la0 ./comi.la1 ./comi.la2 ./resource ./saves ./goggame-1528148981.ico'

ARCHIVE_GAME1_MAIN_PATH='app/__support/app/'
ARCHIVE_GAME1_MAIN_FILES='monkey3.ini'

APP_MAIN_TYPE='scummvm'
APP_MAIN_SCUMMID='comi'
APP_MAIN_ICON='goggame-1528148981.ico'
APP_MAIN_ICON_RES='16 24 32 48 64 128'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_DEPS='scummvm'

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

extract_and_sort_icons_from 'APP_MAIN'

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
