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
# Unmechanical
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='unmechanical'
GAME_NAME='Unmechanical'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_unmechanical_2.1.0.4.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/unmechanical'
ARCHIVE_GOG_MD5='44453abb32e21b94e9731938486c71f7'
ARCHIVE_GOG_SIZE='1600000'
ARCHIVE_GOG_VERSION='2.0-gog2.1.0.4'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./Binaries ./Engine'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./UDKGame ./UnmechanicalIcon.bmp'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='pulseaudio --start'
APP_MAIN_EXE='Binaries/Linux/UDKGame-Linux'
APP_MAIN_LIBS='lib'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='UnmechanicalIcon.bmp'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID glibc libstdc++ glu xcursor openal sdl2 pulseaudio"

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

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_DATA'
res="$APP_MAIN_ICON_RES"
PATH_ICON="$PATH_ICON_BASE/${res}x${res}/apps"
extract_icon_from "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON"
mkdir --parents "${PKG_DATA_PATH}${PATH_ICON}"
mv "$PLAYIT_WORKDIR/icons/$(basename ${APP_MAIN_ICON%.bmp}.png)" "${PKG_DATA_PATH}${PATH_ICON}/$GAME_ID.png"


rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Set working directory to the directory containing the game binary before running it

pattern1='s|^cd "$PATH_PREFIX"$|cd "$PATH_PREFIX/${APP_EXE%/*}"|'
pattern2='s|^"\./$APP_EXE"|"./${APP_EXE##*/}"|'
file="${PKG_BIN_PATH}${PATH_BIN}/$GAME_ID"
sed --in-place "$pattern1;$pattern2" "$file"

# Build package

write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
