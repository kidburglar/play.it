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
# The Night of the Rabbit
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180331.5

# Set game-specific variables

GAME_ID='the-night-of-the-rabbit'
GAME_NAME='The Night of the Rabbit'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD'

ARCHIVE_GOG='setup_the_night_of_the_rabbit_1.2.3.0389_(18473).exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_night_of_the_rabbit'
ARCHIVE_GOG_MD5='f809a5911492fc4dcb8c90f09f2ca515'
ARCHIVE_GOG_VERSION='1.2.3.0389-gog18473'
ARCHIVE_GOG_SIZE='6200000'
ARCHIVE_GOG_TYPE='innosetup'
ARCHIVE_GOG_PART1='setup_the_night_of_the_rabbit_1.2.3.0389_(18473)-1.bin'
ARCHIVE_GOG_PART1_MD5='0cfd2d4a5a604e4bf5d070a22fdcc73e'
ARCHIVE_GOG_PART1_TYPE='innosetup'
ARCHIVE_GOG_PART2='setup_the_night_of_the_rabbit_1.2.3.0389_(18473)-2.bin'
ARCHIVE_GOG_PART2_MD5='3b510f6837a5aee5fb4ab5c34643c844'
ARCHIVE_GOG_PART2_TYPE='innosetup'

ARCHIVE_GOG_OLD='setup_the_night_of_the_rabbit_2.1.0.5-1.bin'
ARCHIVE_GOG_OLD_MD5='565c8c59266eced8483ad579ecf3c454'
ARCHIVE_GOG_OLD_VERSION='1.2.3.0389-gog2.1.0.5'
ARCHIVE_GOG_OLD_SIZE='6200000'
ARCHIVE_GOG_OLD_TYPE='rar'
ARCHIVE_GOG_OLD_GOGID='1207659218'
ARCHIVE_GOG_OLD_PART1='setup_the_night_of_the_rabbit_2.1.0.5-2.bin'
ARCHIVE_GOG_OLD_PART1_MD5='403e06a8e8aef71989bf550369244373'
ARCHIVE_GOG_OLD_PART1_TYPE='rar'

ARCHIVE_DOC_DATA_PATH='app/documents/licenses'
ARCHIVE_DOC_DATA_PATH_GOG_OLD='game/documents/licenses'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME1_BIN_PATH='app'
ARCHIVE_GAME1_BIN_PATH_GOG_OLD='game'
ARCHIVE_GAME1_BIN_FILES='./avcodec-54.dll ./avformat-54.dll ./avutil-52.dll ./libsndfile-1.dll ./openal32.dll ./rabbit.exe ./sdl2.dll ./swresample-0.dll ./swscale-2.dll ./visionaireconfigurationtool.exe ./zlib1.dll'

ARCHIVE_GAME2_BIN_PATH='app/__support/app'
ARCHIVE_GAME2_BIN_PATH_GOG_OLD='support/app'
ARCHIVE_GAME2_BIN_FILES='./config.ini'

ARCHIVE_GAME_SCENES_PATH='app'
ARCHIVE_GAME_SCENES_PATH_GOG_OLD='game'
ARCHIVE_GAME_SCENES_FILES='./scenes'

ARCHIVE_GAME_VIDEO_PATH='app'
ARCHIVE_GAME_VIDEO_PATH_GOG_OLD='game'
ARCHIVE_GAME_VIDEO_FILES='./videos'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_PATH_GOG_OLD='game'
ARCHIVE_GAME_DATA_FILES='./banner.jpg ./characters ./data.vis ./folder.jpg ./languages.xml ./lua'

CONFIG_FILES='./config.ini'

APP_WINETRICKS='directx9'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='./rabbit.exe'
APP_MAIN_ICON='./rabbit.exe'
APP_MAIN_ICON_RES='16 24 32 48 256'
APP_MAIN_ICON_RES_ICOTOOL_BUG='256'

PACKAGES_LIST='PKG_SCENES PKG_VIDEO PKG_DATA PKG_BIN'

PKG_SCENES_ID="${GAME_ID}-scenes"
PKG_SCENES_DESCRIPTION='scenes'

PKG_VIDEO_ID="${GAME_ID}-videos"
PKG_VIDEO_DESCRIPTION='videos'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_SCENES_ID $PKG_VIDEO_ID $PKG_DATA_ID wine"

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
if [ "$ARCHIVE" = 'ARCHIVE_GOG_OLD' ]; then
	ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE")" "$PLAYIT_WORKDIR/$GAME_ID.r00"
	ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE_PART1")" "$PLAYIT_WORKDIR/$GAME_ID.r01"
	extract_data_from "$PLAYIT_WORKDIR/$GAME_ID.r00"
	tolower "$PLAYIT_WORKDIR/gamedata"
else
	extract_data_from "$SOURCE_ARCHIVE"
fi

prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Extract icon

PKG='PKG_BIN'

ICOTOOL_VERSION="$(icotool --version | head --lines=1 | cut --delimiter=' ' --fields=3)"
ICOTOOL_VERSION_MAJOR="$(printf '%s' "$ICOTOOL_VERSION" | cut --delimiter='.' --fields=1)"
ICOTOOL_VERSION_MINOR="$(printf '%s' "$ICOTOOL_VERSION" | cut --delimiter='.' --fields=2)"

if [ "$ICOTOOL_VERSION_MAJOR" = 0 ] && [ "$ICOTOOL_VERSION_MINOR" = 32 ]; then
	APP_MAIN_ICON_RES="$APP_MAIN_ICON_RES_ICOTOOL_BUG"
fi

set +o errexit
extract_and_sort_icons_from 'APP_MAIN'
set -o errexit
move_icons_to 'PKG_DATA'

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Store saved games outside of WINE prefix

save_path='$WINEPREFIX/drive_c/users/$(whoami)/Local Settings/Application Data/Daedalic Entertainment/The Night of the Rabbit/Savegames'
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
