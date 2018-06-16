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
# Pillars of Eternity: The White March Part II
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='pillars-of-eternity'
GAME_NAME='Pillars of Eternity: The White March Part II'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST'

ARCHIVE_GOG='pillars_of_eternity_white_march_part_2_dlc_en_3_07_0_1318_17464.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/pillars_of_eternity_the_white_march_part_2'
ARCHIVE_GOG_MD5='03067ebdd878cc16c283f63ddf015e90'
ARCHIVE_GOG_SIZE='4400000'
ARCHIVE_GOG_VERSION='3.7.0.1318-gog17464'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='pillars_of_eternity_white_march_part_2_dlc_en_3_07_16598.sh'
ARCHIVE_GOG_OLD_MD5='db3a345b2b2782e2ad075dd32567f303'
ARCHIVE_GOG_OLD_SIZE='4300000'
ARCHIVE_GOG_OLD_VERSION='3.7.0.1284-gog16598'
ARCHIVE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_OLDER='gog_pillars_of_eternity_white_march_part_2_dlc_2.6.0.7.sh'
ARCHIVE_GOG_OLDER_MD5='fdc1446661a358961379fbec24c44680'
ARCHIVE_GOG_OLDER_SIZE='4400000'
ARCHIVE_GOG_OLDER_VERSION='3.06.1254-gog2.6.0.7'

ARCHIVE_GOG_OLDEST='gog_pillars_of_eternity_white_march_part_2_dlc_2.5.0.6.sh'
ARCHIVE_GOG_OLDEST_MD5='483d4b8cc046a07ec91a6306d3409e23'
ARCHIVE_GOG_OLDEST_SIZE='4400000'
ARCHIVE_GOG_OLDEST_VERSION='3.05.1186-gog2.5.0.6'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_PATH='data/noarch/game'
ARCHIVE_GAME_FILES='./*'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_ID="${GAME_ID}-px2"
PKG_MAIN_DEPS="$GAME_ID ${GAME_ID}-px1"

# Load common functions

target_version='2.4'

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

rm "$PLAYIT_WORKDIR/gamedata/$ARCHIVE_GAME_PATH/PillarsOfEternity_Data/assetbundles/prefabs/objectbundle/px1_cre_blight_ice_terror.unity3d"

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
