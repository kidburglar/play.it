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
# Mark of the Ninja - Special Edition
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180303.1

# Set game-specific variables

GAME_ID='mark-of-the-ninja'
GAME_ID_DLC="${GAME_ID}-special-edition"
GAME_NAME='Mark of the Ninja - Special Edition'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='gog_mark_of_the_ninja_special_edition_dlc_2.0.0.4.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/mark_of_the_ninja_special_edition_upgrade'
ARCHIVE_GOG_MD5='bbce70b80932ec9c14fbedf0b6b33eb1'
ARCHIVE_GOG_SIZE='250000'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.4'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./bin/*32*'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./bin/*64*'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./dlc'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID_DLC}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ID="$GAME_ID_DLC"
PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$GAME_ID $PKG_DATA_ID glibc libstdc++ glx sdl2"

PKG_BIN64_ID="$GAME_ID_DLC"
PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
set_standard_permissions "$PLAYIT_WORKDIR/gamedata"

for PKG in $PACKAGES_LIST; do
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

(
	cd "${PKG_BIN32_PATH}${PATH_GAME}/bin"
	chmod +x 'ninja-bin32'
	mv 'ninja-bin32' 'ninja-bin32.dlc'
	cd "${PKG_BIN64_PATH}${PATH_GAME}/bin"
	chmod +x 'ninja-bin64'
	mv 'ninja-bin64' 'ninja-bin64.dlc'
)


rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Build package

write_metadata 'PKG_DATA'

cat > "$postinst" << EOF
(
	cd "$PATH_GAME/bin"
	mv 'ninja-bin32' 'ninja-bin32.orig'
	ln --symbolic './ninja-bin32.dlc' 'ninja-bin32'
)
EOF
cat > "$prerm" << EOF
(
	cd "$PATH_GAME/bin"
	rm 'ninja-bin32'
	mv 'ninja-bin32.orig' 'ninja-bin32'
)
EOF
write_metadata 'PKG_BIN32'

cat > "$postinst" << EOF
(
	cd "$PATH_GAME/bin"
	mv 'ninja-bin64' 'ninja-bin64.orig'
	ln --symbolic './ninja-bin64.dlc' 'ninja-bin64'
)
EOF
cat > "$prerm" << EOF
(
	cd "$PATH_GAME/bin"
	rm 'ninja-bin64'
	mv 'ninja-bin64.orig' 'ninja-bin64'
)
EOF
write_metadata 'PKG_BIN64'

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
