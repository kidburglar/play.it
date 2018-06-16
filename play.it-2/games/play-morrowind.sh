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
# The Elder Scrolls III: Morrowind
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='morrowind'
GAME_NAME='The Elder Scrolls III: Morrowind'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_tes_morrowind_goty_2.0.0.7.exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/the_elder_scrolls_iii_morrowind_goty_edition'
ARCHIVE_GOG_EN_MD5='3a027504a0e4599f8c6b5b5bcc87a5c6'
ARCHIVE_GOG_EN_VERSION='1.6.1820-gog2.0.0.7'
ARCHIVE_GOG_EN_SIZE='2300000'

ARCHIVE_GOG_FR='setup_tes_morrowind_goty_french_2.0.0.7.exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/the_elder_scrolls_iii_morrowind_goty_edition'
ARCHIVE_GOG_FR_MD5='2aee024e622786b2cb5454ff074faf9b'
ARCHIVE_GOG_FR_VERSION='1.6.1820-gog2.0.0.7'
ARCHIVE_GOG_FR_SIZE='2300000'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./*.pdf'

ARCHIVE_DOC_L10N_PATH='app'
ARCHIVE_DOC_L10N_FILES='./*.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.exe ./binkw32.dll ./morrowind.ini ./tes?construction?set.cnt ./tes?construction?set.hlp'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./data?files/bookart/*_377_253.tga ./data?files/bookart/empire?small*.bmp ./data?files/*.bsa ./data?files/*.esm ./data?files/sound/vo ./data?files/splash ./data?files/textures/menu_credits* ./data?files/textures/menu_*game* ./data?files/textures/menu_options* ./data?files/textures/menu_return* ./data?files/textures/tx_menubook_cancel* ./data?files/textures/tx_menubook_close* ./data?files/textures/tx_menubook_journal* ./data?files/textures/tx_menubook_next* ./data?files/textures/tx_menubook_prev* ./data?files/textures/tx_menubook_take* ./data?files/textures/tx_menubook_topics* ./data?files/video/bethesda?logo.bik ./data?files/video/bm_bearhunt?.bik ./data?files/video/bm_ceremony?.bik ./data?files/video/bm_endgame.bik ./data?files/video/bm_frostgiant?.bik ./data?files/video/mw_cavern.bik ./data?files/video/mw_credits.bik ./data?files/video/mw_end.bik ./data?files/video/mw_intro.bik ./data?files/video/mw_logo.bik ./data?files/meshes/r/*atronach_frost.*'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./data?files/bookart/barbarian_*.tga ./data?files/bookart/boethiah_256.tga ./data?files/bookart/divinemetaphysics_text?.tga ./data?files/bookart/divinemetaphysics.tga ./data?files/bookart/efoulkefirmament_*.tga ./data?files/bookart/eggoftime_illust?.tga ./data?files/bookart/*.htm ./data?files/bookart/magicstonemap4.dds ./data?files/bookart/moragtong.tga ./data?files/bookart/secret_of_dwemer?.tga ./data?files/bookart/*.ttf ./data?files/bookart/tx_icon_waterbreath.bmp ./data?files/*.esp ./data?files/fonts ./data?files/icons ./data?files/meshes ./data?files/music ./data?files/sound/cr ./data?files/sound/fx ./data?files/textures ./data?files/*.txt ./data?files/video/bm_were*.bik ./data?files/video/mw_menu.bik ./knife.ico'

ARCHIVE_GAME_DATAFILES_DATA_PATH='app/_officialplugins/_unpacked_files'
ARCHIVE_GAME_DATAFILES_DATA_FILES='./*'

CONFIG_FILES='./*.ini'
DATA_DIRS='./saves'
DATA_FILES='./ProgramFlow.txt ./Warnings.txt ./Journal.htm'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='morrowind launcher.exe'
APP_MAIN_ICON='morrowind.exe'
APP_MAIN_ICON_RES='16 32'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ID="$GAME_ID"
PKG_BIN_ARCH='32'
PKG_BIN_ID_GOG_EN="${PKG_BIN_ID}-en"
PKG_BIN_ID_GOG_FR="${PKG_BIN_ID}-fr"
PKG_BIN_PROVIDE="$PKG_BIN_ID"
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine"
PKG_BIN_DESCRIPTION_GOG_EN='English version'
PKG_BIN_DESCRIPTION_GOG_FR='French version'

# Load common functions

target_version='2.4'

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
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_DATA'
organize_data 'GAME_DATAFILES_DATA' "$PATH_GAME/data files"

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Fix .bsa/.esm dates on French version

if [ "$ARCHIVE" = 'ARCHIVE_GOG_FR' ]; then
	(
		cd "${PKG_L10N_PATH}${PATH_GAME}/data files"
		touch --date='2002-06-21 17:31:46.000000000 +0200' 'morrowind.bsa'
		touch --date='2002-07-17 18:59:22.000000000 +0200' 'morrowind.esm'
		touch --date='2002-10-29 21:22:06.000000000 +0100' 'tribunal.bsa'
		touch --date='2003-06-26 20:05:06.000000000 +0200' 'tribunal.esm'
		touch --date='2003-05-01 13:37:30.000000000 +0200' 'bloodmoon.bsa'
		touch --date='2003-07-07 17:27:56.000000000 +0200' 'bloodmoon.esm'
	)
fi

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
