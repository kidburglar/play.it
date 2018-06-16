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
# Shadow Tactics: Blades of the Shogun
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180424.1

# Set game-specific variables

GAME_ID='shadow-tactics'
GAME_NAME='Shadow Tactics: Blades of the Shogun'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='shadow_tactics_blades_of_the_shogun_en_1_4_4_f_14723.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/shadow_tactics_blades_of_the_shogun'
ARCHIVE_GOG_MD5='93faa090d5bcaa22f0faabd1e32c5909'
ARCHIVE_GOG_SIZE='9600000'
ARCHIVE_GOG_VERSION='1.4.4f-gog14723'
ARCHIVE_GOG_TYPE='mojosetup_unzip'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./Shadow?Tactics ./*_Data/Mono ./*_Data/Plugins'

ARCHIVE_GAME_LIGHTING_PATH='data/noarch/game'
ARCHIVE_GAME_LIGHTING_FILES='./*_Data/GI'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./*_Data'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='export LANG=C'
APP_MAIN_EXE='Shadow Tactics'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICON='*_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_BIN PKG_LIGHTING PKG_DATA'

PKG_LIGHTING_ID="${GAME_ID}-lighting"
PKG_LIGHTING_DESCRIPTION='lighting'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_LIGHTING_ID $PKG_DATA_ID glibc libstdc++ glx gtk2"
PKG_BIN_DEPS_ARCH='lib32-systemd'
PKG_BIN_DEPS_DEB='libudev1'

# Load common functions

target_version='2.7'

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
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_LIGHTING' 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
