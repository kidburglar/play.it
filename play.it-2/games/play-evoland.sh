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
# Evoland
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='evoland'
GAME_NAME='Evoland'

ARCHIVES_LIST='ARCHIVE_HUMBLE'

ARCHIVE_HUMBLE='Evoland.exe'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/evoland'
ARCHIVE_HUMBLE_MD5='9585142f38d769d4ac9125f587d0c891'
ARCHIVE_HUMBLE_SIZE='110000'
ARCHIVE_HUMBLE_VERSION='1.1.2490-humble1'
ARCHIVE_HUMBLE_TYPE='nullsoft-installer'

ARCHIVE_GAME_BIN_PATH='.'
ARCHIVE_GAME_BIN_FILES='./Adobe?AIR ./dinput8.dll ./Evoland.exe ./pad.exe'

ARCHIVE_GAME_DATA_PATH='.'
ARCHIVE_GAME_DATA_FILES='./game.dat ./icons ./META-INF ./mimetype'

APP_WINETRICKS='csmt=on'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='Evoland.exe'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON_16 APP_MAIN_ICON_32 APP_MAIN_ICON_48 APP_MAIN_ICON_128'
APP_MAIN_ICON_16='icons/evoIcon16.png'
APP_MAIN_ICON_16_RES='16'
APP_MAIN_ICON_32='icons/evoIcon32.png'
APP_MAIN_ICON_32_RES='32'
APP_MAIN_ICON_48='icons/evoIcon48.png'
APP_MAIN_ICON_48_RES='48'
APP_MAIN_ICON_128='icons/evoIcon128.png'
APP_MAIN_ICON_128_RES='128'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine-staging winetricks"

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

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Store saved games outside of WINE prefix

save_path='$WINEPREFIX/drive_c/users/$(whoami)/Application Data/com.shirogames.evoland/Local Store/#SharedObjects/game.dat'
pattern='s|cp --force --recursive --symbolic-link --update "$PATH_GAME"/\* "$PATH_PREFIX"|&\n'
pattern="$pattern\tmkdir --parents \"${save_path%/*}\"\n"
pattern="$pattern\tmkdir --parents \"\$PATH_DATA/saves\"\n"
pattern="$pattern\tln --symbolic \"\$PATH_DATA/saves\" \"$save_path\"|"
for file in "${PKG_BIN_PATH}${PATH_BIN}"/*; do
	sed --in-place "$pattern" "$file"
done

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
