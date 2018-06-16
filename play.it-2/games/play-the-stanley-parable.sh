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
# The Stanley Parable
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='the-stanley-parable'
GAME_NAME='The Stanley Parable'

ARCHIVES_LIST='ARCHIVE_HUMBLE'

ARCHIVE_HUMBLE='The_Stanley_Parable_Setup.tar'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/the-stanley-parable'
ARCHIVE_HUMBLE_MD5='10a98d7fb93017eb666281bf2d3da28d'
ARCHIVE_HUMBLE_SIZE='2100000'
ARCHIVE_HUMBLE_VERSION='1.0-humble161007'

ARCHIVE_DOC_PATH='data'
ARCHIVE_DOC_FILES='./thirdpartylegalnotices.doc'

ARCHIVE_GAME_BIN_PATH='data'
ARCHIVE_GAME_BIN_FILES='./bin thestanleyparable/bin ./stanley_linux'

ARCHIVE_GAME_DATA_PATH='data'
ARCHIVE_GAME_DATA_FILES='./platform ./stanley.png ./thestanleyparable'

CONFIG_DIRS='./thestanleyparable/cfg'
DATA_DIRS='./thestanleyparable/save'
DATA_FILES='./thestanleyparable/stats.vdf'

APP_MAIN_TYPE='native'
APP_MAIN_LIBS='bin'
APP_MAIN_EXE='stanley_linux'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='./stanley.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, libc6"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID lib32-glibc"

# Load common functions

target_version='2.3'

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

ARCHIVE_HUMBLE_TYPE='mojosetup'
extract_data_from "$PLAYIT_WORKDIR/gamedata/The Stanley Parable Setup"
rm "$PLAYIT_WORKDIR/gamedata/The Stanley Parable Setup"
rm --recursive --force "$PLAYIT_WORKDIR/gamedata/guis" "$PLAYIT_WORKDIR/gamedata/meta" "$PLAYIT_WORKDIR/gamedata/scripts"

ARCHIVE_HUMBLE_TYPE='tar'
extract_data_from "$PLAYIT_WORKDIR/gamedata/data/tsp.tar"
rm "$PLAYIT_WORKDIR/gamedata/data/tsp.tar"

set_standard_permissions "$PLAYIT_WORKDIR/gamedata"

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC'       "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
