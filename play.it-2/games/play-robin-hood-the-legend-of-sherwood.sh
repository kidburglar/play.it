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
# Robin Hood: The Legend of Sherwood
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='robin-hood-the-legend-of-sherwood'
GAME_NAME='Robin Hood: The Legend of Sherwood'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_EN_OLD ARCHIVE_GOG_FR ARCHIVE_GOG_FR_OLD'

ARCHIVE_GOG_EN='setup_robin_hood_-_the_legend_of_sherwood_1.1_(17797).exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/robin_hood'
ARCHIVE_GOG_EN_MD5='e8808cdafc7ea75cbcfaa850275b3dd6'
ARCHIVE_GOG_EN_VERSION='1.1-gog17797'
ARCHIVE_GOG_EN_SIZE='1200000'

ARCHIVE_GOG_EN_OLD='setup_robin_hood_2.0.0.12.exe'
ARCHIVE_GOG_EN_OLD_MD5='9e2452c88f154c5e0306ca98e6b773ef'
ARCHIVE_GOG_EN_OLD_VERSION='1.1-gog2.0.0.12'
ARCHIVE_GOG_EN_OLD_SIZE='1100000'

ARCHIVE_GOG_FR='setup_robin_hood_-_the_legend_of_sherwood_french_1.1_(17797).exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/robin_hood'
ARCHIVE_GOG_FR_MD5='8b19812fb424651fc482cb7a9c5ed665'
ARCHIVE_GOG_FR_VERSION='1.1-gog17797'
ARCHIVE_GOG_FR_SIZE='1200000'

ARCHIVE_GOG_FR_OLD='setup_robin_hood_french_2.1.0.15.exe'
ARCHIVE_GOG_FR_OLD_MD5='f6775cefa54e15141b855d037eafb8d9'
ARCHIVE_GOG_FR_OLD_VERSION='1.1-gog2.1.0.15'
ARCHIVE_GOG_FR_OLD_SIZE='1100000'

ARCHIVE_DOC_L10N_PATH='app'
ARCHIVE_DOC_L10N_FILES='./manual.pdf'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./robin?hood.exe ./binkw32.dll ./fmod.dll ./msvc?90.dll ./sdl.dll ./launch/settings.ini ./data/savegame.exe'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./game.exe ./1036 ./2047 ./data/sounds/fx_0017.sfk ./data/sounds/snd_055.sfk ./data/configuration/profile.cpf ./data/interface ./splash/microids_1024x768.bmp ./data/text/rhlevelsc.red ./data/levels'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./data/robinhood.bks ./data/levels/attack ./data/levels/custom? ./data/levels/day ./data/levels/fog ./data/levels/night ./data/sounds/fx_0019.sfk ./data/configuration/keyset?.cfg ./data/configuration/release.log ./splash/config.txt ./data/text/actors.res ./data/text/rhlevela?.red ./data/text/rhleveld?.red ./data/text/rhlevele?.red ./data/text/rhlevelh?.red ./data/text/rhlevelsa.red ./data/text/rhlevelsb.red ./data/text/rhlevelsd.red ./data/text/rhlevelse.red ./data/text/rhlevelt?.red ./data/text/rhlevelv?.red ./data/sounds/*.wav ./data/sounds/exclamations ./data/sounds/menu ./data/sounds/robin?hood.fxg ./data/animations ./data/characters ./data/musics ./data/robinhood.dic'

CONFIG_FILES='./launch/settings.ini'
CONFIG_DIRS='./data/configuration'
DATA_DIRS='./data/savegame'
DATA_FILES='./campaign.bck'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='game.exe'
APP_MAIN_ICON='robin hood.exe'
APP_MAIN_ICON_RES='16 32'

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
tolower "$PLAYIT_WORKDIR/gamedata"

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
