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
# Hammerwatch
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='hammerwatch'
GAME_NAME='Hammerwatch'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_HUMBLE'

ARCHIVE_GOG='gog_hammerwatch_2.1.0.7.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/hammerwatch'
ARCHIVE_GOG_MD5='2d1f01b73f43e0b6399ab578c52c6cb6'
ARCHIVE_GOG_SIZE='230000'
ARCHIVE_GOG_VERSION='1.32-gog2.1.0.7'

ARCHIVE_HUMBLE='hammerwatch_linux1.32.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/hammerwatch'
ARCHIVE_HUMBLE_MD5='c31f4053bcde3dc34bc8efe5f232c26e'
ARCHIVE_HUMBLE_SIZE='230000'
ARCHIVE_HUMBLE_VERSION='1.32-humble160405'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN32_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN32_PATH_HUMBLE='Hammerwatch'
ARCHIVE_GAME_BIN32_FILES='./lib ./Hammerwatch.bin.x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_PATH_HUMBLE='Hammerwatch'
ARCHIVE_GAME_BIN64_FILES='./lib64 ./Hammerwatch.bin.x86_64'

ARCHIVE_GAME_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_HUMBLE='Hammerwatch'
ARCHIVE_GAME_DATA_FILES='./editor ./levels ./mono ./assets* ./Farseer* ./Hammerwatch.exe ./Hammerwatch.pdb ./ICS* ./Lidgren* ./Mono* ./mscor* ./Png* ./Run* ./SDL2* ./Steam* ./System* ./Tilted*'

CONFIG_FILES='./*.xml'
DATA_FILES='./*.log ./*.txt'
DATA_DIRS='./levels ./logs'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='Hammerwatch.bin.x86'
APP_MAIN_EXE_BIN64='Hammerwatch.bin.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICON='./Hammerwatch.exe'
APP_MAIN_ICON_RES='16 32 48 96 256'

PACKAGES_LIST='PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_MEDIA_ID $PKG_DATA_ID glibc libstdc++6 sdl2"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

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
	organize_data "DOC_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_DATA'
extract_and_sort_icons_from 'APP_MAIN'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Copy 'Hammerwatch.exe' into game prefix

pattern='s/cp --parents --remove-destination "$APP_EXE" "$PATH_PREFIX"/&\n'
pattern="$pattern\\tcd \"\$PATH_GAME\"\\n"
pattern="$pattern\\tcp --parents --remove-destination 'Hammerwatch.exe' \"\$PATH_PREFIX\"/"
for file in "${PKG_BIN32_PATH}${PATH_BIN}/$GAME_ID" \
            "${PKG_BIN64_PATH}${PATH_BIN}/$GAME_ID"
do
	sed --in-place "$pattern" "$file"
done

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "${PLAYIT_WORKDIR}"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN64'

exit 0
