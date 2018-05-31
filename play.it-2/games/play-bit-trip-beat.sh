#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2018, Antoine Le Gonidec
# Copyright (c) 2018, Solène Huault
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
# Bit Trip Beat
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180531.1

# Set game-specific variables

GAME_ID='bit-trip-beat'
GAME_NAME='BIT.TRIP BEAT'

ARCHIVE_GOG='gog_bit_trip_beat_2.0.0.1.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/bittrip_beat'
ARCHIVE_GOG_MD5='32b6fd23c32553aa7c50eaf4247ba664'
ARCHIVE_GOG_VERSION='1.0.5-gog2.0.0.1'
ARCHIVE_GOG_SIZE='120000'

ARCHIVE_DOC0_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC0_DATA_FILES='./*'

ARCHIVE_DOC1_DATA_PATH='data/noarch/game/bit.trip.beat-1.0-32'
ARCHIVE_DOC1_DATA_FILES='./README* ./*.txt'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game/bit.trip.beat-1.0-32'
ARCHIVE_GAME_BIN32_FILES='./bit.trip.beat/Effects ./bit.trip.beat/Sounds ./bit.trip.beat/Models ./bit.trip.beat/bit.trip.beat'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game/bit.trip.beat-1.0-64'
ARCHIVE_GAME_BIN64_FILES='./bit.trip.beat/Effects ./bit.trip.beat/Sounds ./bit.trip.beat/Models ./bit.trip.beat/bit.trip.beat'

ARCHIVE_GAME_DATA_PATH='data/noarch/game/bit.trip.beat-1.0-32'
ARCHIVE_GAME_DATA_FILES='./bit.trip.beat/Shaders ./bit.trip.beat/BEAT.png ./bit.trip.beat/Fonts ./bit.trip.beat/Textures'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='bit.trip.beat/bit.trip.beat'
APP_MAIN_ICON='bit.trip.beat/BEAT.png'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc glx xcursor sdl1.2 openal"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

# Load common functions

target_version='2.8'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	for path in\
		'./'\
		"$XDG_DATA_HOME/play.it/"\
		"$XDG_DATA_HOME/play.it/play.it-2/lib/"\
		'/usr/local/share/games/play.it/'\
		'/usr/local/share/play.it/'\
		'/usr/share/games/play.it/'\
		'/usr/share/play.it/'
	do
		if [ -z "$PLAYIT_LIB2" ] && [ -e "$path/libplayit2.sh" ]; then
			PLAYIT_LIB2="$path/libplayit2.sh"
			break
		fi
	done
	if [ -z "$PLAYIT_LIB2" ]; then
		printf '\n\033[1;31mError:\033[0m\n'
		printf 'libplayit2.sh not found.\n'
		return 1
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

pattern='s|"./$APP_EXE" \($APP_OPTIONS $@\)|cd "${APP_EXE%/*}"\n"./${APP_EXE##*/}" \1|'
sed --in-place "$pattern" "${PKG_BIN32_PATH}${PATH_BIN}/$GAME_ID" "${PKG_BIN64_PATH}${PATH_BIN}/$GAME_ID"

# Build package

PKG='PKG_DATA'
icons_linking_postinst 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
