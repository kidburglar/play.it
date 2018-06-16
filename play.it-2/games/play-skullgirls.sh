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
# Skullgirls
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20171115.1

# Set game-specific variables

GAME_ID='skullgirls'
GAME_NAME='Skullgirls'

ARCHIVES_LIST='ARCHIVE_HUMBLE ARCHIVE_HUMBLE_OLD'

ARCHIVE_HUMBLE='Skullgirls-15719.tar'
ARCHIVE_HUMBLE_MD5='104a6976aec70d423756e008a5b8554c'
ARCHIVE_HUMBLE_SIZE='4200000'
ARCHIVE_HUMBLE_VERSION='15719-humble170628'

ARCHIVE_HUMBLE_OLD='Skullgirls-1.0.1.sh'
ARCHIVE_HUMBLE_OLD_MD5='bf110f7d29bfd4b9e075584e41fef402'
ARCHIVE_HUMBLE_OLD_TYPE='mojosetup'
ARCHIVE_HUMBLE_OLD_SIZE='4200000'
ARCHIVE_HUMBLE_OLD_VERSION='1.0.1-humble152310'

ARCHIVE_GAME_BIN32_PATH_HUMBLE='SkullGirls'
ARCHIVE_GAME_BIN32_PATH_HUMBLE_OLD='data/i686'
ARCHIVE_GAME_BIN32_FILES='./SkullGirls.i686-pc-linux-gnu ./lib/i686-pc-linux-gnu'

ARCHIVE_GAME_BIN64_PATH_HUMBLE='SkullGirls'
ARCHIVE_GAME_BIN64_PATH_HUMBLE_OLD='data/x86_64'
ARCHIVE_GAME_BIN64_FILES='./SkullGirls.x86_64-pc-linux-gnu ./lib/x86_64-pc-linux-gnu'

ARCHIVE_GAME_UI_PATH_HUMBLE='SkullGirls'
ARCHIVE_GAME_UI_PATH_HUMBLE_OLD='data/noarch'
ARCHIVE_GAME_UI_FILES='./data01/ui*.gfs'

ARCHIVE_GAME_DATA_PATH_HUMBLE='SkullGirls'
ARCHIVE_GAME_DATA_PATH_HUMBLE_OLD='data/noarch'
ARCHIVE_GAME_DATA_FILES='./*.txt ./data01 ./Icon.png ./Salmon'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='SkullGirls.i686-pc-linux-gnu'
APP_MAIN_EXE_BIN64='SkullGirls.x86_64-pc-linux-gnu'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='Icon.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_UI PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_UI_ID="${GAME_ID}-ui"
PKG_UI_DESCRIPTION='user interface'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS_DEB="$PKG_UI_ID, $PKG_DATA_ID, libc6, libstdc++6, libsdl2-mixer-2.0-0, libsdl2-2.0-0"
PKG_BIN32_DEPS_ARCH="$PKG_UI_ID $PKG_DATA_ID lib32-glibc lib32-gcc-libs lib32-sdl2 lib32-sdl2_mixer"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS_DEB="$PKG_BIN32_DEPS_DEB"
PKG_BIN64_DEPS_ARCH="$PKG_UI_ID, $PKG_DATA_ID glibc gcc-libs sdl2 sdl2_mixer"

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

PKG='PKG_UI'
organize_data 'GAME_UI' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'GAME_DATA' "$PATH_GAME"

PKG='PKG_BIN32'
organize_data 'GAME_BIN32' "$PATH_GAME"

PKG='PKG_BIN64'
organize_data 'GAME_BIN64' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_UI' 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_UI' 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_UI' 'PKG_DATA' 'PKG_BIN64'

exit 0
