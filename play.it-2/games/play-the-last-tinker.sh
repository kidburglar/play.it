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
# The Last Tinker: City of Colors
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180310.1

# Set game-specific variables

GAME_ID='the-last-tinker'
GAME_NAME='The Last Tinker: City of Colors'

ARCHIVES_LIST='ARCHIVE_GOG_LINUX ARCHIVE_GOG_WINDOWS ARCHIVE_GOG_WINDOWS_OLD'

ARCHIVE_GOG_LINUX='last_tinker_city_of_colors_the_en_23_02_2018_18902.sh'
ARCHIVE_GOG_LINUX_URL='https://www.gog.com/game/the_last_tinker_city_of_colors'
ARCHIVE_GOG_LINUX_MD5='d0dbfac723aee309869c2404d88b4eb4'
ARCHIVE_GOG_LINUX_VERSION='180223-gog18902'
ARCHIVE_GOG_LINUX_SIZE='2100000'
ARCHIVE_GOG_LINUX_TYPE='mojosetup'

ARCHIVE_GOG_WINDOWS='setup_the_last_tinker_-_city_of_colors_23.02.2018_(18831).exe'
ARCHIVE_GOG_WINDOWS_URL='https://www.gog.com/game/the_last_tinker_city_of_colors'
ARCHIVE_GOG_WINDOWS_MD5='ec303722fba022e2b1d04f69091213d9'
ARCHIVE_GOG_WINDOWS_VERSION='180223-gog18831'
ARCHIVE_GOG_WINDOWS_SIZE='2000000'
ARCHIVE_GOG_WINDOWS_TYPE='innosetup'
ARCHIVE_GOG_WINDOWS_PART1='setup_the_last_tinker_-_city_of_colors_23.02.2018_(18831)-1.bin'
ARCHIVE_GOG_WINDOWS_PART1_MD5='91e843b4d7be0d842bf3dc1f9930f11d'
ARCHIVE_GOG_WINDOWS_PART1_TYPE='innosetup'

ARCHIVE_GOG_WINDOWS_OLD='setup_the_last_tinker_2.0.0.2.exe'
ARCHIVE_GOG_WINDOWS_OLD_MD5='7afa966efb4beb5535e19f2d69b245ae'
ARCHIVE_GOG_WINDOWS_OLD_VERSION='1.0-gog2.0.0.2'
ARCHIVE_GOG_WINDOWS_OLD_SIZE='2100000'

ARCHIVE_DOC_DATA_PATH_GOG_WINDOWS='app'
ARCHIVE_DOC_DATA_PATH_GOG_LINUX='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*.txt'

ARCHIVE_GAME_BIN_PATH_GOG_WINDOWS='app'
ARCHIVE_GAME_BIN_PATH_GOG_LINUX='data/noarch/game'
ARCHIVE_GAME_BIN_FILES_GOG_WINDOWS='./*.exe ./*_data/mono ./*_data/managed ./libogg.dll ./libtheora.dll ./steam_api.dll ./steamworksnative.dll ./xinputdotnetpure.dll ./xinputinterface.dll ./collect_debug_info.bat'
ARCHIVE_GAME_BIN_FILES_GOG_LINUX='./*.x86 ./*_Data/Mono ./*_Data/Managed ./libsteam_api.so ./libSteamworksNative.so ./SteamworksNative.dll'

ARCHIVE_GAME_DATA_PATH_GOG_WINDOWS='app'
ARCHIVE_GAME_DATA_PATH_GOG_LINUX='data/noarch/game'
ARCHIVE_GAME_DATA_FILES_GOG_WINDOWS='./*_data'
ARCHIVE_GAME_DATA_FILES_GOG_LINUX='./*_Data'

APP_MAIN_TYPE_GOG_WINDOWS='wine'
APP_MAIN_EXE_GOG_WINDOWS='the last tinker.exe'
APP_MAIN_ICON_GOG_WINDOWS='the last tinker.exe'
APP_MAIN_ICON_RES_GOG_WINDOWS='16 24 32 48 64 128 192 256'
APP_MAIN_ICON_RES_GOG_WINDOWS_OLD='16 24 32 48 64 96 128 192 256'

APP_MAIN_TYPE_GOG_LINUX='native'
APP_MAIN_EXE_GOG_LINUX='the last tinker.x86'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON_GOG_LINUX='*_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES_GOG_LINUX='128'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_GOG_WINDOWS="$PKG_DATA_ID wine"
PKG_BIN_DEPS_GOG_LINUX="$PKG_DATA_ID alsa glu xcursor"

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

# Check that all parts of the installer are present

if [ "$ARCHIVE" = 'ARCHIVE_GOG_WINDOWS' ]; then
	ARCHIVE_MAIN="$ARCHIVE"
	set_archive 'ARCHIVE_PART1' "${ARCHIVE_MAIN}_PART1"
	[ "$ARCHIVE_PART1" ] || set_archive_error_not_found "${ARCHIVE_MAIN}_PART1"
	ARCHIVE="$ARCHIVE_MAIN"
fi

# Use archive specific values for app related variables

use_archive_specific_value 'APP_MAIN_EXE'
use_archive_specific_value 'APP_MAIN_TYPE'
use_archive_specific_value 'APP_MAIN_ICON'
use_archive_specific_value 'APP_MAIN_ICON_RES'

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout

if [ $ARCHIVE = 'ARCHIVE_GOG_WINDOWS' ] || [ $ARCHIVE = 'ARCHIVE_GOG_WINDOWS_OLD' ]; then
	PKG='PKG_BIN'
	extract_and_sort_icons_from 'APP_MAIN'
	move_icons_to 'PKG_DATA'
fi

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

if [ $ARCHIVE = 'ARCHIVE_GOG_LINUX' ]; then
	postinst_icons_linking 'APP_MAIN'
fi
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
