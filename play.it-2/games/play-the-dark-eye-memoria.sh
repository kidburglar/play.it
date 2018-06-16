#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2016, Antoine Le Gonidec
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
# Memoria
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180331.3

# Set game-specific variables

GAME_ID='the-dark-eye-memoria'
GAME_NAME='The Dark Eye: Memoria'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD'

ARCHIVE_GOG='setup_memoria_1.2.3.0341_(18923).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/memoria'
ARCHIVE_GOG_MD5='b939d4aa2aabf2bac1d527609e76ed0f'
ARCHIVE_GOG_SIZE='9100000'
ARCHIVE_GOG_VERSION='1.2.3.0341-gog18923'
ARCHIVE_GOG_PART1='setup_memoria_1.2.3.0341_(18923)-1.bin'
ARCHIVE_GOG_PART1_MD5='3067662d212dfb297106a24ffd474cbd'
ARCHIVE_GOG_PART1_TYPE='innosetup'
ARCHIVE_GOG_PART2='setup_memoria_1.2.3.0341_(18923)-2.bin'
ARCHIVE_GOG_PART2_MD5='24ff575f72e8b05b529aaaef99372090'
ARCHIVE_GOG_PART2_TYPE='innosetup'
ARCHIVE_GOG_PART3='setup_memoria_1.2.3.0341_(18923)-3.bin'
ARCHIVE_GOG_PART3_MD5='88a98736110a7a59633a5bec12411f22'
ARCHIVE_GOG_PART3_TYPE='innosetup'

ARCHIVE_GOG_OLD='setup_memoria_2.0.0.3.exe'
ARCHIVE_GOG_OLD_MD5='847c7b5e27a287d6e0e17e63bfb14fff'
ARCHIVE_GOG_OLD_SIZE='9100000'
ARCHIVE_GOG_OLD_VERSION='1.36.0053-gog2.0.0.3'
ARCHIVE_GOG_OLD_PART1='setup_memoria_2.0.0.3-1.bin'
ARCHIVE_GOG_OLD_PART1_MD5='e656464607e4d8599d599ed5b6b29fca'
ARCHIVE_GOG_OLD_PART1_TYPE='innosetup'
ARCHIVE_GOG_OLD_PART2='setup_memoria_2.0.0.3-2.bin'
ARCHIVE_GOG_OLD_PART2_MD5='593d57e8022c65660394c5bc5a333fe8'
ARCHIVE_GOG_OLD_PART2_TYPE='innosetup'
ARCHIVE_GOG_OLD_PART3='setup_memoria_2.0.0.3-3.bin'
ARCHIVE_GOG_OLD_PART3_MD5='0f8ef0abab77f3885aa4f8f9e58611eb'
ARCHIVE_GOG_OLD_PART3_TYPE='innosetup'
ARCHIVE_GOG_OLD_PART4='setup_memoria_2.0.0.3-4.bin'
ARCHIVE_GOG_OLD_PART4_MD5='0935149a66284bdc13659beafed2575f'
ARCHIVE_GOG_OLD_PART4_TYPE='innosetup'
ARCHIVE_GOG_OLD_PART5='setup_memoria_2.0.0.3-5.bin'
ARCHIVE_GOG_OLD_PART5_MD5='5b85fb7fcb51599ee89b5d7371b87ee2'
ARCHIVE_GOG_OLD_PART5_TYPE='innosetup'
ARCHIVE_GOG_OLD_PART6='setup_memoria_2.0.0.3-6.bin'
ARCHIVE_GOG_OLD_PART6_MD5='c8712354bbd093b706f551e75b549061'
ARCHIVE_GOG_OLD_PART6_TYPE='innosetup'

ARCHIVE_DOC1_DATA_PATH='app/documents/licenses'
ARCHIVE_DOC1_DATA_FILES='./*'

ARCHIVE_DOC2_DATA_PATH='tmp'
ARCHIVE_DOC2_DATA_FILES='./*eula.txt'

ARCHIVE_GAME1_BIN_PATH='app'
ARCHIVE_GAME1_BIN_FILES='./avcodec-54.dll ./avformat-54.dll ./avutil-52.dll ./config.ini ./libsndfile-1.dll ./memoria.exe ./openal32.dll ./sdl2.dll ./swresample-0.dll ./swscale-2.dll ./visionaireconfigurationtool.exe ./zlib1.dll'

ARCHIVE_GAME2_BIN_PATH='app/__support/app'
ARCHIVE_GAME2_BIN_FILES='./config.ini'

ARCHIVE_GAME_SCENES_PATH='app'
ARCHIVE_GAME_SCENES_FILES='./scenes'

ARCHIVE_GAME_CHARACTERS_PATH='app'
ARCHIVE_GAME_CHARACTERS_FILES='./characters'

ARCHIVE_GAME_VIDEOS_PATH='app'
ARCHIVE_GAME_VIDEOS_FILES='./videos'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./banner.jpg ./data.vis ./folder.jpg ./languages.xml ./lua'

CONFIG_FILES='./config.ini'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='memoria.exe'
APP_MAIN_ICON='memoria.exe'
APP_MAIN_ICON_RES='16 32 48 256'

PACKAGES_LIST='PKG_BIN PKG_SCENES PKG_CHARACTERS PKG_VIDEOS PKG_DATA'

PKG_SCENES_ID="${GAME_ID}-scenes"
PKG_SCENES_DESCRIPTION='scenes'

PKG_CHARACTERS_ID="${GAME_ID}-characters"
PKG_CHARACTERS_DESCRIPTION='characters'

PKG_VIDEOS_ID="${GAME_ID}-videos"
PKG_VIDEOS_DESCRIPTION='videos'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_SCENES_ID $PKG_CHARACTERS_ID $PKG_VIDEOS_ID $PKG_DATA_ID wine"

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

save_path='$WINEPREFIX/drive_c/users/$(whoami)/Local Settings/Application Data/Daedalic Entertainment/Memoria/Savegames'
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
