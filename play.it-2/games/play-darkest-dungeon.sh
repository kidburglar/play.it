#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2017, Antoine Le Gonidec
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
# Darkest Dungeon
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20170715.2

# Set game-specific variables

GAME_ID='darkest-dungeon'
GAME_NAME='Darkest Dungeon'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST'

ARCHIVE_GOG='gog_darkest_dungeon_2.15.0.15.sh'
ARCHIVE_GOG_MD5='aa129363a693458d421df1b203960f8c'
ARCHIVE_GOG_SIZE='2100000'
ARCHIVE_GOG_VERSION='20326-gog2.15.0.15'

ARCHIVE_GOG_OLD='gog_darkest_dungeon_2.14.0.14.sh'
ARCHIVE_GOG_OLD_MD5='68c3728388a44a9f7f859351748d2463'
ARCHIVE_GOG_OLD_SIZE='2100000'
ARCHIVE_GOG_OLD_VERSION='20326-gog2.14.0.14'

ARCHIVE_GOG_OLDER='gog_darkest_dungeon_2.13.0.13.sh'
ARCHIVE_GOG_OLDER_MD5='bea41d27a9b050872ebaa9c93cf0df12'
ARCHIVE_GOG_OLDER_SIZE='2100000'
ARCHIVE_GOG_OLDER_VERSION='20235-gog2.13.0.13'

ARCHIVE_GOG_OLDEST='gog_darkest_dungeon_2.12.0.12.sh'
ARCHIVE_GOG_OLDEST_MD5='0d809acc7b82fe7b280026e04f95f669'
ARCHIVE_GOG_OLDEST_SIZE='2100000'
ARCHIVE_GOG_OLDEST_VERSION='20108-gog2.12.0.12'

DATA_DIRS='./logs'

ARCHIVE_DOC1_PATH='data/noarch/docs'
ARCHIVE_DOC1_FILES='./*'

ARCHIVE_DOC2_PATH='data/noarch/game'
ARCHIVE_DOC2_FILES='./README.linux'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./lib ./darkest.bin.x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./lib64 ./darkest.bin.x86_64'

ARCHIVE_GAME_AUDIO_PATH='data/noarch/game'
ARCHIVE_GAME_AUDIO_FILES='./audio'

ARCHIVE_GAME_VIDEO_PATH='data/noarch/game'
ARCHIVE_GAME_VIDEO_FILES='./video'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./*'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='darkest.bin.x86'
APP_MAIN_EXE_BIN64='darkest.bin.x86_64'
APP_MAIN_OPTIONS='1>./logs/$(date +%F-%R).log 2>&1'
APP_MAIN_ICON='Icon.bmp'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_AUDIO PKG_VIDEO PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_AUDIO_ID="${GAME_ID}-audio"
PKG_AUDIO_DESCRIPTION='audio'

PKG_VIDEO_ID="${GAME_ID}-video"
PKG_VIDEO_DESCRIPTION='video'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS_DEB="$PKG_AUDIO_ID, $PKG_VIDEO_ID, $PKG_DATA_ID, libc6, libstdc++6, libsdl2-2.0-0"
PKG_BIN32_DEPS_ARCH="$PKG_AUDIO_ID $PKG_VIDEO_ID $PKG_DATA_ID lib32-glibc lib32-gcc-libs lib32-sdl2"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS_DEB="$PKG_BIN32_DEPS_DEB"
PKG_BIN64_DEPS_ARCH="$PKG_AUDIO_ID $PKG_VIDEO_ID $PKG_DATA_ID glibs gcc-libs sdl2"

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
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for dir in 'localization/ps4' 'localization/psv'\
           'shaders_ps4'      'shaders_psv'\
           'video_ps4'        'video_psv'; do
	rm --force --recursive "$PLAYIT_WORKDIR/gamedata/data/noarch/game/$dir"
done

PKG='PKG_BIN32'
organize_data 'GAME_BIN32' "$PATH_GAME"

PKG='PKG_BIN64'
organize_data 'GAME_BIN64' "$PATH_GAME"

PKG='PKG_AUDIO'
organize_data 'GAME_AUDIO' "$PATH_GAME"

PKG='PKG_VIDEO'
organize_data 'GAME_VIDEO' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC1'      "$PATH_DOC"
organize_data 'DOC2'      "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

res="$APP_MAIN_ICON_RES"
PATH_ICON="$PATH_ICON_BASE/${res}x${res}/apps"
extract_icon_from "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON"
mkdir --parents "${PKG_DATA_PATH}${PATH_ICON}"
mv "$PLAYIT_WORKDIR/icons/${APP_MAIN_ICON%.bmp}.png" "${PKG_DATA_PATH}${PATH_ICON}/$GAME_ID.png"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done


# Allow persistent logging via output redirection to work

sed --in-place 's|"\./$APP_EXE" $APP_OPTIONS $@|eval &|' "${PKG_BIN32_PATH}${PATH_BIN}/$GAME_ID"
sed --in-place 's|"\./$APP_EXE" $APP_OPTIONS $@|eval &|' "${PKG_BIN64_PATH}${PATH_BIN}/$GAME_ID"

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_AUDIO' 'PKG_VIDEO' 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_AUDIO' 'PKG_VIDEO' 'PKG_DATA' 'PKG_BIN64'

exit 0
