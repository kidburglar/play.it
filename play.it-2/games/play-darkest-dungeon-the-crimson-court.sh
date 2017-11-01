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
# Darkest Dungeon: The Crimson Court
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20171101.1

# Set game-specific variables

# copy GAME_ID from play-darkest-dungeon.sh
GAME_ID='darkest-dungeon'
GAME_NAME='Darkest Dungeon: The Crimson Court'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST'

ARCHIVE_GOG='darkest_dungeon_the_crimson_court_dlc_en_21096_16065.sh'
ARCHIVE_GOG_MD5='d4beaeb7effff0cbd2e292abf0ef5332'
ARCHIVE_GOG_SIZE='350000'
ARCHIVE_GOG_VERSION='21096-gog16066'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='darkest_dungeon_the_crimson_court_dlc_en_21071_15970.sh'
ARCHIVE_GOG_OLD_MD5='67fcfc5e91763cbf20a4ef51ff7b8eff'
ARCHIVE_GOG_OLD_SIZE='350000'
ARCHIVE_GOG_OLD_VERSION='21071-gog15970'
ARCHIVE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_OLDER='darkest_dungeon_the_crimson_court_dlc_en_20645_15279.sh'
ARCHIVE_GOG_OLDER_MD5='523c66d4575095c66a03d3859e4f83b8'
ARCHIVE_GOG_OLDER_SIZE='360000'
ARCHIVE_GOG_OLDER_VERSION='20645-gog15279'
ARCHIVE_GOG_OLDER_TYPE='mojosetup'

ARCHIVE_GOG_OLDEST='darkest_dungeon_the_crimson_court_dlc_en_20578_15132.sh'
ARCHIVE_GOG_OLDEST_MD5='96ac3ed631dd2509ffbf88f88823e019'
ARCHIVE_GOG_OLDEST_SIZE='360000'
ARCHIVE_GOG_OLDEST_VERSION='20578-gog15132'
ARCHIVE_GOG_OLDEST_TYPE='mojosetup'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_PATH='data/noarch/game'
ARCHIVE_GAME_FILES='./dlc'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_ID="${GAME_ID}-the-crimson-court"
PKG_MAIN_DEPS="$GAME_ID"

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
