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
# Anima: Gate of Memories
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='anima-gate-of-memories'
GAME_NAME='Anima: Gate of Memories'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_anima_gate_of_memories_2.0.0.1.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/anima_gate_of_memories'
ARCHIVE_GOG_MD5='681d05255e1a162947af69d3e7537748'
ARCHIVE_GOG_SIZE='8900000'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.1'
ARCHIVE_GOG_TYPE='mojosetup_unzip'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./*.x86 ./*_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./*.x86_64 ./*_Data/*/x86_64'

ARCHIVE_GAME_ASSETS_PATH='data/noarch/game'
ARCHIVE_GAME_ASSETS_FILES='./*_Data/*.assets ./*_Data/*.assets.resS'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./*_Data'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='pulseaudio --start'
APP_MAIN_EXE_BIN32='GoMLinux.x86'
APP_MAIN_EXE_BIN64='GoMLinux.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='*_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_ASSETS PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_ASSETS_ID="${GAME_ID}-assets"
PKG_ASSETS_DESCRIPTION='assets'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS_DEB="$PKG_ASSETS_ID, $PKG_DATA_ID, libc6, libglu1-mesa | libglu1, libxcursor1, libxrandr2, pulseaudio:amd64 | pulseaudio"
PKG_BIN32_DEPS_ARCH="$PKG_ASSETS_ID $PKG_DATA_ID lib32-glu lib32-libxcursor lib32-libxrandr pulseaudio"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS_DEB="$PKG_BIN32_DEPS_DEB"
PKG_BIN64_DEPS_ARCH="$PKG_ASSETS_ID $PKG_DATA_ID glu libxcursor libxrandr pulseaudio"

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

PKG='PKG_ASSETS'
organize_data 'GAME_ASSETS' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'DOC'       "$PATH_DOC"
organize_data 'GAME_DATA' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_ASSETS' 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "${PLAYIT_WORKDIR}"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_ASSETS' 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_ASSETS' 'PKG_DATA' 'PKG_BIN64'

exit 0
