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
# Heroes of Might and Magic
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180506.1

# Set game-specific variables

GAME_ID='heroes-of-might-and-magic-1'
GAME_NAME='Heroes of Might and Magic: A Strategic Quest'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_heroes_of_might_and_magic_2.3.0.45.exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/heroes_of_might_and_magic'
ARCHIVE_GOG_EN_MD5='2cae1821085090e30e128cd0a76b0d21'
ARCHIVE_GOG_EN_SIZE='530000'
ARCHIVE_GOG_EN_VERSION='1.0-gog2.3.0.45'

ARCHIVE_GOG_FR='setup_heroes_of_might_and_magic_french_2.3.0.45.exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/heroes_of_might_and_magic'
ARCHIVE_GOG_FR_MD5='9ec736a2a1b97dc36257f583f42864ac'
ARCHIVE_GOG_FR_SIZE='530000'
ARCHIVE_GOG_FR_VERSION='1.0-gog2.3.0.45'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./help ./*.pdf ./*.txt'

ARCHIVE_GAME0_BIN_PATH='app'
ARCHIVE_GAME0_BIN_FILES='./*.exe ./*.cfg ./wail32.dll'

ARCHIVE_GAME1_BIN_PATH='sys'
ARCHIVE_GAME1_BIN_FILES='./wing32.dll'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./data/campaign.hs ./data/heroes.agg ./data/standard.hs ./games ./maps'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./data ./goggame-1207658748.ico ./homm1.gog'

GAME_IMAGE='./homm1.gog'
GAME_IMAGE_TYPE='iso'

CONFIG_FILES='./*.cfg'
DATA_DIRS='./games ./maps'

APP_MAIN_TYPE='dosbox'
APP_MAIN_EXE='heroes.exe'
APP_MAIN_ICON='goggame-1207658748.ico'

APP_EDITOR_ID="${GAME_ID}-editor"
APP_EDITOR_NAME="$GAME_NAME - editor"
APP_EDITOR_TYPE='dosbox'
APP_EDITOR_EXE='editor.exe'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_DATA_ID="$GAME_ID-data"
PKG_DATA_DESCRIPTION='data'

PKG_L10N_ID="$GAME_ID-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_FR='French localization'
PKG_L10N_DESCRIPTION_GOG_EN='English localization'

PKG_BIN_ID="$GAME_ID"
PKG_BIN_ID_GOG_EN="${PKG_BIN_ID}-en"
PKG_BIN_ID_GOG_FR="${PKG_BIN_ID}-fr"
PKG_BIN_PROVIDE="$PKG_BIN_ID"
PKG_BIN_DEPS_GOG_FR="$PKG_L10N_FR_ID $PKG_DATA dosbox"
PKG_BIN_DEPS_GOG_EN="$PKG_L10N_EN_ID $PKG_DATA dosbox"
PKG_BIN_DESCRIPTION_GOG_FR='French version'
PKG_BIN_DESCRIPTION_GOG_EN='English version'

# Load common functions

target_version='2.8'

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

# Set archive specific variables

case "$ARCHIVE" in
	('ARCHIVE_GOG_EN')
		PKG_BIN_DEPS="$PKG_BIN_DEPS_GOG_EN"
	;;
	('ARCHIVE_GOG_FR')
		PKG_BIN_DEPS="$PKG_BIN_DEPS_GOG_FR"
	;;
esac

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Extract icons

PKG='PKG_DATA'
icons_get_from_package 'APP_MAIN'
rm "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_EDITOR'

# Use base game icon for editor launcher

file="${PKG_BIN_PATH}${PATH_DESK}/$APP_EDITOR_ID.desktop"
pattern="s/\(Icon\)=.*/\1=$GAME_ID/"
sed --in-place "$pattern" "$file"

# Build packages

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
