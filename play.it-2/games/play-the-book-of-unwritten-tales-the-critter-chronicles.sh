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
# The Book of Unwritten Tales: The Critter Chronicles
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180606.1

# Set game-specific variables

GAME_ID='the-book-of-unwritten-tales-the-critter-chronicles'
GAME_NAME='The Book of Unwritten Tales: The Critter Chronicles'

ARCHIVE_GOG='setup_book_of_unwritten_tales_critter_chronicles_2.1.0.10.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_book_of_unwritten_tales_critter_chronicles'
ARCHIVE_GOG_MD5='eed5cd99d36e5900d0fd5775d0466c22'
ARCHIVE_GOG_VERSION='1.0-gog2.1.0.10'
ARCHIVE_GOG_SIZE='2800000'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./manual.pdf'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./critterchronicles.exe ./alut.dll ./cg.dll ./libogg.dll ./libtheora.dll ./libtheoraplayer.dll ./libvorbis.dll ./libvorbisfile.dll ./lua5.1.dll ./lua51.dll ./ogremain.dll ./ois.dll ./particleuniverse.dll ./plugin_cgprogrammanager.dll ./rendersystem_direct3d9.dll ./plugins.cfg ./resources.cfg'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./kagedata/lang'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./data ./kagedata ./kapedata ./config.xml ./exportedfunctions.lua'

DATA_DIRS='./saves'

APP_WINETRICKS='directx9'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='critterchronicles.exe'
APP_MAIN_ICON='critterchronicles.exe'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n-en"
PKG_L10N_DESCRIPTION='English localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine winetricks"

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

# Extract icons

PKG='PKG_BIN'
icons_get_from_package 'APP_MAIN'
icons_move_to 'PKG_DATA'

# Write launchers

write_launcher 'APP_MAIN'

# Store saved games outside of WINE prefix

saves_path='$WINEPREFIX/drive_c/users/$(whoami)/My Documents/Unwritten Tales - Critter Chronicles/savegames'
pattern='s#init_prefix_dirs "$PATH_DATA" "$DATA_DIRS"#&'
pattern="$pattern\\nif [ ! -e \"$saves_path\" ]; then"
pattern="$pattern\\n\\tmkdir --parents \"${saves_path%/*}\""
pattern="$pattern\\n\\tln --symbolic \"\$PATH_DATA/saves\" \"$saves_path\""
pattern="$pattern\\nfi#"
sed --in-place "$pattern" "${PKG_BIN_PATH}${PATH_BIN}"/*

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
