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
# System Shock 2
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180413.1

# Set game-specific variables

GAME_ID='system-shock-2'
GAME_NAME='System Shock 2'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER'

ARCHIVE_GOG='setup_system_shock_2_2.46_update_2_(18733).exe'
ARCHIVE_GOG_MD5='39fab64451ace95966988bb90c7bb17e'
ARCHIVE_GOG_SIZE='680000'
ARCHIVE_GOG_VERSION='2.46.2-gog18733'

ARCHIVE_GOG_OLD='setup_system_shock_2_2.46_update_(18248).exe'
ARCHIVE_GOG_OLD_MD5='b76803e4a632b58527eada8993999143'
ARCHIVE_GOG_OLD_SIZE='690000'
ARCHIVE_GOG_OLD_VERSION='2.46.1-gog18248'

ARCHIVE_GOG_OLDER='setup_system_shock_2_2.46_nd_(11004).exe'
ARCHIVE_GOG_OLDER_MD5='98c3d01d53bb2b0dc25d7ed7093a67d3'
ARCHIVE_GOG_OLDER_SIZE='680000'
ARCHIVE_GOG_OLDER_VERSION='2.46-gog11004'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./*.pdf ./*.txt ./*.wri ./doc ./editor/*.txt'

ARCHIVE_GAME1_BIN_PATH='app'
ARCHIVE_GAME1_BIN_FILES='./*.ax ./*.bnd ./*.cfg ./*.exe ./*.osm ./7z.dll ./d3dx9_43.dll ./ffmpeg.dll ./fmsel.dll ./ir41_32.dll ./ir50_32.dll ./lgvid.dll ./msvcrt40.dll ./editor/*.cfg ./editor/*.dll ./editor/*.exe ./microsoft.vc90.crt'

ARCHIVE_GAME2_BIN_PATH='app/__support/app'
ARCHIVE_GAME2_BIN_FILES='./*.cfg ./*.ini'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./*.bin ./*.dif ./*.dml ./ilist.* ./patch* ./binds ./data ./sq_scripts'

CONFIG_FILES='./*.bnd ./*.cfg ./*.ini'
DATA_DIRS='./current ./save_0 ./save_1 ./save_2 ./save_3 ./save_4 ./save_5 ./save_6 ./save_7 ./save_8 ./save_9 ./save_10 ./save_11 ./save_12 ./save_13 ./save_14'
DATA_FILES='./*.log'

APP_WINETRICKS="vd=\$(xrandr|grep '\*'|awk '{print \$1}')"

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='shock2.exe'
APP_MAIN_ICON='shock2.exe'
APP_MAIN_ICON_RES='16 32 48 64'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine winetricks xrandr"

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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"   "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}"  "$PATH_GAME"
	organize_data "GAME1_${PKG#PKG_}" "$PATH_GAME"
	organize_data "GAME2_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
