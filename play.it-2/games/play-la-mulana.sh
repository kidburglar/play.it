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
# La•Mulana
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180519.1

# Set game-specific variables

GAME_ID='la-mulana'
GAME_NAME='La•Mulana'

SCRIPT_DEPS='bsdtar'

ARCHIVE_HUMBLE='20170404_LaMulana_Linux.zip'
ARCHIVE_HUMBLE_MD5='e7a597ea2588ae975a7cc7b59c17d50d'
ARCHIVE_HUMBLE_SIZE='120000'
ARCHIVE_HUMBLE_VERSION='1.6.6-humble180409'

ARCHIVE_DOC0_DATA_PATH='.'
ARCHIVE_DOC0_DATA_FILES='./ReadMe_??.txt ./License ./Manual'

ARCHIVE_DOC1_DATA_PATH='data/noarch'
ARCHIVE_DOC1_DATA_FILES='./README.linux'

ARCHIVE_GAME_BIN_PATH='data/x86'
ARCHIVE_GAME_BIN_FILES='./*'

ARCHIVE_GAME_DATA_PATH='data/noarch'
ARCHIVE_GAME_DATA_FILES='./data ./*.bmp ./*.png'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='LaMulana.bin.x86'
APP_MAIN_ICON='Icon.png'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS="$PKG_DATA_ID glibc libstdc++ glx sdl2 openal"

# Load common functions

target_version='2.8'

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
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
(
	ARCHIVE='INNER_ARCHIVE'
	INNER_ARCHIVE="$PLAYIT_WORKDIR/gamedata/LaMulanaSetup-2017-01-27.sh"
	INNER_ARCHIVE_TYPE='mojosetup'
	extract_data_from "$INNER_ARCHIVE"
	rm "$INNER_ARCHIVE"
)
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build packages

PKG='PKG_DATA'
icons_linking_postinst 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
