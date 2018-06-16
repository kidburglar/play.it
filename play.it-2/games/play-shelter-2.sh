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
# Shelter 2 + Mountains
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='shelter-2'
GAME_NAME='Shelter 2'

ARCHIVES_LIST='ARCHIVE_MOUNTAINS_GOG ARCHIVE_GOG'

ARCHIVE_MOUNTAINS_GOG='gog_shelter_2_mountains_dlc_2.0.0.1.sh'
ARCHIVE_MOUNTAINS_GOG_URL='https://www.gog.com/game/shelter_2_mountains'
ARCHIVE_MOUNTAINS_GOG_MD5='ffe25b4ac5d75b9a30ed983634397d85'
ARCHIVE_MOUNTAINS_GOG_SIZE='2500000'
ARCHIVE_MOUNTAINS_GOG_VERSION='1.0-gog2.0.0.1'
ARCHIVE_MOUNTAINS_GOG_TYPE='mojosetup'

ARCHIVE_GOG='gog_shelter_2_2.5.0.10.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/shelter_2'
ARCHIVE_GOG_MD5='f2bf2e188667133ad117b5bff846e66e'
ARCHIVE_GOG_SIZE='2200000'
ARCHIVE_GOG_VERSION='20150708-gog2.5.0.10'
ARCHIVE_GOG_TYPE='mojosetup'

DATA_DIRS='./logs'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./Shelter2.x86 ./Shelter2_Data/Mono ./Shelter2_Data/Plugins'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./Shelter2_Data/level* ./Shelter2_Data/mainData ./Shelter2_Data/PlayerConnectionConfigFile ./Shelter2_Data/Resources ./Shelter2_Data/resources.assets ./Shelter2_Data/ScreenSelector.png ./Shelter2_Data/sharedassets* ./Shelter2_Data/Managed'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='Shelter2.x86'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='*_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID glibc libstdc++ glu xcursor"

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
	organize_data "DOC_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "${PLAYIT_WORKDIR}"

# Print instructions

print_instructions

exit 0
