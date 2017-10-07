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
# Star Wars Battlefront II
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20171010.2

# Set game-specific variables

GAME_ID='star-wars-battlefront-2'
GAME_NAME='Star Wars Battlefront II'

ARCHIVES_LIST='ARCHIVE_GOG_XPLAY ARCHIVE_GOG_SINGLE'

ARCHIVE_GOG_XPLAY='setup_star_wars_-_battlefront_2_1.1_xplay_(14073).exe'
ARCHIVE_GOG_XPLAY_MD5='5602e119f08628211283c6fbf3bc2f84'
ARCHIVE_GOG_XPLAY_VERSION='1.1-gog14073'
ARCHIVE_GOG_XPLAY_SIZE='11000000'
ARCHIVE_GOG_XPLAY_PART1='setup_star_wars_-_battlefront_2_1.1_xplay_(14073)-1.bin'
ARCHIVE_GOG_XPLAY_PART1_MD5='615579c044e8f61cd8c78bb3ff86971b'
ARCHIVE_GOG_XPLAY_PART1_TYPE='innosetup'
ARCHIVE_GOG_XPLAY_PART2='setup_star_wars_-_battlefront_2_1.1_xplay_(14073)-2.bin'
ARCHIVE_GOG_XPLAY_PART2_MD5='2927cc82d7fc130c6c6a5effc37a6f26'
ARCHIVE_GOG_XPLAY_PART2_TYPE='innosetup'

ARCHIVE_GOG_SINGLE='setup_sw_battlefront2_2.0.0.5.exe'
ARCHIVE_GOG_SINGLE_MD5='51284c8a8e777868219e811ada284fb1'
ARCHIVE_GOG_SINGLE_VERSION='1.1-gog2.0.0.5'
ARCHIVE_GOG_SINGLE_SIZE='9100000'
ARCHIVE_GOG_SINGLE_TYPE='rar'
ARCHIVE_GOG_SINGLE_GOGID='1421404701'
ARCHIVE_GOG_SINGLE_PART1='setup_sw_battlefront2_2.0.0.5-1.bin'
ARCHIVE_GOG_SINGLE_PART1_MD5='dc36b03c9c43fb8d3cb9b92c947daaa4'
ARCHIVE_GOG_SINGLE_PART1_TYPE='rar'
ARCHIVE_GOG_SINGLE_PART2='setup_sw_battlefront2_2.0.0.5-2.bin'
ARCHIVE_GOG_SINGLE_PART2_MD5='5d4000fd480a80b6e7c7b73c5a745368'
ARCHIVE_GOG_SINGLE_PART2_TYPE='rar'

ARCHIVE_ICONS='star-wars-battlefront-2_icons.tar.gz'
ARCHIVE_ICONS_MD5='322275011d37ac219f1c06c196477fa4'

ARCHIVE_DOC_DATA_PATH_GOG_XPLAY='app'
ARCHIVE_DOC_DATA_PATH_GOG_SINGLE='game'
ARCHIVE_DOC_DATA_FILES='./*.pdf'

ARCHIVE_GAME_BIN_PATH_GOG_XPLAY='app/gamedata'
ARCHIVE_GAME_BIN_PATH_GOG_SINGLE='game/gamedata'
ARCHIVE_GAME_BIN_FILES='./*.exe ./binkw32.dll ./eax.dll ./galaxy.dll ./unicows.dll'

ARCHIVE_GAME_MOVIES_PATH_GOG_XPLAY='app/gamedata'
ARCHIVE_GAME_MOVIES_PATH_GOG_SINGLE='game/gamedata'
ARCHIVE_GAME_MOVIES_FILES='./data/_lvl_pc/movies'

ARCHIVE_GAME_DATA_PATH_GOG_XPLAY='app/gamedata'
ARCHIVE_GAME_DATA_PATH_GOG_SINGLE='game/gamedata'
ARCHIVE_GAME_DATA_FILES='./data/_lvl_pc/*.def ./data/_lvl_pc/*.lvl ./data/_lvl_pc/bes ./data/_lvl_pc/common ./data/_lvl_pc/cor ./data/_lvl_pc/dag ./data/_lvl_pc/dea ./data/_lvl_pc/end ./data/_lvl_pc/fel ./data/_lvl_pc/fpm ./data/_lvl_pc/gal ./data/_lvl_pc/geo ./data/_lvl_pc/hot ./data/_lvl_pc/kam ./data/_lvl_pc/kas ./data/_lvl_pc/kor ./data/_lvl_pc/load ./data/_lvl_pc/mus ./data/_lvl_pc/myg ./data/_lvl_pc/nab ./data/_lvl_pc/pol ./data/_lvl_pc/rhn ./data/_lvl_pc/shell ./data/_lvl_pc/side ./data/_lvl_pc/sound ./data/_lvl_pc/spa ./data/_lvl_pc/tan ./data/_lvl_pc/tat ./data/_lvl_pc/test ./data/_lvl_pc/uta ./data/_lvl_pc/yav'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./32x32'

DATA_DIRS='./savegames'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='battlefrontii.exe'
APP_MAIN_ICON_GOG_XPLAY='app/goggame-1421404701.ico'
APP_MAIN_ICON_GOG_XPLAY_RES='16 32 48 256'
APP_MAIN_ICON_GOG_SINGLE='battlefrontii.exe'
APP_MAIN_ICON_GOG_SINGLE_RES='16 32'

PACKAGES_LIST='PKG_MOVIES PKG_DATA PKG_BIN'

PKG_MOVIES_ID="${GAME_ID}-movies"
PKG_MOVIES_DESCRIPTION='movies'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_MOVIES_ID, $PKG_DATA_ID, wine32 | wine-bin | wine-i386 | wine-staging-i386, wine:amd64 | wine, libtxc-dxtn-s2tc | libtxc-dxtn-s2tc0 | libtxc-dxtn0 | libtxc-dxtn"
PKG_BIN_DEPS_ARCH="$PKG_MOVIES_ID $PKG_DATA_ID wine lib32-libtxc_dxtn"

# Load common functions

target_version='2.1'

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

# Check that all parts of the installer are present

ARCHIVE_MAIN="$ARCHIVE"
case "$ARCHIVE" in
	('ARCHIVE_GOG_XPLAY')
		set_archive 'ARCHIVE_PART1' 'ARCHIVE_GOG_XPLAY_PART1'
		[ "$ARCHIVE_PART1" ] || set_archive_error_not_found 'ARCHIVE_GOG_XPLAY_PART1'
		set_archive 'ARCHIVE_PART2' 'ARCHIVE_GOG_XPLAY_PART2'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_XPLAY_PART2'
	;;
	('ARCHIVE_GOG_SINGLE')
		set_archive 'ARCHIVE_PART1' 'ARCHIVE_GOG_SINGLE_PART1'
		[ "$ARCHIVE_PART1" ] || set_archive_error_not_found 'ARCHIVE_GOG_SINGLE_PART1'
		set_archive 'ARCHIVE_PART2' 'ARCHIVE_GOG_SINGLE_PART2'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_SINGLE_PART2'
	;;
esac
ARCHIVE="$ARCHIVE_MAIN"

# Try to load icons archive

if [ "$ARCHIVE" = 'ARCHIVE_GOG_XPLAY' ]; then
	ARCHIVE_MAIN="$ARCHIVE"
	set_archive 'ICONS_PACK' 'ARCHIVE_ICONS'
	ARCHIVE="$ARCHIVE_MAIN"
fi

# Extract game data

case "$ARCHIVE" in
	('ARCHIVE_GOG_XPLAY')
		extract_data_from "$SOURCE_ARCHIVE"
	;;
	('ARCHIVE_GOG_SINGLE')
		ln --symbolic "$(readlink --canonicalize $ARCHIVE_PART1)" "$PLAYIT_WORKDIR/$GAME_ID.r00"
		ln --symbolic "$(readlink --canonicalize $ARCHIVE_PART2)" "$PLAYIT_WORKDIR/$GAME_ID.r01"
		extract_data_from "$PLAYIT_WORKDIR/$GAME_ID.r00"
		tolower "$PLAYIT_WORKDIR/gamedata"
	;;
esac

if [ "$ARCHIVE" = 'ARCHIVE_GOG_XPLAY' ] && [ "$ICONS_PACK" ]; then
	(
		ARCHIVE='ICONS_PACK'
		extract_data_from "$ICONS_PACK"
	)
fi

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

case "$ARCHIVE" in
	('ARCHIVE_GOG_XPLAY')
		PKG='PKG_DATA'
		if [ "$ICONS_PACK" ]; then
			organize_data 'ICONS' "$PATH_ICON_BASE"
		else
			APP_MAIN_ICON_RES="$APP_MAIN_ICON_GOG_XPLAY_RES"
			extract_icon_from "$PLAYIT_WORKDIR/gamedata/$APP_MAIN_ICON_GOG_XPLAY"
			sort_icons 'APP_MAIN'
		fi
	;;
	('ARCHIVE_GOG_SINGLE')
		PKG='PKG_BIN'
		APP_MAIN_ICON="$APP_MAIN_ICON_GOG_SINGLE"
		APP_MAIN_ICON_RES="$APP_MAIN_ICON_GOG_SINGLE_RES"
		extract_and_sort_icons_from 'APP_MAIN'
		move_icons_to 'PKG_DATA'
	;;
esac

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
