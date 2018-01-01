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
# Pharaoh
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20170923.1

# Set game-specific variables

GAME_ID='pharaoh'
GAME_NAME='Pharaoh'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_pharaoh_gold_2.1.0.15.exe'
ARCHIVE_GOG_MD5='62298f00f1f2268c8d5004f5b2e9fc93'
ARCHIVE_GOG_SIZE='810000'
ARCHIVE_GOG_VERSION='2.1-gog2.1.0.15'

ARCHIVE_DOC1_DATA_PATH='tmp'
ARCHIVE_DOC1_DATA_FILES='./*.txt'

ARCHIVE_DOC2_DATA_PATH='app'
ARCHIVE_DOC2_DATA_FILES='./*.pdf ./mission?editor?guide.txt ./readme.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.asi ./*.exe ./*.ini ./*.m3d ./*.tsk ./binkw32.dll ./mss16.dll ./mss32.dll ./smackw32.dll'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./*.emp ./*.eng ./*.inf ./*.pak ./cleoicon.ico ./setup.ico ./auto?reason?phrases.txt ./campaign.txt ./eventmsg.txt ./figure_*.txt ./music.txt ./pharaoh_*.txt ./tax_*.txt ./trade_recommends.txt ./audio ./binks ./data ./maps'

CONFIG_FILES='./*.ini'
DATA_DIRS='./save'
DATA_FILES='./*.txt'

APP_WINETRICKS='vd=1024x768'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='pharaoh.exe'
APP_MAIN_ICON1='pharaoh.exe'
APP_MAIN_ICON1_RES='16'
APP_MAIN_ICON2='cleoicon.ico'
APP_MAIN_ICON2_RES='32'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, wine32-development | wine32 | wine-bin | wine-i386 | wine-staging-i386, wine:amd64 | wine"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID wine"

# Load common functions

target_version='2.1'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	if [ -e "$XDG_DATA_HOME/play.it/play.it-2/lib/libplayit2.sh" ]; then
		PLAYIT_LIB2="$XDG_DATA_HOME/play.it/play.it-2/lib/libplayit2.sh"
	elif [ -e './libplayit2.sh' ]; then
		PLAYIT_LIB2='./libplayit2.sh'
	else
		printf '\n\033[1;31mError:\033[0m\n'
		printf 'libplayit2.sh not found.\n'
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC1_${PKG#PKG_}" "$PATH_DOC"
	organize_data "DOC2_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
APP_MAIN_ICON="$APP_MAIN_ICON1"
APP_MAIN_ICON_RES="$APP_MAIN_ICON1_RES"
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

res="$APP_MAIN_ICON2_RES"
PATH_ICON="$PATH_ICON_BASE/${res}x${res}/apps"
ln --symbolic "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON2" "${PKG_DATA_PATH}${PATH_GAME}/${APP_MAIN_ICON2%.ico}.bmp"
extract_icon_from "${PKG_DATA_PATH}${PATH_GAME}/${APP_MAIN_ICON2%.ico}.bmp"
mkdir --parents "${PKG_DATA_PATH}${PATH_ICON}"
mv "$PLAYIT_WORKDIR/icons/${APP_MAIN_ICON2%.ico}.png" "${PKG_DATA_PATH}${PATH_ICON}/$GAME_ID.png"
rm "${PKG_DATA_PATH}${PATH_GAME}/${APP_MAIN_ICON2%.ico}.bmp"

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
