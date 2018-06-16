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
# King’s Bounty: The Legend
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='kings-bounty-the-legend'
GAME_NAME='King’s Bounty: The Legend'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_kings_bounty_the_legend_1.7_(15542).exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/kings_bounty_the_legend'
ARCHIVE_GOG_EN_MD5='f7a9defe0fd96a7f8d6dff6ed7828242'
ARCHIVE_GOG_EN_TYPE='innosetup'
ARCHIVE_GOG_EN_VERSION='1.7-gog15542'
ARCHIVE_GOG_EN_SIZE='6000000'
ARCHIVE_GOG_EN_PART1='setup_kings_bounty_the_legend_1.7_(15542)-1.bin'
ARCHIVE_GOG_EN_PART1_MD5='04fb818107e4bfe7aeae449778e88dd9'
ARCHIVE_GOG_EN_PART1_TYPE='innosetup'

ARCHIVE_GOG_FR='setup_kings_bounty_the_legend_french_1.7_(15542).exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/kings_bounty_the_legend'
ARCHIVE_GOG_FR_MD5='646fdfacadc498826be127fe6703f259'
ARCHIVE_GOG_FR_TYPE='innosetup'
ARCHIVE_GOG_FR_VERSION='1.7-gog15542'
ARCHIVE_GOG_FR_SIZE='6000000'
ARCHIVE_GOG_FR_PART1='setup_kings_bounty_the_legend_french_1.7_(15542)-1.bin'
ARCHIVE_GOG_FR_PART1_MD5='907882679fb7050e172994d36730454a'
ARCHIVE_GOG_FR_PART1_TYPE='innosetup'

ARCHIVE_DOC_L10N_PATH='app'
ARCHIVE_DOC_L10N_FILES='./readme.rtf ./manual.pdf'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.dll ./kb.exe ./data/*.ini ./data/fonts.cfg'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./data/app.ini ./data/loc_data.kfs ./sessions/base/loc_ses.kfs'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./curver.txt ./data/animation.kfs ./data/data.kfs ./data/interface_textures.kfs ./data/models.kfs ./data/sky.kfs ./data/sounds.kfs ./data/textures.kfs ./data/calibri.ttf ./data/music ./data/video ./sessions/base/ses.kfs ./sessions/base/locations'

CONFIG_FILES='./data/*.ini ./data/fonts.cfg'

APP_WINETRICKS='d3dx9'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='kb.exe'
APP_MAIN_ICON='kb.exe'
APP_MAIN_ICON_RES='16 24 32 48'

PACKAGES_LIST='PKG_L10N PKG_DATA PKG_BIN'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine"

# Load common functions

target_version='2.3'

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

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_PART1' "${ARCHIVE_MAIN}_PART1"
[ "$ARCHIVE_PART1" ] || set_archive_error_not_found "${ARCHIVE_MAIN}_PART1"
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"   "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}"  "$PATH_GAME"
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
