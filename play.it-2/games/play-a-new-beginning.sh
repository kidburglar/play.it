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
# A New Beginning
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180402.1

# Set game-specific variables

GAME_ID='a-new-beginning'
GAME_NAME='A New Beginning'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_a_new_beginning_final_cut_2.2.0.7.bin'
ARCHIVE_GOG_URL='https://www.gog.com/game/a_new_beginning'
ARCHIVE_GOG_MD5='1babc74ae7f29ff6ce16ea9fd3e4d3ff'
ARCHIVE_GOG_SIZE='4100000'
ARCHIVE_GOG_VERSION='1.0-gog2.2.0.7'
ARCHIVE_GOG_TYPE='rar'
ARCHIVE_GOG_GOGID='1207659150'

ARCHIVE_DOC_DATA_PATH='game'
ARCHIVE_DOC_DATA_FILES='./*.pdf'

ARCHIVE_GAME0_BIN_PATH='game'
ARCHIVE_GAME0_BIN_FILES='./anb.exe ./VisionaireConfigurationTool.exe ./avcodec-54.dll ./avformat-54.dll ./avutil-52.dll ./libsndfile-1.dll ./openal32.dll ./SDL2.dll ./swresample-0.dll ./swscale-2.dll ./zlib1.dll'

ARCHIVE_GAME1_BIN_PATH='support/app'
ARCHIVE_GAME1_BIN_FILES='./config.ini'

ARCHIVE_GAME_DATA_PATH='game'
ARCHIVE_GAME_DATA_FILES='./banner.jpg ./characters ./data.vis ./documents ./folder.jpg ./Languages.xml ./scenes ./videos'

CONFIG_FILES='./config.ini'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='anb.exe'
APP_MAIN_ICON='anb.exe'
APP_MAIN_ICON_RES='16 32 48'

APP_WINETRICKS='dotnet40'

PACKAGES_LIST=' PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine winetricks"

# Load common functions

target_version='2.7'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	if [ -e "$XDG_DATA_HOME/play.it/libplayit2.sh" ]; then
		PLAYIT_LIB2="$XDG_DATA_HOME/play.it/libplayit2.sh"
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

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Store saved games outside of WINE prefix

save_path='$WINEPREFIX/drive_c/users/$(whoami)/Local Settings/Application Data/Daedalic Entertainment/A New Beginning - Final Cut/Savegames'
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
