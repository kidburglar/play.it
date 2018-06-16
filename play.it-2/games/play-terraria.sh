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
# Terraria
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='terraria'
GAME_NAME='Terraria'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD'

ARCHIVE_GOG='terraria_en_1_3_5_3_14602.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/terraria'
ARCHIVE_GOG_MD5='c99fdc0ae15dbff1e8147b550db4e31a'
ARCHIVE_GOG_SIZE='490000'
ARCHIVE_GOG_VERSION='1.3.5.3-gog14602'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='gog_terraria_2.17.0.21.sh'
ARCHIVE_GOG_OLD_MD5='90ec196ec38a7f7a5002f5a8109493cc'
ARCHIVE_GOG_OLD_SIZE='487864'
ARCHIVE_GOG_OLD_VERSION='1.3.5.3-gog2.17.0.21'

ARCHIVE_DOC1_PATH='data/noarch/docs'
ARCHIVE_DOC1_FILES='./*'

ARCHIVE_DOC2_PATH='data/noarch/game'
ARCHIVE_DOC2_FILES='./changelog.txt'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./Terraria.bin.x86 ./TerrariaServer.bin.x86 ./lib'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./Terraria.bin.x86_64 ./TerrariaServer.bin.x86_64 ./lib64'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./Content ./*.dll ./System.Windows.Forms.dll.config ./FNA.dll.config ./Terraria ./Terraria.png ./TerrariaServer ./*.exe ./monoconfig ./monomachineconfig ./open-folder'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='Terraria.bin.x86'
APP_MAIN_EXE_BIN64='Terraria.bin.x86_64'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='Terraria.png'
APP_MAIN_ICON_RES='512'

APP_SERVER_ID="$GAME_ID-server"
APP_SERVER_NAME="$GAME_NAME Server"
APP_SERVER_TYPE='native'
APP_SERVER_EXE_BIN32='TerrariaServer.bin.x86'
APP_SERVER_EXE_BIN64='TerrariaServer.bin.x86_64'
APP_SERVER_ICONS_LIST='APP_MAIN_ICON'
APP_SERVER_ICON='Terraria.png'
APP_SERVER_ICON_RES='512'

PACKAGES_LIST='PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glu xcursor libxrandr"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

# Load common functions

target_version='2.3'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	if [ -e "$XDG_DATA_HOME/play.it/libplayit2.sh" ]; then
		PLAYIT_LIB2="$XDG_DATA_HOME/play.it/libplayit2.sh"
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
	organize_data "DOC_${PKG#PKG_}" "$PATH_DOC"
	organize_data "DOC2_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN' 'APP_SERVER'
done

# Build package

postinst_icons_linking 'APP_MAIN'
postinst_icons_linking 'APP_SERVER'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

#print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN64'

exit 0
