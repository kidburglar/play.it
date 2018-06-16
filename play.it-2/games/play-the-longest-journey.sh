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
# The Longest Journey
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='the-longest-journey'
GAME_NAME='The Longest Journey'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_the_longest_journey_2.0.0.12.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_longest_journey'
ARCHIVE_GOG_MD5='89b3cae144856579ed5fee10ecc76154'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.12'
ARCHIVE_GOG_SIZE='1900000'

ARCHIVE_DOC1_DATA_PATH='tmp'
ARCHIVE_DOC1_DATA_FILES='./*txt'

ARCHIVE_DOC2_DATA_PATH='app'
ARCHIVE_DOC2_DATA_FILES='./*txt ./*.pdf ./*.html ./tlj_faq_files'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.exe ./*.ini ./dx_module.dll ./l_module.dll ./msvcirt.dll ./binkw32.dll ./mfc42.dll ./smackw32.dll ./s_module.dll ./w_module.dll ./msvcp60.dll'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./08 ./12 ./14 ./16 ./17 ./18 ./19 ./1a ./1b ./1c ./1d ./1e ./1f ./20 ./21 ./22 ./23 ./24 ./25 ./26 ./27 ./28 ./29 ./2a ./2b ./2c ./2d ./2e ./2f ./30 ./31 ./32 ./33 ./34 ./35 ./36 ./37 ./38 ./39 ./3a ./3b ./3c ./3d ./3e ./3f ./40 ./41 ./42 ./43 ./44 ./45 ./46 ./47 ./48 ./49 ./4a ./4b ./4c ./4d ./4e ./4f ./50 ./51 ./52 ./53 ./54 ./55 ./56 ./57 ./58 ./59 ./5a ./5b ./5c ./5d ./5e ./5f ./60 ./61 ./62 ./63 ./64 ./65 ./66 ./67 ./68 ./69 ./6a ./6b ./6c ./6d ./6e ./6f ./70 ./71 ./72 ./73 ./74 ./75 ./76 ./77 ./78 ./79 ./7a ./7b ./7c ./data1.tag ./fonts ./global ./static ./station_fix ./x.xarc'

DATA_DIRS='./save'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='game.exe'
APP_MAIN_ICON='game.exe'
APP_MAIN_ICON_RES='16 32 48'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, wine32-development | wine32 | wine-bin | wine-i386 | wine-staging-i386, wine:amd64 | wine"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID wine"

# Load common functions

target_version='2.1'

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
	organize_data "DOC1_${PKG#PKG_}" "$PATH_DOC"
	organize_data "DOC2_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'
sed --in-place 's#cp --force --recursive --symbolic-link --update "$PATH_GAME"/\* "$PATH_PREFIX"#&\n\twine "C:\\\\$GAME_ID\\\\tljregfix.exe"#' "${PKG_BIN_PATH}${PATH_BIN}/$GAME_ID"

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
