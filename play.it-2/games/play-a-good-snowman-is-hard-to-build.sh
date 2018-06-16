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
# A Good Snowman is Hard to Build
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='a-good-snowman-is-hard-to-build'
GAME_NAME='A Good Snowman is Hard to Build'

ARCHIVES_LIST='ARCHIVE_HUMBLE'

ARCHIVE_HUMBLE='snowman-linux-1.0.8.tar.gz'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/a-good-snowman-is-hard-to-build'
ARCHIVE_HUMBLE_MD5='4461dfdcaba9e8793e3044b458b0e301'
ARCHIVE_HUMBLE_SIZE='120000'
ARCHIVE_HUMBLE_VERSION='1.0.8-humble160421'

ARCHIVE_ICONS_PACK='a-good-snowman-is-hard-to-build_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='8d595a7758ae8cd6dbc441ab79579fb4'

ARCHIVE_GAME_BIN32_PATH='snowman'
ARCHIVE_GAME_BIN32_FILES='./bin32'

ARCHIVE_GAME_BIN64_PATH='snowman'
ARCHIVE_GAME_BIN64_FILES='./bin64'

ARCHIVE_GAME_DATA_PATH='snowman'
ARCHIVE_GAME_DATA_FILES='./atlases ./crashdumper ./fonts ./libraries ./manifest ./music ./resources ./sounds ./spritesheets ./strings'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./24x24 ./32x32 ./40x40 ./48x48 ./64x64 ./96x96 ./128x128 ./256x256 ./512x512 ./768x768'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN_BIN32='ln --symbolic --force bin32/lime-legacy.ndll .'
APP_MAIN_PRERUN_BIN64='ln --symbolic --force bin64/lime-legacy.ndll .'
APP_MAIN_LIBS_BIN32='bin32'
APP_MAIN_LIBS_BIN64='bin64'
APP_MAIN_EXE_BIN32='bin32/Snowman'
APP_MAIN_EXE_BIN64='bin64/Snowman'

PACKAGES_LIST='PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS_DEB="$PKG_DATA_ID, libc6, libstdc++6"
PKG_BIN32_DEPS_ARCH="$PKG_DATA_ID lib32-glibc lib32-gcc-libs"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS_DEB="$PKG_BIN32_DEPS_DEB"
PKG_BIN64_DEPS_ARCH="$PKG_DATA_ID glibc gcc-libs"

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

for PKG in $PACKAGES_LIST; do
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	organize_data 'ICONS' "$PATH_ICON_BASE"
fi

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN32'
APP_MAIN_PRERUN="$APP_MAIN_PRERUN_BIN32"
write_launcher 'APP_MAIN'
PKG='PKG_BIN64'
APP_MAIN_PRERUN="$APP_MAIN_PRERUN_BIN64"
write_launcher 'APP_MAIN'

# Build package

write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "${PLAYIT_WORKDIR}"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN64'

exit 0
