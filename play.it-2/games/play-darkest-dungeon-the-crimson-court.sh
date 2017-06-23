#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2017, Antoine Le Gonidec
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
# Darkest Dungeon
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20170715.1

# Set game-specific variables

# copy GAME_ID from play-darkest-dungeon.sh
GAME_ID='darkest-dungeon'
GAME_NAME='Darkest Dungeon: The Crimson Court'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST'

ARCHIVE_GOG='gog_darkest_dungeon_the_crimson_court_dlc_2.4.0.5.sh'
ARCHIVE_GOG_MD5='18acadcb1c9a2d4dc83198aaab44c1ca'
ARCHIVE_GOG_SIZE='360000'
ARCHIVE_GOG_VERSION='20326-gog2.4.0.5'

ARCHIVE_GOG_OLD='gog_darkest_dungeon_the_crimson_court_dlc_2.3.0.4.sh'
ARCHIVE_GOG_OLD_MD5='99eecd10296c6f60830f2b086981cb97'
ARCHIVE_GOG_OLD_SIZE='360000'
ARCHIVE_GOG_OLD_VERSION='20326-gog2.3.0.4'

ARCHIVE_GOG_OLDER='gog_darkest_dungeon_the_crimson_court_dlc_2.2.0.3.sh'
ARCHIVE_GOG_OLDER_MD5='492d4d231d9286587a065fb0bd30cd09'
ARCHIVE_GOG_OLDER_SIZE='360000'
ARCHIVE_GOG_OLDER_VERSION='20235-gog2.2.0.3'

ARCHIVE_GOG_OLDEST='gog_darkest_dungeon_the_crimson_court_dlc_2.1.0.2.sh'
ARCHIVE_GOG_OLDEST_MD5='a5f5b9011ed0b3fbf6c6b37a19cb2ce8'
ARCHIVE_GOG_OLDEST_SIZE='360000'
ARCHIVE_GOG_OLDEST_VERSION='20108-gog2.1.0.2'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_PATH='data/noarch/game'
ARCHIVE_GAME_FILES='./dlc'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_ID="${GAME_ID}-the-crimson-court"
PKG_MAIN_DEPS_DEB="$GAME_ID"
PKG_MAIN_DEPS_ARCH="$GAME_ID"

# Load common functions

target_version='2.0'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	if [ -e "$XDG_DATA_HOME/play.it/libplayit2.sh" ]; then
		PLAYIT_LIB2="$XDG_DATA_HOME/play.it/libplayit2.sh"
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

organize_data 'DOC'  "$PATH_DOC"
organize_data 'GAME' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
