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
# Solar 2
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='solar-2'
GAME_NAME='Solar 2'

ARCHIVES_LIST='ARCHIVE_HUMBLE'

ARCHIVE_HUMBLE='solar2-linux-1.10_1409159048.tar.gz'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/solar-2'
ARCHIVE_HUMBLE_MD5='243918907eea486fdc820b7cac0c260b'
ARCHIVE_HUMBLE_SIZE='130000'
ARCHIVE_HUMBLE_VERSION='1.10-humble1'

ARCHIVE_ICONS_PACK='solar-2_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='d8f8557a575cb5b5824d72718428cd33'

ARCHIVE_GAME_BIN_PATH='Solar2'
ARCHIVE_GAME_BIN_FILES='./Solar2.bin.x86 ./Solar2.exe ./*.dll ./*.config ./display.txt ./mono ./lib/libmad.so.0.2.1 ./lib/libmikmod.so.2.0.4 ./lib/libmono-2.0.so.1 ./lib/libopenal.so.1.13.0 ./lib/libSDL_mixer-1.2.so.0.10.1'

ARCHIVE_GAME_DATA_PATH='Solar2'
ARCHIVE_GAME_DATA_FILES='./Languages ./MonoContent'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./32x32 ./48x48 ./64x64'

CONFIG_FILES='./display.txt'
DATA_DIRS='./Languages'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='Solar2.bin.x86'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, libc6, libstdc++6"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID lib32-glibc"

# Load common functions

target_version='2.5'

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

# Try to load icons archive

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_ICONS' 'ARCHIVE_ICONS_PACK'
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
set_standard_permissions "$PLAYIT_WORKDIR/gamedata"
if [ "$ARCHIVE_ICONS" ]; then
	(
		ARCHIVE='ARCHIVE_ICONS'
		extract_data_from "$ARCHIVE_ICONS"
	)
fi

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'GAME_DATA' "$PATH_GAME"

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	organize_data 'ICONS' "$PATH_ICON_BASE"
fi

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

cat > "$postinst" << EOF
if ! [ -e "$PATH_GAME/lib/libmad.so.0" ]; then
        ln --symbolic ./libmad.so.0.2.1 "$PATH_GAME/lib/libmad.so.0"
fi
if ! [ -e "$PATH_GAME/lib/libmikmod.so.2" ]; then
        ln --symbolic ./libmikmod.so.2.0.4 "$PATH_GAME/lib/libmikmod.so.2"
fi
if ! [ -e "$PATH_GAME/lib/libmono-2.0.so" ]; then
        ln --symbolic ./libmono-2.0.so.1 "$PATH_GAME/lib/libmono-2.0.so"
fi
if ! [ -e "$PATH_GAME/lib/libopenal.so.1" ]; then
        ln --symbolic ./libopenal.so.1.13.0 "$PATH_GAME/lib/libopenal.so.1"
fi
if ! [ -e "$PATH_GAME/lib/libSDL_mixer-1.2.so.0" ]; then
        ln --symbolic ./libSDL_mixer-1.2.so.0.10.1 "$PATH_GAME/lib/libSDL_mixer-1.2.so.0"
fi
EOF

cat > "$prerm" << EOF
if [ -e "$PATH_GAME/lib/libmad.so.0" ]; then
        rm "$PATH_GAME/lib/libmad.so.0"
fi
if [ -e "$PATH_GAME/lib/libmikmod.so.2" ]; then
        rm "$PATH_GAME/lib/libmikmod.so.2"
fi
if [ -e "$PATH_GAME/lib/libmono-2.0.so" ]; then
        rm "$PATH_GAME/lib/libmono-2.0.so"
fi
if [ -e "$PATH_GAME/lib/libopenal.so.1" ]; then
        rm "$PATH_GAME/lib/libopenal.so.1"
fi
if [ -e "$PATH_GAME/lib/libSDL_mixer-1.2.so.0" ]; then
        rm "$PATH_GAME/lib/libSDL_mixer-1.2.so.0"
fi
EOF

write_metadata 'PKG_BIN'
write_metadata 'PKG_DATA'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

#print instructions

print_instructions

exit 0
