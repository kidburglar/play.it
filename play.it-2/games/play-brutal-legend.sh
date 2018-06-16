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
# Brütal Legend
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='brutal-legend'
GAME_NAME='Brütal Legend'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_HUMBLE'

ARCHIVE_GOG='gog_brutal_legend_2.0.0.3.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/brutal_legend'
ARCHIVE_GOG_MD5='f5927fb8b3959c52e2117584475ffe49'
ARCHIVE_GOG_SIZE='8800000'
ARCHIVE_GOG_TYPE='mojosetup_unzip'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.3'

ARCHIVE_HUMBLE='BrutalLegend-Linux-2013-06-15-setup.bin'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/brutal-legend'
ARCHIVE_HUMBLE_MD5='cbda6ae12aafe20a76f4d45367430d32'
ARCHIVE_HUMBLE_SIZE='8800000'
ARCHIVE_HUMBLE_TYPE='mojosetup_unzip'
ARCHIVE_HUMBLE_VERSION='1.0-humble130616'

ARCHIVE_DOC_DATA_PATH_GOG='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN_PATH_HUMBLE='data'
ARCHIVE_GAME_BIN_FILES='./Buddha.bin.x86 ./lib ./DFCONFIG'

ARCHIVE_GAME_AUDIO_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_AUDIO_PATH_HUMBLE='data'
ARCHIVE_GAME_AUDIO_FILES='./Win'

ARCHIVE_GAME_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_HUMBLE='data'
ARCHIVE_GAME_DATA_FILES='./Buddha.png ./Data ./Linux ./OGL'

DATA_FILES='./DFCONFIG'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='Buddha.bin.x86'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='Buddha.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_AUDIO PKG_DATA PKG_BIN'

PKG_AUDIO_ID="${GAME_ID}-audio"
PKG_AUDIO_DESCRIPTION='audio'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_AUDIO_ID $PKG_DATA_ID glibc libstdc++ glu sdl2"

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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_AUDIO' 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

#print instructions

print_instructions

exit 0
