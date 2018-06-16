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
# The Westport Independent
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180413.1

# Set game-specific variables

GAME_ID='the-westport-independent'
GAME_NAME='The Westport Independent'

ARCHIVE_GOG='gog_the_westport_independent_2.0.0.1.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/westport_independent_the'
ARCHIVE_GOG_MD5='7032059f085e94f52444e9bf4ed0195c'
ARCHIVE_GOG_SIZE='130000'
ARCHIVE_GOG_VERSION='1.0.0-gog2.0.0.1'

ARCHIVE_EXTRA_ICONS='the-westport-independent_icons.tar.gz'
ARCHIVE_EXTRA_ICONS_URL='https://www.dotslashplay.it/ressources/the-westport-independant/'
ARCHIVE_EXTRA_ICONS_MD5='054b51fe4c02f256b8130b40e93d28ae'

ARCHIVE_DOC1_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC1_DATA_FILES='./*'

ARCHIVE_DOC2_DATA_PATH='data/noarch/game/linux32'
ARCHIVE_DOC2_DATA_FILES='./*.txt'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game/linux32'
ARCHIVE_GAME_BIN32_FILES='./the_westport_independent'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game/linux64'
ARCHIVE_GAME_BIN64_FILES='./the_westport_independent'

ARCHIVE_GAME_DATA_PATH='data/noarch/game/linux32'
ARCHIVE_GAME_DATA_FILES='./config.json ./assets'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./*'

CONFIG_FILES='./config.json'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='the_westport_independent'
APP_MAIN_ICON='data/noarch/support/icon.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc libstdc++ glx openal"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

# Load common functions

target_version='2.7'

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
set_archive 'ARCHIVE_ICONS' 'ARCHIVE_EXTRA_ICONS'
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout

# Extract game icon

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	rm --recursive "$PLAYIT_WORKDIR/gamedata"
	(
		ARCHIVE='ARCHIVE_ICONS'
		extract_data_from "$ARCHIVE_ICONS"
	)
	organize_data 'ICONS' "$PATH_ICON_BASE"
else
	get_icon_from_temp_dir 'APP_MAIN'
fi
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
