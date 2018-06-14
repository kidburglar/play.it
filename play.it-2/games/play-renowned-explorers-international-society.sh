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
# Renowned Explorers: International Society
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180612.1

# Set game-specific variables

GAME_ID='renowned-explorers-international-society'
GAME_NAME='Renowned Explorers: International Society'

ARCHIVE_GOG='renowned_explorers_international_society_en_489_20916.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/renowned_explorers'
ARCHIVE_GOG_MD5='42d0ecb54d8302545e78f41ed43acef6'
ARCHIVE_GOG_SIZE='1100000'
ARCHIVE_GOG_VERSION='489-gog20916'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='renowned_explorers_international_society_en_466_15616.sh'
ARCHIVE_GOG_OLD_MD5='fbad4b4d361a0e7d29b9781e3c5a5e85'
ARCHIVE_GOG_OLD_SIZE='1100000'
ARCHIVE_GOG_OLD_VERSION='466-gog15616'
ARCHIVE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_OLDER='renowned_explorers_international_society_en_459_14894.sh'
ARCHIVE_GOG_OLDER_MD5='ff6b368b3919002d2db750213d33fcef'
ARCHIVE_GOG_OLDER_SIZE='1100000'
ARCHIVE_GOG_OLDER_VERSION='459-gog14894'
ARCHIVE_GOG_OLDER_TYPE='mojosetup'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./x86_64'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./build.bni ./data ./project.bni ./settings.ini ./soundbanks'

CONFIG_FILES='./*.ini'
DATA_DIRS='./savedata'
DATA_FILES='./*.txt'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='x86/abbeycore'
APP_MAIN_EXE_BIN64='x86_64/abbeycore'
APP_MAIN_ICON='data/noarch/support/icon.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc libstdc++ sdl2 glu"

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

# Get icon

PKG='PKG_DATA'
icons_get_from_workdir 'APP_MAIN'
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
