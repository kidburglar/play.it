#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2018, Antoine Le Gonidec
# Copyright (c) 2018, Solène Huault
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
# The Warlock of Firetop Mountain
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180624.1

# Set game-specific variables

GAME_ID='the-warlock-of-firetop-mountain'
GAME_NAME='The Warlock of Firetop Mountain'

ARCHIVE_HUMBLE='WARLOCK_LINUX_487115.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/the-warlock-of-firetop-mountain'
ARCHIVE_HUMBLE_MD5='ae29e02f78225d69a3bdb661e13f2a3f'
ARCHIVE_HUMBLE_SIZE='1600000'
ARCHIVE_HUMBLE_VERSION='1.0-humble180508'

ARCHIVE_HUMBLE_OLD='WARLOCK_LINUX_487088.zip'
ARCHIVE_HUMBLE_OLD_MD5='17d4e909dbed98cd420eee5bb6a828d3'
ARCHIVE_HUMBLE_OLD_SIZE='1600000'
ARCHIVE_HUMBLE_OLD_VERSION='1.0-humble171022'

ARCHIVE_GAME_BIN32_PATH='WARLOCK_LINUX_487115'
ARCHIVE_GAME_BIN32_PATH_HUMBLE_OLD='WARLOCK_LINUX_487088'
ARCHIVE_GAME_BIN32_FILES='./*.x86 ./*_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH='WARLOCK_LINUX_487115'
ARCHIVE_GAME_BIN64_PATH_HUMBLE_OLD='WARLOCK_LINUX_487088'
ARCHIVE_GAME_BIN64_FILES='./*.x86_64 ./*_Data/*/x86_64'

ARCHIVE_GAME_DATA_PATH='WARLOCK_LINUX_487115'
ARCHIVE_GAME_DATA_PATH_HUMBLE_OLD='WARLOCK_LINUX_487088'
ARCHIVE_GAME_DATA_FILES='./*_Data/*.assets ./*_Data/*.resS ./*_Data/level* ./*_Data/Mono/etc ./*_Data/Managed ./*_Data/Resources ./*_Data/Plugins ./*_Data/globalgamemanagers ./*_Data/ScreenSelector.png ./*_Data/*.resource'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='The Warlock of Firetop Mountain.x86'
APP_MAIN_EXE_BIN64='The Warlock of Firetop Mountain.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICON='The Warlock of Firetop Mountain_Data/Resources/UnityPlayer.png'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc libstdc++ glu libxrandr"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

# Load common functions

target_version='2.9'

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
		exit 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

PKG='PKG_DATA'
icons_linking_postinst 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
