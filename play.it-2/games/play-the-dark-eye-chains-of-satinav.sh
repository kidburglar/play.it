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
# The Dark Eye: Chains of Satinav
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='the-dark-eye-chains-of-satinav'
GAME_NAME='The Dark Eye: Chains of Satinav'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_the_dark_eye_chains_of_satinav_2.0.0.4.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_dark_eye_chains_of_satinav'
ARCHIVE_GOG_MD5='d1c375ba007b7ed6574a16cca823258a'
ARCHIVE_GOG_SIZE='5500000'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.4'
ARCHIVE_GOG_PART1='setup_the_dark_eye_chains_of_satinav_2.0.0.4-1.bin'
ARCHIVE_GOG_PART1_MD5='0c9ea69bdb3e2c66d13f2d27812279b6'
ARCHIVE_GOG_PART1_TYPE='innosetup'
ARCHIVE_GOG_PART2='setup_the_dark_eye_chains_of_satinav_2.0.0.4-2.bin'
ARCHIVE_GOG_PART2_MD5='d87f0693751554c1d382f770202e8c45'
ARCHIVE_GOG_PART2_TYPE='innosetup'
ARCHIVE_GOG_PART3='setup_the_dark_eye_chains_of_satinav_2.0.0.4-3.bin'
ARCHIVE_GOG_PART3_MD5='ef662b59635829ed4505f6d7272e4bb7'
ARCHIVE_GOG_PART3_TYPE='innosetup'
ARCHIVE_GOG_PART4='setup_the_dark_eye_chains_of_satinav_2.0.0.4-4.bin'
ARCHIVE_GOG_PART4_MD5='555d8af3bb598ed4c481e3e3d63b0221'
ARCHIVE_GOG_PART4_TYPE='innosetup'

ARCHIVE_DOC1_PATH='app/documents/licenses'
ARCHIVE_DOC1_FILES='./*'

ARCHIVE_DOC2_PATH='tmp'
ARCHIVE_DOC2_FILES='./*.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./audiere.dll ./avcodec-53.dll ./avformat-53.dll ./avutil-51.dll ./config.ini ./satinav.exe ./sdl.dll ./swscale-2.dll ./visionaireconfigurationtool.exe ./zlib1.dll'

ARCHIVE_GAME_SCENES_PATH='app'
ARCHIVE_GAME_SCENES_FILES='./scenes'

ARCHIVE_GAME_CHARACTERS_PATH='app'
ARCHIVE_GAME_CHARACTERS_FILES='./characters'

ARCHIVE_GAME_VIDEOS_PATH='app'
ARCHIVE_GAME_VIDEOS_FILES='./videos'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./banner.jpg ./data.vis ./folder.jpg ./language.xml ./lua'

CONFIG_FILES='./*.ini ./*.xml'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='./satinav.exe'
APP_MAIN_ICON='./satinav.exe'
APP_MAIN_ICON_RES='16 24 32 48 256'

PACKAGES_LIST='PKG_SCENES PKG_CHARACTERS PKG_VIDEOS PKG_DATA PKG_BIN'

PKG_SCENES_ID="${GAME_ID}-scenes"
PKG_SCENES_DESCRIPTION='scenes'

PKG_CHARACTERS_ID="${GAME_ID}-characters"
PKG_CHARACTERS_DESCRIPTION='characters'

PKG_VIDEOS_ID="${GAME_ID}-videos"
PKG_VIDEOS_DESCRIPTION='videos'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_SCENES_ID, $PKG_CHARACTERS_ID, $PKG_VIDEOS_ID, $PKG_DATA_ID, wine32 | wine-bin | wine-i386 | wine-staging-i386, wine:amd64 | wine"
PKG_BIN_DEPS_ARCH="$PKG_SCENES_ID $PKG_CHARACTERS_ID $PKG_VIDEOS_ID $PKG_DATA_ID wine"

# Load common functions

target_version='2.0'

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

# Check that all parts of the installer are present

set_archive 'ARCHIVE_PART1' 'ARCHIVE_GOG_PART1'
[ "$ARCHIVE_PART1" ] || set_archive_error_not_found 'ARCHIVE_GOG_PART1'
set_archive 'ARCHIVE_PART2' 'ARCHIVE_GOG_PART2'
[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_PART2'
set_archive 'ARCHIVE_PART3' 'ARCHIVE_GOG_PART3'
[ "$ARCHIVE_PART3" ] || set_archive_error_not_found 'ARCHIVE_GOG_PART3'
set_archive 'ARCHIVE_PART4' 'ARCHIVE_GOG_PART4'
[ "$ARCHIVE_PART4" ] || set_archive_error_not_found 'ARCHIVE_GOG_PART4'
ARCHIVE='ARCHIVE_GOG'

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_SCENES'
organize_data 'GAME_SCENES' "$PATH_GAME"

PKG='PKG_CHARACTERS'
organize_data 'GAME_CHARACTERS' "$PATH_GAME"

PKG='PKG_VIDEOS'
organize_data 'GAME_VIDEOS' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC1'      "$PATH_DOC"
organize_data 'DOC2'      "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
