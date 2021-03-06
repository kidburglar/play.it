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
# Runner
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180424.2

# Set game-specific variables

GAME_ID='runner'
GAME_NAME='Runner'

ARCHIVE_GOG='gog_bit_trip_runner_2.0.0.1.sh'
ARCHIVE_GOG_MD5='b6f0fe70e1a2d9408967b8fd6bd881e1'
ARCHIVE_GOG_VERSION='1.0.5-gog2.0.0.1'
ARCHIVE_GOG_SIZE='120000'

ARCHIVE_DOC0_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC0_DATA_FILES='./*'

ARCHIVE_DOC1_DATA_PATH='data/noarch/game/bit.trip.runner-1.0-32'
ARCHIVE_DOC1_DATA_FILES='./README* ./*.txt'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game/bit.trip.runner-1.0-32'
ARCHIVE_GAME_BIN32_FILES='./bit.trip.runner/Effects ./bit.trip.runner/Layouts ./bit.trip.runner/Sounds ./bit.trip.runner/Models ./bit.trip.runner/bit.trip.runner'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game/bit.trip.runner-1.0-64'
ARCHIVE_GAME_BIN64_FILES='./bit.trip.runner/Effects ./bit.trip.runner/Layouts ./bit.trip.runner/Sounds ./bit.trip.runner/Models ./bit.trip.runner/bit.trip.runner'

ARCHIVE_GAME_DATA_PATH='data/noarch/game/bit.trip.runner-1.0-32'
ARCHIVE_GAME_DATA_FILES='./bit.trip.runner/Shaders ./bit.trip.runner/RUNNER.png ./bit.trip.runner/Fonts ./bit.trip.runner/Textures2d'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='bit.trip.runner/bit.trip.runner'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='./bit.trip.runner/RUNNER.png'
APP_MAIN_ICON_RES='48'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc glx xcursor sdl openal"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

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

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

sed --in-place 's|"./$APP_EXE" \($APP_OPTIONS $@\)|cd "${APP_EXE%/*}"\n"./${APP_EXE##*/}" \1|' "${PKG_BIN32_PATH}${PATH_BIN}/$GAME_ID" "${PKG_BIN64_PATH}${PATH_BIN}/$GAME_ID"

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
