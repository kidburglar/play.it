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
# Darkest Dungeon
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180621.1

# Set game-specific variables

GAME_ID='darkest-dungeon'
GAME_NAME='Darkest Dungeon'

ARCHIVE_GOG='darkest_dungeon_en_23885_21662.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/darkest_dungeon'
ARCHIVE_GOG_MD5='ff449de9cfcdf97fa1a27d1073139463'
ARCHIVE_GOG_SIZE='2300000'
ARCHIVE_GOG_VERSION='23885-gog21662'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='darkest_dungeon_en_21142_16140.sh'
ARCHIVE_GOG_OLD_MD5='4b43065624dbab74d794c56809170588'
ARCHIVE_GOG_OLD_SIZE='2200000'
ARCHIVE_GOG_OLD_VERSION='21142-gog16140'
ARCHIVE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_OLDER='darkest_dungeon_en_21096_16066.sh'
ARCHIVE_GOG_OLDER_MD5='435905fe6edd911a8645d4feaf94ec34'
ARCHIVE_GOG_OLDER_SIZE='2200000'
ARCHIVE_GOG_OLDER_VERSION='21096-gog16066'
ARCHIVE_GOG_OLDER_TYPE='mojosetup'

ARCHIVE_GOG_OLDEST='darkest_dungeon_en_21071_15970.sh'
ARCHIVE_GOG_OLDEST_MD5='e4880968101835fcd27f63a48e208ed8'
ARCHIVE_GOG_OLDEST_SIZE='2200000'
ARCHIVE_GOG_OLDEST_VERSION='21071-gog15970'
ARCHIVE_GOG_OLDEST_TYPE='mojosetup'

DATA_DIRS='./logs'

ARCHIVE_DOC0_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC0_DATA_FILES='./*'

ARCHIVE_DOC1_DATA_PATH='data/noarch/game'
ARCHIVE_DOC1_DATA_FILES='./README.linux'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./lib ./darkest.bin.x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./lib64 ./darkest.bin.x86_64'

ARCHIVE_GAME_MEDIA_PATH='data/noarch/game'
ARCHIVE_GAME_MEDIA_FILES='./audio ./video'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./Icon.bmp ./pin ./svn_revision.txt ./activity_log ./campaign ./colours ./curios ./cursors ./dungeons ./effects ./fe_flow ./fonts ./fx ./game_over ./heroes ./inventory ./loading_screen ./loot ./maps ./modes ./mods ./monsters ./overlays ./panels ./props ./raid ./raid_results ./scripts ./scrolls ./shaders ./shared ./trinkets ./upgrades ./user_information ./localization/*.bat ./localization/*.csv ./localization/*.loc ./localization/*.txt ./localization/*.xml ./localization/pc'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='darkest.bin.x86'
APP_MAIN_EXE_BIN64='darkest.bin.x86_64'
APP_MAIN_OPTIONS='1>./logs/$(date +%F-%R).log 2>&1'
APP_MAIN_ICON='Icon.bmp'

PACKAGES_LIST='PKG_MEDIA PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_MEDIA_ID="${GAME_ID}-media"
PKG_MEDIA_DESCRIPTION='audio & video'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_MEDIA_ID $PKG_DATA_ID glibc libstdc++6 sdl2"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

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

# Get icon

PKG='PKG_DATA'
icons_get_from_package 'APP_MAIN'

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done


# Allow persistent logging via output redirection to work

pattern='s|"\./$APP_EXE" $APP_OPTIONS $@|eval &|'
file0="${PKG_BIN32_PATH}${PATH_BIN}/$GAME_ID"
file1="${PKG_BIN64_PATH}${PATH_BIN}/$GAME_ID"
sed --in-place "$pattern" "$file0" "$file1"

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
