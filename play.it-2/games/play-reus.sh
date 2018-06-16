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
# Reus
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180519.1

# Set game-specific variables

GAME_ID='reus'
GAME_NAME='Reus'

ARCHIVE_GOG='reus_en_1_6_5_20844.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/reus'
ARCHIVE_GOG_MD5='a768dd2347ac7f6be16ffa9e3f0952c4'
ARCHIVE_GOG_SIZE='480000'
ARCHIVE_GOG_VERSION='1.6.5-gog20844'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='gog_reus_2.0.0.2.sh'
ARCHIVE_GOG_OLD_MD5='25fe7ec93305e804558e4ef8a31fbbf8'
ARCHIVE_GOG_OLD_SIZE='480000'
ARCHIVE_GOG_OLD_VERSION='1.5.1-gog2.0.0.2'

ARCHIVE_HUMBLE='reus_linux_1389636757-bin'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/reus'
ARCHIVE_HUMBLE_MD5='9914e7fcb5f3b761941169ae13ec205c'
ARCHIVE_HUMBLE_SIZE='380000'
ARCHIVE_HUMBLE_TYPE='mojosetup'
ARCHIVE_HUMBLE_VERSION='0.beta-humble140113'

ARCHIVE_DOC0_PATH_GOG='data/noarch/game'
ARCHIVE_DOC0_PATH_HUMBLE='data'
ARCHIVE_DOC0_FILES='./Linux.README'

ARCHIVE_DOC1_PATH_GOG='data/noarch/docs'
ARCHIVE_DOC1_FILES='./*'

ARCHIVE_GAME_BIN32_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN32_PATH_HUMBLE='data'
ARCHIVE_GAME_BIN32_FILES='./Reus.bin.x86 ./lib'

ARCHIVE_GAME_BIN64_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN64_PATH_HUMBLE='data'
ARCHIVE_GAME_BIN64_FILES='./Reus.bin.x86_64 ./lib64'

ARCHIVE_GAME_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_HUMBLE='data'
ARCHIVE_GAME_DATA_FILES='./*.dll ./*.dll.config ./Audio ./Cursors ./Effects ./Fonts ./MainMenu ./mono ./monoconfig ./monomachineconfig ./Particles ./Reus.bmp ./Reus.exe ./Settings ./Skeletons ./Textures ./UI'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='Reus.bin.x86'
APP_MAIN_EXE_BIN64='Reus.bin.x86_64'
APP_MAIN_ICON='Reus.bmp'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc libstdc++ vorbis openal sdl2 freetype"
PKG_BIN32_DEPS_DEB='libtheora0'
PKG_BIN32_DEPS_ARCH='lib32-libtheora'

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"
PKG_BIN64_DEPS_DEB="$PKG_BIN32_DEPS_DEB"
PKG_BIN64_DEPS_ARCH='libtheora'

# Load common functions

target_version='2.8'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	for path in\
		'./'\
		"$XDG_DATA_HOME/play.it/"\
		"$XDG_DATA_HOME/play.it/play.it-2/lib/"\
		'/usr/local/share/games/play.it/'\
		'/usr/local/share/play.it/'\
		'/usr/share/games/play.it/'\
		'/usr/share/play.it/'
	do
		if [ -z "$PLAYIT_LIB2" ] && [ -e "$path/libplayit2.sh" ]; then
			PLAYIT_LIB2="$path/libplayit2.sh"
			break
		fi
	done
	if [ -z "$PLAYIT_LIB2" ]; then
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

PKG='PKG_DATA'
icons_get_from_package 'APP_MAIN'

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
