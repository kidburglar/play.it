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
# Banished
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='banished'
GAME_NAME='Banished'

ARCHIVES_LIST='ARCHIVE_GOG_32 ARCHIVE_GOG_64'

ARCHIVE_GOG_32='setup_banished_32_1.0.7_(14938).exe'
ARCHIVE_GOG_32_URL='https://www.gog.com/game/banished'
ARCHIVE_GOG_32_MD5='43042701a692f186d467b97e966fb846'
ARCHIVE_GOG_32_VERSION='1.0.7-gog14938'
ARCHIVE_GOG_32_SIZE='190000'

ARCHIVE_GOG_64='setup_banished_64_1.0.7_(14938).exe'
ARCHIVE_GOG_64_URL='https://www.gog.com/game/banished'
ARCHIVE_GOG_64_MD5='463b2720c5c88c28f24de9176b8b1ec4'
ARCHIVE_GOG_64_VERSION='1.0.7-gog14938'
ARCHIVE_GOG_64_SIZE='190000'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.dll ./*.exe'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./windata'

APP_WINETRICKS='xact'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE_GOG_32='application-x32.exe'
APP_MAIN_EXE_GOG_64='application-x64.exe'
APP_MAIN_ICON_GOG_32='application-x32.exe'
APP_MAIN_ICON_GOG_64='application-x64.exe'
APP_MAIN_ICON_RES='16 24 32 48'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ID="$GAME_ID"
PKG_BIN_ARCH_GOG_32='32'
PKG_BIN_ARCH_GOG_64='64'
PKG_BIN_DEPS="$PKG_DATA_ID wine winetricks"

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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
use_archive_specific_value 'APP_MAIN_ICON'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
use_archive_specific_value 'APP_MAIN_EXE'
write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
