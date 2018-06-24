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
# Mini Metro
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180624.1

# Set game-specific variables

GAME_ID='mini-metro'
GAME_NAME='Mini Metro'

ARCHIVE_HUMBLE='MiniMetro-release-36b-linux.tar.gz'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/mini-metro'
ARCHIVE_HUMBLE_MD5='5c6b16404cd0c3fc00be295721ec7bdd'
ARCHIVE_HUMBLE_VERSION='1.36b-humble180605'
ARCHIVE_HUMBLE_SIZE='310000'

ARCHIVE_HUMBLE_OLD='MiniMetro-gamma35b-linux.tar.gz'
ARCHIVE_HUMBLE_OLD_MD5='5548397ea5eddd915aa33247a38dad74'
ARCHIVE_HUMBLE_OLD_VERSION='1.35b-humble1'
ARCHIVE_HUMBLE_OLD_SIZE='310000'

ARCHIVE_GAME_BIN32_PATH='.'
ARCHIVE_GAME_BIN32_FILES='./Mini?Metro.x86 ./Mini?Metro_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH='.'
ARCHIVE_GAME_BIN64_FILES='./Mini?Metro.x86_64 ./Mini?Metro_Data/*/x86_64'

ARCHIVE_GAME_DATA_PATH='.'
ARCHIVE_GAME_DATA_FILES='*_Data/level* *_Data/StreamingAssets *_Data/Managed *_Data/Mono/etc *_Data/*.assets *_Data/Resources *_Data/resources.assets.resS *_Data/globalgamemanagers *_Data/boot.config'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='export LANG=C'
APP_MAIN_EXE_BIN32='Mini Metro.x86'
APP_MAIN_EXE_BIN64='Mini Metro.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICON='Mini Metro_Data/Resources/UnityPlayer.png'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc"

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
