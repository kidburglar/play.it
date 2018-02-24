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
# The Book of Unwritten Tales
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='the-book-of-unwritten-tales'
GAME_NAME='The Book of Unwritten Tales'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_book_of_unwritten_tales_2.0.0.4.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_book_of_unwritten_tales'
ARCHIVE_GOG_MD5='984e8f16cc04a2a27aea8b0d7ada1c1e'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.4'
ARCHIVE_GOG_SIZE='5900000'
ARCHIVE_GOG_PART1='setup_book_of_unwritten_tales_2.0.0.4-1.bin'
ARCHIVE_GOG_PART1_MD5='4ea0eccb7ca2f77c301e79412ff1e214'
ARCHIVE_GOG_PART1_TYPE='innosetup'
ARCHIVE_GOG_PART2='setup_book_of_unwritten_tales_2.0.0.4-2.bin'
ARCHIVE_GOG_PART2_MD5='95e52d38b6c1548ac311284c539a4c52'
ARCHIVE_GOG_PART2_TYPE='innosetup'
ARCHIVE_GOG_PART3='setup_book_of_unwritten_tales_2.0.0.4-3.bin'
ARCHIVE_GOG_PART3_MD5='7290d78ecbec866e46401e4c9d3549cf'
ARCHIVE_GOG_PART3_TYPE='innosetup'

ARCHIVE_DOC_PATH='tmp'
ARCHIVE_DOC_FILES='./*eula.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./bout.exe ./alut.dll ./cg.dll ./libogg.dll ./libtheora.dll ./libtheoraplayer.dll ./libvorbis.dll ./libvorbisfile.dll ./lua5.1.dll ./lua51.dll ./ogremain.dll ./ois.dll ./particleuniverse.dll ./plugin_cgprogrammanager.dll ./rendersystem_direct3d9.dll ./plugins.cfg ./resources.cfg'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./kagedata/lang'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./data ./kagedata ./kapedata ./config.xml ./exportedfunctions.lua'

APP_WINETRICKS='directx9'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='bout.exe'
APP_MAIN_ICON='bout.exe'
APP_MAIN_ICON_RES='16 32 48 64'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n-en"
PKG_L10N_DESCRIPTION='English localization'

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
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Check that all parts of the installer are present

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_PART1' "${ARCHIVE_MAIN}_PART1"
[ "$ARCHIVE_PART1" ] || set_archive_error_not_found "${ARCHIVE_MAIN}_PART1"
set_archive 'ARCHIVE_PART2' "${ARCHIVE_MAIN}_PART2"
[ "$ARCHIVE_PART1" ] || set_archive_error_not_found "${ARCHIVE_MAIN}_PART2"
set_archive 'ARCHIVE_PART3' "${ARCHIVE_MAIN}_PART3"
[ "$ARCHIVE_PART1" ] || set_archive_error_not_found "${ARCHIVE_MAIN}_PART3"
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
