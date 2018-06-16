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
# Baldur’s Gate 2 - Enhanced Edition
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='baldurs-gate-2-enhanced-edition'
GAME_NAME='Baldur’s Gate 2 - Enhanced Edition'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_baldur_s_gate_2_enhanced_edition_2.6.0.11.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/baldurs_gate_2_enhanced_edition'
ARCHIVE_GOG_MD5='b9ee856a29238d4aec65367377d88ac4'
ARCHIVE_GOG_SIZE='2700000'
ARCHIVE_GOG_VERSION='2.3.67.3-gog2.6.0.11'

ARCHIVE_LIBSSL_32='libssl_1.0.0_32-bit.tar.gz'
ARCHIVE_LIBSSL_32_MD5='9443cad4a640b2512920495eaf7582c4'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./BaldursGateII ./engine.lua'

ARCHIVE_GAME_AREAS_PATH='data/noarch/game'
ARCHIVE_GAME_AREAS_FILES='./data/AREA*.bif ./data/Areas.bif ./data/25Areas.bif ./data/ARMisc.bif ./data/25ArMisc.bif'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./chitin.key ./lang ./Manuals ./movies ./music ./scripts ./data/*Anim.bif ./data/*Items.bif ./data/*Sound.bif ./data/*Cre* ./data/25AmbSnd.bif ./data/25Deflt.bif ./data/25Dialog.bif ./data/25Effect.bif ./data/25Gui* ./data/25MiscAn.bif ./data/25NpcSo.bif ./data/25Portrt.bif ./data/25Projct.bif ./data/25Scripts.bif ./data/25SndFX.bif ./data/25SpelAn.bif ./data/25Spells.bif ./data/25Store.bif ./data/bgee* ./data/BlackPits.bif ./data/characters.bif ./data/CREAnim1.bif ./data/Default.bif ./data/DIALOG.BIF ./data/Dorn.bif ./data/ee* ./data/Effects.bif ./data/fonts.bif ./data/GUI* ./data/Hd0* ./data/Hexxat.bif ./data/Neera.bif ./data/NPC* ./data/orphan.bif ./data/PaperDol.bif ./data/patch13.bif ./data/Patch2.bif ./data/Portrait.bif ./data/Project.bif ./data/Rasaad.bif ./data/Scripts.bif ./data/Shaders.bif ./data/Spells.bif ./data/STORES.BIF'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='BaldursGateII'
APP_MAIN_ICON='data/noarch/support/icon.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_AREAS PKG_DATA PKG_BIN'

PKG_AREAS_ID="${GAME_ID}-areas"
PKG_AREAS_DESCRIPTION='areas'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_AREAS_ID $PKG_L10N_ID $PKG_DATA_ID glibc libstdc++ glx openal json"
PKG_BIN_DEPS_ARCH='lib32-openssl-1.0'

# Load common functions

target_version='2.5'

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

# Use libSSL 1.0.0 32-bit archive

if [ "$OPTION_PACKAGE" != 'arch' ]; then
	ARCHIVE_MAIN="$ARCHIVE"
	set_archive 'ARCHIVE_LIBSSL' 'ARCHIVE_LIBSSL_32'
	ARCHIVE="$ARCHIVE_MAIN"
fi

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_DATA'
get_icon_from_temp_dir 'APP_MAIN'

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
elif [ ! -e /usr/lib32/libjson.so.0 ] && [ -e /usr/lib32/libjson-c.so ] ; then
	ln --symbolic libjson-c.so /usr/lib32/libjson.so.0
fi
EOF

write_metadata 'PKG_BIN'
write_metadata 'PKG_AREAS' 'PKG_DATA'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
