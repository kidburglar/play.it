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
# Stories: The Path of Destinies
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='stories-the-path-of-destinies'
GAME_NAME='Stories: The Path of Destinies'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_stories_-_the_path_of_destinies_0.0.13825_(16929).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/stories_the_path_of_destinies'
ARCHIVE_GOG_MD5='6f81dbadddbb4b30b4edda9ced9ddef8'
ARCHIVE_GOG_VERSION='0.0.13825-gog16929'
ARCHIVE_GOG_SIZE='1700000'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./engine ./language_setup.exe ./language_setup.ini ./storiesstart.exe ./stories/binaries'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./language_setup.png ./stories/content'

APP_WINETRICKS='csmt=on'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='stories/binaries/win64/stories.exe'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='stories/binaries/win64/stories.exe'
APP_MAIN_ICON_RES='16 24 32 48'

APP_LANGUAGE_ID="${GAME_ID}_language"
APP_LANGUAGE_NAME="$GAME_NAME - Language"
APP_LANGUAGE_TYPE='wine'
APP_LANGUAGE_EXE='language_setup.exe'
APP_LANGUAGE_ICONS_LIST='APP_LANGUAGE_ICON'
APP_LANGUAGE_ICON='language_setup.png'
APP_LANGUAGE_ICON_RES='256'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS="$PKG_DATA_ID wine winetricks"

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
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_LANGUAGE'

# Store saved games and settings outside of WINE prefix

save_path='$WINEPREFIX/drive_c/users/$(whoami)/Local Settings/Application Data/Stories/Saved/SaveGames'
pattern='s|cp --force --recursive --symbolic-link --update "$PATH_GAME"/\* "$PATH_PREFIX"|&\n'
pattern="$pattern\tmkdir --parents \"${save_path%/*}\"\n"
pattern="$pattern\tmkdir --parents \"\$PATH_DATA/saves\"\n"
pattern="$pattern\tln --symbolic \"\$PATH_DATA/saves\" \"$save_path\"|"
for file in "${PKG_BIN_PATH}${PATH_BIN}"/*; do
	sed --in-place "$pattern" "$file"
done

config_path='$WINEPREFIX/drive_c/users/$(whoami)/Local Settings/Application Data/Stories/Saved/Config'
pattern='s|cp --force --recursive --symbolic-link --update "$PATH_GAME"/\* "$PATH_PREFIX"|&\n'
pattern="$pattern\tmkdir --parents \"${config_path%/*}\"\n"
pattern="$pattern\tmkdir --parents \"\$PATH_CONFIG/config\"\n"
pattern="$pattern\tln --symbolic \"\$PATH_CONFIG/config\" \"$config_path\"|"
for file in "${PKG_BIN_PATH}${PATH_BIN}"/*; do
	sed --in-place "$pattern" "$file"
done

# Build package

postinst_icons_linking 'APP_LANGUAGE'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
