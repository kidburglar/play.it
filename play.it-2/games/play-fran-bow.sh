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
# Fran Bow
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='fran-bow'
GAME_NAME='Fran Bow'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_fran_bow_2.3.0.5.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/fran_bow'
ARCHIVE_GOG_MD5='6e3013e9c8be4d25e1815f00bc177941'
ARCHIVE_GOG_SIZE='530000'
ARCHIVE_GOG_VERSION='160315-gog2.3.0.5'

ARCHIVE_LIBSSL_32='libssl_1.0.0_32-bit.tar.gz'
ARCHIVE_LIBSSL_32_MD5='9443cad4a640b2512920495eaf7582c4'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./runner'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./assets'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='runner'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='assets/icon.png'
APP_MAIN_ICON_RES='64'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, libglu1-mesa | libglu1, libopenal1, libxrandr2"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID lib32-glu lib32-openal lib32-libxrandr lib32-openssl-1.0"

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

# Use libSSL 1.0.0 32-bit archive

if [ "$OPTION_PACKAGE" != 'arch' ]; then
	ARCHIVE_MAIN="$ARCHIVE"
	set_archive 'ARCHIVE_LIBSSL' 'ARCHIVE_LIBSSL_32'
	ARCHIVE="$ARCHIVE_MAIN"
fi

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC'      "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Include libSSL into the game directory

if [ "$ARCHIVE_LIBSSL" ]; then
	(
		ARCHIVE='ARCHIVE_LIBSSL'
		extract_data_from "$ARCHIVE_LIBSSL"
	)
	dir='libs'
	mkdir --parents "${PKG_BIN_PATH}${PATH_GAME}/$dir"
	mv "$PLAYIT_WORKDIR/gamedata"/* "${PKG_BIN_PATH}${PATH_GAME}/$dir"
	APP_MAIN_LIBS="$dir"
	rm --recursive "$PLAYIT_WORKDIR/gamedata"
fi

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
