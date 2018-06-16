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
# Star Wars: Galactic Battlegrounds
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180303.1

# Set game-specific variables

GAME_ID='star-wars-galactic-battlegrounds'
GAME_NAME='Star Wars: Galactic Battlegrounds'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_sw_galactic_battlegrounds_saga_2.0.0.4.exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/star_wars_galactic_battlegrounds_saga'
ARCHIVE_GOG_EN_MD5='6af25835c5f240914cb04f7b4f741813'
ARCHIVE_GOG_EN_VERSION='1.0-gog2.0.0.4'
ARCHIVE_GOG_EN_SIZE='830000'

ARCHIVE_GOG_FR='setup_sw_galactic_battlegrounds_saga_french_2.0.0.4.exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/star_wars_galactic_battlegrounds_saga'
ARCHIVE_GOG_FR_MD5='b30458033e825ad252e2d5b3dc8a7845'
ARCHIVE_GOG_FR_VERSION='1.0-gog2.0.0.4'
ARCHIVE_GOG_FR_SIZE='820000'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./*.pdf'

ARCHIVE_GAME_BIN_PATH='app/game'
ARCHIVE_GAME_BIN_FILES='./*.exe ./libogg-0.dll ./libvorbis-0.dll ./libvorbisfile-3.dll ./win32.dll'

ARCHIVE_GAME_L10N_PATH='app/game'
ARCHIVE_GAME_L10N_FILES='./language*.dll ./campaign/media/1c2s6_end.mm ./data/gamedata_x1.drs ./data/genie*.dat ./data/list*.crx ./data/sounds.*drs ./history ./sound/campaign ./sound/scenario ./scenario/default0.scx ./taunt'

ARCHIVE_GAME_DATA_PATH='app/game'
ARCHIVE_GAME_DATA_FILES='./ai ./campaign ./data ./extras ./music ./random ./savegame ./scenario ./sound ./*.avi'

DATA_DIRS='./ai ./campaign ./random ./savegame ./scenario'
DATA_FILES='./data/*.dat ./player.nf*'

APP_WINETRICKS="vd=\$(xrandr|awk '/\*/ {print \$1}')"

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='battlegrounds.exe'
APP_MAIN_ICON='battlegrounds.exe'
APP_MAIN_ICON_RES='16 32'

APP_ADDON_ID="${GAME_ID}_clone-wars"
APP_ADDON_NAME="$GAME_NAME - Clone Wars"
APP_ADDON_TYPE='wine'
APP_ADDON_EXE='battlegrounds_x1.exe'
APP_ADDON_ICON='battlegrounds_x1.exe'
APP_ADDON_ICON_RES='16 32'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine winetricks"

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
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN' 'APP_ADDON'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_ADDON'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
