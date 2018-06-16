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
# Jazzpunk
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180130.1

# Set game-specific variables

GAME_ID='jazzpunk'
GAME_NAME='Jazzpunk'

ARCHIVES_LIST='ARCHIVE_HUMBLE ARCHIVE_HUMBLE_OLD'

ARCHIVE_HUMBLE='Jazzpunk-Oct-30-2017-Linux.zip'
ARCHIVE_HUMBLE_MD5='e8ecf692ded05cea80701d417fa565c1'
ARCHIVE_HUMBLE_SIZE='2800000'
ARCHIVE_HUMBLE_VERSION='171030-humble171121'

ARCHIVE_HUMBLE_OLD='Jazzpunk-July6-2014-Linux.zip'
ARCHIVE_HUMBLE_OLD_MD5='50ad5722cafe16dc384e83a4a4e19480'
ARCHIVE_HUMBLE_OLD_SIZE='1600000'
ARCHIVE_HUMBLE_OLD_VERSION='140706-humble140708'

ARCHIVE_ICONS_PACK='jazzpunk_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='d1fe700322ad08f9ac3dec1c29512f94'

ARCHIVE_GAME_BIN32_PATH='./'
ARCHIVE_GAME_BIN32_FILES='./Jazzpunk.x86 ./Jazzpunk_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH='./'
ARCHIVE_GAME_BIN64_FILES='./Jazzpunk.x86_64 ./Jazzpunk_Data/*/x86_64'

ARCHIVE_GAME_DATA_PATH='./'
ARCHIVE_GAME_DATA_FILES='./Jazzpunk_Data/level* ./Jazzpunk_Data/mainData ./Jazzpunk_Data/Managed ./Jazzpunk_Data/Mono/etc ./Jazzpunk_Data/PlayerConnectionConfigFile ./Jazzpunk_Data/Resources ./Jazzpunk_Data/*.assets ./Jazzpunk_Data/ScreenSelector.png ./Jazzpunk_Data/StreamingAssets'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./32x32 ./48x48 ./128x128 ./256x256'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='./Jazzpunk.x86'
APP_MAIN_EXE_BIN64='./Jazzpunk.x86_64'

PACKAGES_LIST='PKG_DATA PKG_BIN32'
PACKAGES_LIST_OLD='PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN64_DEPS="$PKG_DATA_ID glibc libstdc++ glu xcursor"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

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

# Set packages list according to source archive

if [ "$ARCHIVE" = 'ARCHIVE_HUMBLE_OLD' ]; then
	PACKAGES_LIST="$PACKAGES_LIST_OLD"
	set_temp_directories $PACKAGES_LIST
fi

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

case "$ARCHIVE" in
	('ARCHIVE_HUMBLE')
		PKG='PKG_BIN32'
		write_launcher 'APP_MAIN'
	;;
	('ARCHIVE_HUMBLE_OLD')
		for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
			write_launcher 'APP_MAIN'
		done
	;;
esac

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

case "$ARCHIVE" in
	('ARCHIVE_HUMBLE')
		print_instructions
	;;
	('ARCHIVE_HUMBLE_OLD')
		printf '\n'
		printf '32-bit:'
		print_instructions 'PKG_DATA' 'PKG_BIN32'
		printf '64-bit:'
		print_instructions 'PKG_DATA' 'PKG_BIN64'
	;;
esac

exit 0
