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
# Baldur’s Gate - Enhanced Edition
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180605.1

# Set game-specific variables

GAME_ID='baldurs-gate-enhanced-edition'
GAME_NAME='Baldur’s Gate - Enhanced Edition'

ARCHIVE_GOG='baldur_s_gate_enhanced_edition_en_2_3_67_3_20146.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/baldurs_gate_enhanced_edition'
ARCHIVE_GOG_MD5='4d08fe21fcdeab51624fa2e0de2f5813'
ARCHIVE_GOG_SIZE='3200000'
ARCHIVE_GOG_VERSION='2.3.67.3-gog20146'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='gog_baldur_s_gate_enhanced_edition_2.5.0.9.sh'
ARCHIVE_GOG_OLD_MD5='224be273fd2ec1eb0246f407dda16bc4'
ARCHIVE_GOG_OLD_SIZE='3200000'
ARCHIVE_GOG_OLD_VERSION='2.3.67.3-gog2.5.0.9'

ARCHIVE_GOG_OLDER='gog_baldur_s_gate_enhanced_edition_2.5.0.7.sh'
ARCHIVE_GOG_OLDER_MD5='37ece59534ca63a06f4c047d64b82df9'
ARCHIVE_GOG_OLDER_SIZE='3200000'
ARCHIVE_GOG_OLDER_VERSION='2.3.67.3-gog2.5.0.7'

ARCHIVE_LIBSSL_32='libssl_1.0.0_32-bit.tar.gz'
ARCHIVE_LIBSSL_32_MD5='9443cad4a640b2512920495eaf7582c4'

ARCHIVE_ICONS_PACK='baldurs-gate-enhanced-edition_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='364512a51e235ac3a6f4d237283ea10f'

ARCHIVE_GOG_SOD='baldur_s_gate_siege_of_dragonspear_en_2_3_0_4_20148.sh'
ARCHIVE_GOG_SOD_URL='https://www.gog.com/game/baldurs_gate_siege_of_dragonspear'
ARCHIVE_GOG_SOD_MD5='152225ec02c87e70bfb59970ac33b755'
ARCHIVE_GOG_SOD_VERSION='2.3.0.4-gog20148'
ARCHIVE_GOG_SOD_TYPE='mojosetup_unzip'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./BaldursGate ./engine.lua'

ARCHIVE_GAME_L10N_PATH='data/noarch/game'
ARCHIVE_GAME_L10N_FILES='./lang'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./movies ./music ./chitin.key ./Manuals ./scripts ./data'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./24x42 ./32x32 ./48x48 ./64x64 ./256x256'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='BaldursGate'
APP_MAIN_ICON='data/noarch/support/icon.png'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_DESCRIPTION='localizations'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID glibc libstdc++ glx openal json libxrandr"
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

# Use libSSL 1.0.0 32-bit archive unless building for Arch Linux

if [ "$OPTION_PACKAGE" != 'arch' ]; then
	ARCHIVE_MAIN="$ARCHIVE"
	set_archive 'ARCHIVE_LIBSSL' 'ARCHIVE_LIBSSL_32'
	ARCHIVE="$ARCHIVE_MAIN"
fi

# Try to load icons archive

ARCHIVE_MAIN="$ARCHIVE"
archive_set 'ARCHIVE_ICONS' 'ARCHIVE_ICONS_PACK'
ARCHIVE="$ARCHIVE_MAIN"

ARCHIVE_MAIN="$ARCHIVE"
archive_set 'ARCHIVE_SOD' 'ARCHIVE_GOG_SOD'
ARCHIVE="$ARCHIVE_MAIN"

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
	icons_get_from_workdir 'APP_MAIN'
fi
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Attempt to include SOD into the game directory

if [ "$ARCHIVE_SOD" ]; then
	(
		ARCHIVE='ARCHIVE_SOD'
		extract_data_from "$ARCHIVE_SOD"
	)
	mv "$PLAYIT_WORKDIR/gamedata/data/noarch/game/sod-dlc.zip" "${PKG_DATA_PATH}/${PATH_GAME}"
	rm --recursive "$PLAYIT_WORKDIR/gamedata"
fi

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
