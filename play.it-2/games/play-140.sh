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
# 140
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='140-game'
GAME_NAME='140'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_HUMBLE ARCHIVE_HUMBLE_OLD ARCHIVE_HUMBLE_OLDER'

ARCHIVE_GOG='gog_140_2.2.0.3.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/140_game'
ARCHIVE_GOG_MD5='03e760fa1b667059db7713a9e6c06b6d'
ARCHIVE_GOG_SIZE='130000'
ARCHIVE_GOG_VERSION='2.0.20170719r370-gog2.2.0.3'

ARCHIVE_GOG_OLD='gog_140_2.1.0.2.sh'
ARCHIVE_GOG_OLD_MD5='6139b77721657a919085aea9f13cf42b'
ARCHIVE_GOG_OLD_SIZE='130000'
ARCHIVE_GOG_OLD_VERSION='2.0.20170619-gog2.1.0.2'

ARCHIVE_GOG_OLDER='gog_140_2.0.0.1.sh'
ARCHIVE_GOG_OLDER_MD5='49ec4cff5fa682517e640a2d0eb282c8'
ARCHIVE_GOG_OLDER_SIZE='110000'
ARCHIVE_GOG_OLDER_VERSION='2.0-gog2.0.0.1'

ARCHIVE_HUMBLE='140-nodrm-linux-2017-07-19-r370.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/140'
ARCHIVE_HUMBLE_MD5='2444ec7803c5d6dcf161b722705f0402'
ARCHIVE_HUMBLE_SIZE='130000'
ARCHIVE_HUMBLE_VERSION='2.0.20170719r370-humble170804'

ARCHIVE_HUMBLE_OLD='140-nodrm-linux-2017-06-20.zip'
ARCHIVE_HUMBLE_OLD_MD5='5bbc48b203291ca9a0b141e3d07dacbe'
ARCHIVE_HUMBLE_OLD_SIZE='130000'
ARCHIVE_HUMBLE_OLD_VERSION='2.0.20170619-humble170620'

ARCHIVE_HUMBLE_OLDER='140_Linux.zip'
ARCHIVE_HUMBLE_OLDER_MD5='0829eb743010653633571b3da20502a8'
ARCHIVE_HUMBLE_OLDER_SIZE='110000'
ARCHIVE_HUMBLE_OLDER_VERSION='2.0-humble160914'

ARCHIVE_GAME_BIN32_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN32_PATH_GOG_OLD='data/noarch/game'
ARCHIVE_GAME_BIN32_PATH_GOG_OLDER='data/noarch/game'
ARCHIVE_GAME_BIN32_PATH_HUMBLE='.'
ARCHIVE_GAME_BIN32_PATH_HUMBLE_OLD='linux'
ARCHIVE_GAME_BIN32_PATH_HUMBLE_OLDER='.'
ARCHIVE_GAME_BIN32_FILES='./140.x86 ./140Linux.x86 ./140_Data/*/x86 ./140Linux_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN64_PATH_GOG_OLD='data/noarch/game'
ARCHIVE_GAME_BIN64_PATH_GOG_OLDER='data/noarch/game'
ARCHIVE_GAME_BIN64_PATH_HUMBLE='.'
ARCHIVE_GAME_BIN64_PATH_HUMBLE_OLD='linux'
ARCHIVE_GAME_BIN64_PATH_HUMBLE_OLDER='.'
ARCHIVE_GAME_BIN64_FILES='./140.x86_64 ./140Linux.x86_64 ./140_Data/*/x86_64 ./140Linux_Data/*/x86_64'

ARCHIVE_GAME_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_GOG_OLD='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_GOG_OLDER='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_HUMBLE='.'
ARCHIVE_GAME_DATA_PATH_HUMBLE_OLD='linux'
ARCHIVE_GAME_DATA_PATH_HUMBLE_OLDER='.'
ARCHIVE_GAME_DATA_FILES='./140_Data ./140Linux_Data'

DATA_DIRS='./logs'
DATA_FILES='./140.sav'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='pulseaudio --start'
APP_MAIN_EXE_BIN32='140Linux.x86'
APP_MAIN_EXE_BIN64='140Linux.x86_64'
APP_MAIN_EXE_BIN32_OLD='140.x86'
APP_MAIN_EXE_BIN64_OLD='140.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='*_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS_DEB="$PKG_DATA_ID, libc6, libstdc++6, libglu1-mesa | libglu1, libxcursor1, pulseaudio"
PKG_BIN32_DEPS_ARCH="$PKG_DATA_ID lib32-glibc lib32-gcc-libs lib32-glu lib32-alsa-lib lib32-libxcursor pulseaudio"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS_DEB="$PKG_BIN32_DEPS_DEB"
PKG_BIN64_DEPS_ARCH="$PKG_DATA_ID glibc gcc-libs glu alsa-lib libxcursor pulseaudio"

# Load common functions

target_version='2.3'

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

PKG='PKG_BIN32'
organize_data 'GAME_BIN32' "$PATH_GAME"

PKG='PKG_BIN64'
organize_data 'GAME_BIN64' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC'       "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

if [ "${SOURCE_ARCHIVE##*/}" = "$ARCHIVE_GOG_OLDER" ] ||\
   [ "${SOURCE_ARCHIVE##*/}" = "$ARCHIVE_HUMBLE_OLDER" ]; then
	APP_MAIN_EXE_BIN32="$APP_MAIN_EXE_BIN32_OLD"
	APP_MAIN_EXE_BIN64="$APP_MAIN_EXE_BIN64_OLD"
fi

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_DATA' 'PKG_BIN64'

exit 0
