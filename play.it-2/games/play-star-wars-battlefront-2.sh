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
# Star Wars Battlefront II
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='star-wars-battlefront-2'
GAME_NAME='Star Wars Battlefront II'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_sw_battlefront2_2.0.0.5.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/star_wars_battlefront_ii'
ARCHIVE_GOG_MD5='51284c8a8e777868219e811ada284fb1'
ARCHIVE_GOG_VERSION='1.1-gog2.0.0.5'
ARCHIVE_GOG_SIZE='9100000'
ARCHIVE_GOG_TYPE='rar'
ARCHIVE_GOG_GOGID='1421404701'
ARCHIVE_GOG_PART1='setup_sw_battlefront2_2.0.0.5-1.bin'
ARCHIVE_GOG_PART1_MD5='dc36b03c9c43fb8d3cb9b92c947daaa4'
ARCHIVE_GOG_PART1_TYPE='rar'
ARCHIVE_GOG_PART2='setup_sw_battlefront2_2.0.0.5-2.bin'
ARCHIVE_GOG_PART2_MD5='5d4000fd480a80b6e7c7b73c5a745368'
ARCHIVE_GOG_PART2_TYPE='rar'

ARCHIVE_DOC_DATA_PATH='game'
ARCHIVE_DOC_DATA_FILES='./*.pdf'

ARCHIVE_GAME_BIN_PATH='game/gamedata'
ARCHIVE_GAME_BIN_FILES='./*.exe ./binkw32.dll ./eax.dll ./unicows.dll'

ARCHIVE_GAME_MOVIES_PATH='game/gamedata'
ARCHIVE_GAME_MOVIES_FILES='./data/_lvl_pc/movies'

ARCHIVE_GAME_DATA_PATH='game/gamedata'
ARCHIVE_GAME_DATA_FILES='./data/_lvl_pc/*.def ./data/_lvl_pc/*.lvl ./data/_lvl_pc/bes ./data/_lvl_pc/common ./data/_lvl_pc/cor ./data/_lvl_pc/dag ./data/_lvl_pc/dea ./data/_lvl_pc/end ./data/_lvl_pc/fel ./data/_lvl_pc/fpm ./data/_lvl_pc/gal ./data/_lvl_pc/geo ./data/_lvl_pc/hot ./data/_lvl_pc/kam ./data/_lvl_pc/kas ./data/_lvl_pc/kor ./data/_lvl_pc/load ./data/_lvl_pc/mus ./data/_lvl_pc/myg ./data/_lvl_pc/nab ./data/_lvl_pc/pol ./data/_lvl_pc/rhn ./data/_lvl_pc/shell ./data/_lvl_pc/side ./data/_lvl_pc/sound ./data/_lvl_pc/spa ./data/_lvl_pc/tan ./data/_lvl_pc/tat ./data/_lvl_pc/test ./data/_lvl_pc/uta ./data/_lvl_pc/yav'

DATA_DIRS='./savegames'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='battlefrontii.exe'
APP_MAIN_ICON='battlefrontii.exe'
APP_MAIN_ICON_RES='16 32'

PACKAGES_LIST='PKG_MOVIES PKG_DATA PKG_BIN'

PKG_MOVIES_ID="${GAME_ID}-movies"
PKG_MOVIES_DESCRIPTION='movies'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_MOVIES_ID $PKG_DATA_ID wine"
PKG_BIN_DEPS_DEB='libtxc-dxtn-s2tc | libtxc-dxtn-s2tc0 | libtxc-dxtn0 | libtxc-dxtn'
PKG_BIN_DEPS_ARCH='lib32-libtxc_dxtn'

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

# Check that all parts of the installer are present

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_PART1' "${ARCHIVE_MAIN}_PART1"
[ "$ARCHIVE_PART1" ] || set_archive_error_not_found "${ARCHIVE_MAIN}_PART1"
set_archive 'ARCHIVE_PART2' "${ARCHIVE_MAIN}_PART2"
[ "$ARCHIVE_PART2" ] || set_archive_error_not_found "${ARCHIVE_MAIN}_PART2"
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

ln --symbolic "$(readlink --canonicalize "$ARCHIVE_PART1")" "$PLAYIT_WORKDIR/$GAME_ID.r00"
ln --symbolic "$(readlink --canonicalize "$ARCHIVE_PART2")" "$PLAYIT_WORKDIR/$GAME_ID.r01"
extract_data_from "$PLAYIT_WORKDIR/$GAME_ID.r00"
tolower "$PLAYIT_WORKDIR/gamedata"

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

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
