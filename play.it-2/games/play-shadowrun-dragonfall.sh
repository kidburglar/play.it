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
# Shadowrun: Dragonfall
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180227.1

# Set game-specific variables

GAME_ID='shadowrun-dragonfall'
GAME_NAME='Shadowrun: Dragonfall'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_HUMBLE'

ARCHIVE_GOG='gog_shadowrun_dragonfall_director_s_cut_2.6.0.11.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/shadowrun_dragonfall_directors_cut'
ARCHIVE_GOG_MD5='ee3db5bc8554852337b063b993f66012'
ARCHIVE_GOG_SIZE='7200000'
ARCHIVE_GOG_VERSION='2.0.9-gog2.6.0.11'

ARCHIVE_HUMBLE='shadowrun-dragonfall-linux.tar.gz_2.0.9.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/shadowrun-dragonfall-directors-cut'
ARCHIVE_HUMBLE_MD5='49e88d170e086c01c4dcb19154875cca'
ARCHIVE_HUMBLE_VERSION='2.0.9-humble1'
ARCHIVE_HUMBLE_SIZE='7200000'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_BIN_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN_PATH_HUMBLE='./*'
ARCHIVE_GAME_BIN_FILES='./Dragonfall ./Dragonfall.sh ./ShadowrunEditor ./Dragonfall_Data/*/x86'

ARCHIVE_GAME_DATA_BERLIN_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_BERLIN_PATH_HUMBLE='./*'
ARCHIVE_GAME_DATA_BERLIN_FILES='./Dragonfall_Data/StreamingAssets/*/berlin'

ARCHIVE_GAME_DATA_SEATTLE_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_SEATTLE_PATH_HUMBLE='./*'
ARCHIVE_GAME_DATA_SEATTLE_FILES='./Dragonfall_Data/StreamingAssets/*/seattle'

ARCHIVE_GAME_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_HUMBLE='./*'
ARCHIVE_GAME_DATA_FILES='./Dragonfall_Data'

DATA_DIRS='./DumpBox ./logs'
DATA_FILES='./Dragonfall ./ShadowrunEditor ./Dragonfall.sh'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='./Dragonfall'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='./Dragonfall_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_DATA_BERLIN PKG_DATA_SEATTLE PKG_DATA PKG_BIN'

PKG_DATA_BERLIN_ID="${GAME_ID}-data-berlin"
PKG_DATA_BERLIN_DESCRIPTION='data - Berlin'

PKG_DATA_SEATTLE_ID="${GAME_ID}-data-seattle"
PKG_DATA_SEATTLE_DESCRIPTION='data - Seattle'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_BERLIN $PKG_DATA_SEATTLE $PKG_DATA_ID glu xcursor libxrandr alsa"

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
if [ "$ARCHIVE" = 'ARCHIVE_HUMBLE' ]; then
	ARCHIVE_HUMBLE_TYPE='tar.gz'
	extract_data_from "$PLAYIT_WORKDIR/gamedata"/*.tar.gz
	rm --recursive --force "$PLAYIT_WORKDIR/gamedata/__MACOSX"
	rm "$PLAYIT_WORKDIR/gamedata"/*.tar.gz
fi

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_DATA_BERLIN'
organize_data 'GAME_DATA_BERLIN' "$PATH_GAME"

PKG='PKG_DATA_SEATTLE'
organize_data 'GAME_DATA_SEATTLE' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC'       "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN' 'PKG_DATA_BERLIN' 'PKG_DATA_SEATTLE'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
