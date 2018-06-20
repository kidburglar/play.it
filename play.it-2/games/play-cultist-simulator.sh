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
# Cultist Simulator
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180620.1

# Set game-specific variables

GAME_ID='cultist-simulator'
GAME_NAME='Cultist Simulator'

ARCHIVE_GOG='cultist_simulator_en_v2018_6_k_2_21613.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/cultist_simulator'
ARCHIVE_GOG_MD5='4956d00d5ac6d7caa01b5323797d3a1b'
ARCHIVE_GOG_SIZE='320000'
ARCHIVE_GOG_VERSION='2018.6.k.2-gog21613'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='cultist_simulator_en_v2018_6_f_1_21446.sh'
ARCHIVE_GOG_OLD_MD5='b98da20e3ae0a8892988ad8c09383d40'
ARCHIVE_GOG_OLD_SIZE='320000'
ARCHIVE_GOG_OLD_VERSION='2018.6.f.1-gog21446'
ARCHIVE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_OLDER='cultist_simulator_en_v2018_6_c_7_21347.sh'
ARCHIVE_GOG_OLDER_MD5='beff3d27b3cce3f1448cd9cd46d488bc'
ARCHIVE_GOG_OLDER_SIZE='310000'
ARCHIVE_GOG_OLDER_VERSION='2018.6.c.7-gog21347'
ARCHIVE_GOG_OLDER_TYPE='mojosetup'

ARCHIVE_GOG_OLDEST='cultist_simulator_en_v2018_5_x_6_21178.sh'
ARCHIVE_GOG_OLDEST_MD5='7885e6e571940ddc0f8c6101c2af77a5'
ARCHIVE_GOG_OLDEST_SIZE='310000'
ARCHIVE_GOG_OLDEST_VERSION='2018.5.x.6-gog21178'
ARCHIVE_GOG_OLDEST_TYPE='mojosetup'

ARCHIVE_DOC0_PATH='data/noarch/docs'
ARCHIVE_DOC0_FILES='./*'

ARCHIVE_DOC1_PATH='data/noarch/game'
ARCHIVE_DOC1_FILES='./README'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./CS.x86 ./libsteam_api.so ./CS_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./CS.x86_64 ./libsteam_api64.so ./CS_Data/*/x86_64'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./CS_Data'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='export LANG=C'
APP_MAIN_EXE_BIN32='CS.x86'
APP_MAIN_EXE_BIN64='CS.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICON='CS_Data/Resources/UnityPlayer.png'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc libstdc++ gtk2"

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
