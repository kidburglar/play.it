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
# Darkest Dungeon: The Crimson Court
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180621.1

# Set game-specific variables

# copy GAME_ID from play-darkest-dungeon.sh
GAME_ID='darkest-dungeon'
GAME_NAME='Darkest Dungeon: The Crimson Court'

ARCHIVE_GOG='darkest_dungeon_the_crimson_court_dlc_en_23885_21662.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/darkest_dungeon_the_crimson_court'
ARCHIVE_GOG_MD5='70018fc475ee4d24fdc19e107fa41a2a'
ARCHIVE_GOG_SIZE='350000'
ARCHIVE_GOG_VERSION='23885-gog21662'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='darkest_dungeon_the_crimson_court_dlc_en_21096_16065.sh'
ARCHIVE_GOG_OLD_MD5='d4beaeb7effff0cbd2e292abf0ef5332'
ARCHIVE_GOG_OLD_SIZE='350000'
ARCHIVE_GOG_OLD_VERSION='21096-gog16066'
ARCHIVE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_OLDER='darkest_dungeon_the_crimson_court_dlc_en_21071_15970.sh'
ARCHIVE_GOG_OLDER_MD5='67fcfc5e91763cbf20a4ef51ff7b8eff'
ARCHIVE_GOG_OLDER_SIZE='350000'
ARCHIVE_GOG_OLDER_VERSION='21071-gog15970'
ARCHIVE_GOG_OLDER_TYPE='mojosetup'

ARCHIVE_GOG_OLDEST='darkest_dungeon_the_crimson_court_dlc_en_20645_15279.sh'
ARCHIVE_GOG_OLDEST_MD5='523c66d4575095c66a03d3859e4f83b8'
ARCHIVE_GOG_OLDEST_SIZE='360000'
ARCHIVE_GOG_OLDEST_VERSION='20645-gog15279'
ARCHIVE_GOG_OLDEST_TYPE='mojosetup'

ARCHIVE_DOC_MAIN_PATH='data/noarch/docs'
ARCHIVE_DOC_MAIN_FILES='./*'

ARCHIVE_GAME_MAIN_PATH='data/noarch/game'
ARCHIVE_GAME_MAIN_FILES='./dlc'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_ID="${GAME_ID}-the-crimson-court"
PKG_MAIN_DEPS="$GAME_ID"

# Load common functions

target_version='2.9'

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
		exit 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
