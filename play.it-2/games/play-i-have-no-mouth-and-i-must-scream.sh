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
# I Have No Mouth And I Must Scream
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

SCRIPT_DEPS_GOG_OLD='unar'

GAME_ID='i-have-no-mouth-and-i-must-scream'
GAME_NAME='I Have No Mouth And I Must Scream'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_EN_OLD ARCHIVE_GOG_FR ARCHIVE_GOG_FR_OLD'

ARCHIVE_GOG_EN='i_have_no_mouth_and_i_must_scream_en_1_0_17913.sh'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/i_have_no_mouth_and_i_must_scream'
ARCHIVE_GOG_EN_MD5='93640c6a4dc73f4ed2d40b210b95ba4c'
ARCHIVE_GOG_EN_SIZE='750000'
ARCHIVE_GOG_EN_VERSION='1.0-gog17913'
ARCHIVE_GOG_EN_TYPE='mojosetup'

ARCHIVE_GOG_EN_OLD='gog_i_have_no_mouth_and_i_must_scream_2.0.0.4.sh'
ARCHIVE_GOG_EN_OLD_MD5='be690cfa08a87b350c26cbfdde5de401'
ARCHIVE_GOG_EN_OLD_SIZE='780000'
ARCHIVE_GOG_EN_OLD_VERSION='1.0-gog2.0.0.4'

ARCHIVE_GOG_FR='i_have_no_mouth_and_i_must_scream_fr_1_0_17913.sh'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/i_have_no_mouth_and_i_must_scream'
ARCHIVE_GOG_FR_MD5='9124d7ccef36d4bb01dfae4d97cfbdea'
ARCHIVE_GOG_FR_SIZE='570000'
ARCHIVE_GOG_FR_VERSION='1.0-gog17913'
ARCHIVE_GOG_FR_TYPE='mojosetup'

ARCHIVE_GOG_FR_OLD='gog_i_have_no_mouth_and_i_must_scream_french_2.0.0.4.sh'
ARCHIVE_GOG_FR_OLD_MD5='e59029d2736ffa2859d73d56899055ee'
ARCHIVE_GOG_FR_OLD_SIZE='500000'
ARCHIVE_GOG_FR_OLD_VERSION='1.0-gog2.0.0.4'

ARCHIVE_DOC1_MAIN_PATH='data/noarch/docs'
ARCHIVE_DOC1_MAIN_FILES='./*.pdf ./*.txt'

ARCHIVE_DOC2_MAIN_PATH='data/noarch/data/scream'
ARCHIVE_DOC2_MAIN_FILES='./readme.txt'

ARCHIVE_GAME_MAIN_PATH='data/noarch/data'
ARCHIVE_GAME_MAIN_PATH_GOG_EN_OLD='.'
ARCHIVE_GAME_MAIN_PATH_GOG_FR_OLD='.'
ARCHIVE_GAME_MAIN_FILES='./*.res ./*.re_'

APP_MAIN_TYPE='scummvm'
APP_MAIN_SCUMMID='saga'
APP_MAIN_ICON='data/noarch/support/icon.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_ID="$GAME_ID"
PKG_MAIN_ID_GOG_EN="${GAME_ID}-en"
PKG_MAIN_ID_GOG_FR="${GAME_ID}-fr"
PKG_MAIN_PROVIDE="$PKG_MAIN_ID"
PKG_MAIN_DEPS='scummvm'

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

# Check dependencies

if [ "$ARCHIVE" = 'ARCHIVE_GOG_EN_OLD' ] || [ "$ARCHIVE" = 'ARCHIVE_GOG_FR_OLD' ]; then
	SCRIPT_DEPS="$SCRIPT_DEPS $SCRIPT_DEPS_GOG_OLD"
	check_deps
fi

# Extract data from game

extract_data_from "$SOURCE_ARCHIVE"
if [ "$ARCHIVE" = 'ARCHIVE_GOG_EN_OLD' ] || [ "$ARCHIVE" = 'ARCHIVE_GOG_FR_OLD' ]; then
	rm --force --recursive "$PLAYIT_WORKDIR/gamedata/data/noarch/dosbox"
	eval ${ARCHIVE}_TYPE='rar'
	extract_data_from "$PLAYIT_WORKDIR/gamedata/data/noarch/data/NoMouth.dat"
fi
tolower "$PLAYIT_WORKDIR/gamedata"

organize_data 'DOC1_MAIN' "$PATH_DOC"
organize_data 'DOC2_MAIN' "$PATH_DOC"
organize_data 'GAME_MAIN' "$PATH_GAME"
get_icon_from_temp_dir 'APP_MAIN'

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
