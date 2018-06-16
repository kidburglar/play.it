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
# The Whispered World
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='the-whispered-world'
GAME_NAME='The Whispered World'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_the_whispered_world_special_edition_2.0.0.1.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_whispered_world_special_edition'
ARCHIVE_GOG_MD5='485368f130f2d82f564a0159cd497437'
ARCHIVE_GOG_SIZE='2200000'
ARCHIVE_GOG_VERSION='3.2.0418-gog2.0.0.1'

ARCHIVE_ICONS_PACK='the-whispered-world_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='3ec301bf71cf279aa8de91c136e16388'

ARCHIVE_DOC1_PATH='data/noarch/docs'
ARCHIVE_DOC1_FILES='./*'

ARCHIVE_DOC2_PATH='data/noarch/game/documents/licenses'
ARCHIVE_DOC2_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./TWWSE ./config.ini ./libs64'

ARCHIVE_GAME_SCENES_PATH='data/noarch/game'
ARCHIVE_GAME_SCENES_FILES='./scenes'

ARCHIVE_GAME_VIDEO_PATH='data/noarch/game'
ARCHIVE_GAME_VIDEO_FILES='./videos'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./characters ./data.vis ./lua'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./32x32 ./48x48 ./256x256'

CONFIG_FILES='./config.ini'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='mkdir --parents "$HOME/.local/share/Daedalic Entertainment GmbH/The Whispered World Special Edition/Savegames"'
APP_MAIN_EXE='TWWSE'
APP_MAIN_LIBS='libs64'
APP_MAIN_ICON_GOG='data/noarch/support/icon.png'
APP_MAIN_ICON_GOG_RES='256'

PACKAGES_LIST='PKG_SCENES PKG_VIDEO PKG_DATA PKG_BIN'

PKG_SCENES_ID="${GAME_ID}-scenes"
PKG_SCENES_DESCRIPTION='scenes'

PKG_VIDEO_ID="${GAME_ID}-videos"
PKG_VIDEO_DESCRIPTION='videos'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS_DEB="$PKG_SCENES_ID, $PKG_VIDEO_ID, $PKG_DATA_ID, libgl1-mesa-glx | libgl1, libopenal1"
PKG_BIN_DEPS_ARCH="$PKG_SCENES_ID $PKG_VIDEO_ID $PKG_DATA_ID libgl openal"

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

# Try to load icons archive

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_ICONS' 'ARCHIVE_ICONS_PACK'
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
if [ "$ARCHIVE_ICONS" ]; then
	(
		ARCHIVE='ARCHIVE_ICONS'
		extract_data_from "$ARCHIVE_ICONS"
	)
fi

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_SCENES'
organize_data 'GAME_SCENES' "$PATH_GAME"

PKG='PKG_VIDEO'
organize_data 'GAME_VIDEO' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC1'      "$PATH_DOC"
organize_data 'DOC2'      "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	organize_data 'ICONS' "$PATH_ICON_BASE"
else
	get_icon_from_temp_dir 'APP_MAIN'
fi

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
