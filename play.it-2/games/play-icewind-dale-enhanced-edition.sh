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
# Icewind Dale - Enhanced Edition
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180514.1

# Set game-specific variables

GAME_ID='icewind-dale-enhanced-edition'
GAME_NAME='Icewind Dale - Enhanced Edition'

ARCHIVE_GOG='icewind_dale_enhanced_edition_en_2_5_16_3_20626.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/icewind_dale_enhanced_edition'
ARCHIVE_GOG_MD5='f237e9506f046862e8d1c2d21c8fd588'
ARCHIVE_GOG_SIZE='2900000'
ARCHIVE_GOG_VERSION='2.5.16.3-gog20626'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='gog_icewind_dale_enhanced_edition_2.1.0.5.sh'
ARCHIVE_GOG_OLD_MD5='fc7244f4793eec365b8ac41d91a4edbb'
ARCHIVE_GOG_OLD_SIZE='2900000'
ARCHIVE_GOG_OLD_VERSION='1.4.0-gog2.1.0.5'

ARCHIVE_LIBSSL_32='libssl_1.0.0_32-bit.tar.gz'
ARCHIVE_LIBSSL_32_MD5='9443cad4a640b2512920495eaf7582c4'

ARCHIVE_ICONS_PACK='icewind-dale-enhanced-edition_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='afe7a2a8013a859f7b56a3104eacd783'

ARCHIVE_DOC_PATH='data/noarch/docs'
ARCHIVE_DOC_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./IcewindDale'

ARCHIVE_GAME_L10N_PATH='data/noarch/game'
ARCHIVE_GAME_L10N_FILES='./lang'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./data ./movies ./music ./scripts ./chitin.key'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./32x32 ./48x48 ./64x64 ./128x128 ./256x256'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='IcewindDale'
APP_MAIN_ICON_GOG='data/noarch/support/icon.png'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_DESCRIPTION='localizations'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID glibc libstdc++ glx openal json"
PKG_BIN_DEPS_ARCH='lib32-openssl-1.0'

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

# Try to load icons archive

ARCHIVE_MAIN="$ARCHIVE"
archive_set 'ARCHIVE_ICONS' 'ARCHIVE_ICONS_PACK'
ARCHIVE="$ARCHIVE_MAIN"

# Use libSSL 1.0.0 32-bit archive unless building for Arch Linux

if [ "$OPTION_PACKAGE" != 'arch' ]; then
	ARCHIVE_MAIN="$ARCHIVE"
	archive_set 'ARCHIVE_LIBSSL' 'ARCHIVE_LIBSSL_32'
	ARCHIVE="$ARCHIVE_MAIN"
fi

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout

# Get icons

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	(
		ARCHIVE='ARCHIVE_ICONS'
		extract_data_from "$ARCHIVE_ICONS"
	)
	organize_data 'ICONS' "$PATH_ICON_BASE"
else
	get_icon_from_temp_dir 'APP_MAIN'
fi
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Include libSSL into the game directory

if [ "$ARCHIVE_LIBSSL" ]; then
	(
		ARCHIVE='ARCHIVE_LIBSSL'
		extract_data_from "$ARCHIVE_LIBSSL"
	)
	dir='libs'
	mkdir --parents "${PKG_BIN_PATH}${PATH_GAME}/$dir"
	mv "$PLAYIT_WORKDIR/gamedata"/* "${PKG_BIN_PATH}${PATH_GAME}/$dir"
	APP_MAIN_LIBS="$dir"
	rm --recursive "$PLAYIT_WORKDIR/gamedata"
fi

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

cat > "$postinst" << EOF
if [ ! -e /lib/i386-linux-gnu/libjson.so.0 ]; then
	if [ -e /lib/i386-linux-gnu/libjson-c.so ] ; then
		ln --symbolic libjson-c.so /lib/i386-linux-gnu/libjson.so.0
	elif [ -e /lib/i386-linux-gnu/libjson-c.so.2 ] ; then
		ln --symbolic libjson-c.so.2 /lib/i386-linux-gnu/libjson.so.0
	elif [ -e /lib/i386-linux-gnu/libjson-c.so.3 ] ; then
		ln --symbolic libjson-c.so.3 /lib/i386-linux-gnu/libjson.so.0
	fi
fi
if [ ! -e /usr/lib32/libjson.so.0 ] && [ -e /usr/lib32/libjson-c.so ] ; then
	ln --symbolic libjson-c.so /usr/lib32/libjson.so.0
fi
EOF

write_metadata 'PKG_BIN'
write_metadata 'PKG_L10N' 'PKG_DATA'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
