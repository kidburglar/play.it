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
# Tropico 2
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180406.1

# Set game-specific variables

GAME_ID='tropico-2'
GAME_NAME='Tropico 2: Pirate Cove'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_tropico2_2.1.0.14.exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/tropico_reloaded'
ARCHIVE_GOG_EN_MD5='59a41778988f4b0a45d144f29187ffd8'
ARCHIVE_GOG_EN_VERSION='1.20-gog2.1.0.14'
ARCHIVE_GOG_EN_SIZE='1900000'

ARCHIVE_GOG_FR='setup_tropico2_french_2.1.0.14.exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/tropico_reloaded'
ARCHIVE_GOG_FR_MD5='e9cb36d88a03fd65b7152c815f05a7cc'
ARCHIVE_GOG_FR_VERSION='1.20-gog2.1.0.14'
ARCHIVE_GOG_FR_SIZE='1900000'

ARCHIVE_DOC_L10N_PATH='app'
ARCHIVE_DOC_L10N_FILES='./*.doc ./*.pdf ./*.rtf ./*.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./binkw32.dll ./drvmgt.dll ./mss32.dll ./mssmp3.asi ./tropico2.exe ./tropico2.ini'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./data/soun.{} ./data/text.{} ./maps ./movies/desktooutside.bik ./movies/campaigntoexit.bik'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./data ./movies'

CONFIG_FILES='./*.ini'
DATA_DIRS='./campaign ./maps ./save'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='tropico2.exe'
APP_MAIN_ICON='tropico2.exe'
APP_MAIN_ICON_RES='32 48'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine"

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

# Extract icon

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Use software rendering

file="${PKG_BIN_PATH}${PATH_GAME}/tropico2.ini"
pattern='s/^\(SoftwareDevice\)=.\+/\1=1/'
sed --in-place "$pattern" "$file"

# Build packages

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
