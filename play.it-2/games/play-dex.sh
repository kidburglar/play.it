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
# Dex
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180308.1

# Set game-specific variables

GAME_ID='dex-game'
GAME_NAME='Dex'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD'

ARCHIVE_GOG='dex_en_6_0_0_0_build_5553_17130.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/dex'
ARCHIVE_GOG_MD5='3d6f8797fab72dcb867c92bf5a84b4dd'
ARCHIVE_GOG_SIZE='6300000'
ARCHIVE_GOG_VERSION='6.0.0.0.5553-gog17130'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='gog_dex_2.3.0.4.sh'
ARCHIVE_GOG_OLD_MD5='199a1acc59879124e8e1c532909fd879'
ARCHIVE_GOG_OLD_SIZE='6200000'
ARCHIVE_GOG_OLD_VERSION='5.4.0.0-gog2.3.0.4'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./*.x86 ./*_Data/*/x86'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./*_Data/*.assets ./Dex_Data/level* ./*_Data/Mono/etc ./*_Data/Managed ./*_Data/Resources ./*_Data/Plugins ./*_Data/mainData ./Dex_Data/ScreenSelector.png ./Dex_Data/*.resource'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='pulseaudio --start'
APP_MAIN_EXE='Dex.x86'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='Dex_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID glibc libstdc++ glx xcursor libxrandr pulseaudio"

# Load common functions

target_version='2.6'

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
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

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
