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
# Planescape Torment - Enhanced Edition
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='planescape-torment-enhanced-edition'
GAME_NAME='Planescape Torment - Enhanced Edition'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_planescape_torment_enhanced_edition_2.1.0.3.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/planescape_torment_enhanced_edition'
ARCHIVE_GOG_MD5='649c1bf9d7ccd81553c574ff1bec2cef'
ARCHIVE_GOG_SIZE='1800000'
ARCHIVE_GOG_VERSION='3.1.3-gog2.1.0.3'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_LIBSSL_32='libssl_1.0.0_32-bit.tar.gz'
ARCHIVE_LIBSSL_32_MD5='9443cad4a640b2512920495eaf7582c4'

ARCHIVE_LIBSSL_64='libssl_1.0.0_64-bit.tar.gz'
ARCHIVE_LIBSSL_64_MD5='89917bef5dd34a2865cb63c2287e0bd4'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./Torment ./*_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./Torment64 ./*_Data/*/x86_64'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./Torment.pdb ./music ./lang ./engine.lua ./data ./chitin.key'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='Torment'
APP_MAIN_EXE_BIN64='Torment64'
APP_MAIN_ICON='data/noarch/support/icon.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc libstdc++ openal glx"
PKG_BIN32_DEPS_ARCH='lib32-openssl-1.0'

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"
PKG_BIN64_DEPS_ARCH='openssl-1.0'

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

# Use libSSL 1.0.0 archives

if [ "$OPTION_PACKAGE" != 'arch' ]; then
	ARCHIVE_MAIN="$ARCHIVE"
	set_archive 'ARCHIVE_LIBSSL32' 'ARCHIVE_LIBSSL_32'
	set_archive 'ARCHIVE_LIBSSL64' 'ARCHIVE_LIBSSL_64'
	ARCHIVE="$ARCHIVE_MAIN"
fi

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_DATA'
get_icon_from_temp_dir 'APP_MAIN'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Include libSSL into the game directory

if [ "$ARCHIVE_LIBSSL32" ]; then
	(
		ARCHIVE='ARCHIVE_LIBSSL32'
		extract_data_from "$ARCHIVE_LIBSSL32"
	)
	dir='libs'
	mkdir --parents "${PKG_BIN32_PATH}${PATH_GAME}/$dir"
	mv "$PLAYIT_WORKDIR/gamedata"/* "${PKG_BIN32_PATH}${PATH_GAME}/$dir"
	APP_MAIN_LIBS_BIN32="$dir"
	rm --recursive "$PLAYIT_WORKDIR/gamedata"
fi
if [ "$ARCHIVE_LIBSSL64" ]; then
	(
		ARCHIVE='ARCHIVE_LIBSSL64'
		extract_data_from "$ARCHIVE_LIBSSL64"
	)
	dir='libs'
	mkdir --parents "${PKG_BIN64_PATH}${PATH_GAME}/$dir"
	mv "$PLAYIT_WORKDIR/gamedata"/* "${PKG_BIN64_PATH}${PATH_GAME}/$dir"
	APP_MAIN_LIBS_BIN64="$dir"
	rm --recursive "$PLAYIT_WORKDIR/gamedata"
fi

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN64'

exit 0
