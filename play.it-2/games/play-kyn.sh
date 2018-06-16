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
# Kyn
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180318.1

# Set game-specific variables

GAME_ID='kyn'
GAME_NAME='Kyn'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD'

ARCHIVE_GOG='setup_kyn_update_4_(17655).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/kyn'
ARCHIVE_GOG_MD5='ca2a665c27ef02f0bfa4e72dc368952c'
ARCHIVE_GOG_SIZE='7900000'
ARCHIVE_GOG_VERSION='1.0.4-gog17655'
ARCHIVE_GOG_TYPE='innosetup'
ARCHIVE_GOG_PART1='setup_kyn_update_4_(17655)-1.bin'
ARCHIVE_GOG_PART1_MD5='8c6c13b15a4d39ac9389c7c4f9ce6760'
ARCHIVE_GOG_PART1_TYPE='innosetup'

ARCHIVE_GOG_OLD='setup_kyn_2.1.0.4.exe'
ARCHIVE_GOG_OLD_MD5='a40cb85cdd40b7464eec92b2b9166f84'
ARCHIVE_GOG_OLD_SIZE='7900000'
ARCHIVE_GOG_OLD_VERSION='1.0-gog2.1.0.4'
ARCHIVE_GOG_OLD_TYPE='rar'
ARCHIVE_GOG_OLD_PART1='setup_kyn_2.1.0.4-1.bin'
ARCHIVE_GOG_OLD_PART1_MD5='4cfdca351969f2570a3657c772fd492e'
ARCHIVE_GOG_OLD_PART1_TYPE='rar'

DATA_DIRS='./logs'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_PATH_GOG_OLD='game'
ARCHIVE_GAME_BIN_FILES='./kyn.exe kyn_data/mono kyn_data/plugins kyn_data/managed'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_PATH_GOG_OLD='game'
ARCHIVE_GAME_DATA_FILES='kyn_data/resources kyn_data/level* kyn_data/maindata kyn_data/playerconnectionconfigfile kyn_data/resources.assets kyn_data/sharedassets*'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='kyn.exe'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICON='kyn.exe'
APP_MAIN_ICON_RES='16 24 32 48 64 96 128 256'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine"

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

case "$ARCHIVE" in
	('ARCHIVE_GOG')
		extract_data_from "$SOURCE_ARCHIVE"
	;;
	('ARCHIVE_GOG_OLD')
		extract_data_from "$SOURCE_ARCHIVE_PART1"
		tolower "$PLAYIT_WORKDIR/gamedata"
	;;
esac

prepare_package_layout

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Store saved games outside of WINE prefix

save_path='$WINEPREFIX/drive_c/users/$(whoami)/AppData/LocalLow/Tangrin Entertainment/Kyn/Saves'
pattern='s#cp --force --recursive --symbolic-link --update "$PATH_GAME"/\* "$PATH_PREFIX"#&\n'
pattern="$pattern\tmkdir --parents \"${save_path%/*}\"\n"
pattern="$pattern\tmkdir --parents \"\$PATH_DATA/saves\"\n"
pattern="$pattern\tln --symbolic \"\$PATH_DATA/saves\" \"$save_path\"#"
for file in "${PKG_BIN_PATH}${PATH_BIN}"/*; do
	sed --in-place "$pattern" "$file"
done

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
