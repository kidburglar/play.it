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
# Nihilumbra
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='nihilumbra'
GAME_NAME='Nihilumbra'

ARCHIVES_LIST='ARCHIVE_HUMBLE_32 ARCHIVE_HUMBLE_64'

ARCHIVE_HUMBLE_32='Nihilumbra-1.35-linux32.tar.gz'
ARCHIVE_HUMBLE_32_URL='https://www.humblebundle.com/store/nihilumbra'
ARCHIVE_HUMBLE_32_MD5='24ba59112bdb95b05651ebe48ec5882d'
ARCHIVE_HUMBLE_32_SIZE='2400000'
ARCHIVE_HUMBLE_32_VERSION='1.35-humble150122'

ARCHIVE_HUMBLE_64='Nihilumbra-1.35-linux64.tar.gz'
ARCHIVE_HUMBLE_64_URL='https://www.humblebundle.com/store/nihilumbra'
ARCHIVE_HUMBLE_64_MD5='18aa096020cedea4f208ca55f7e5c85f'
ARCHIVE_HUMBLE_64_SIZE='2400000'
ARCHIVE_HUMBLE_64_VERSION='1.35-humble150122'

ARCHIVE_GAME_PATH_HUMBLE_32='Nihilumbra-1.35-linux32'
ARCHIVE_GAME_PATH_HUMBLE_64='Nihilumbra-1.35-linux64'
ARCHIVE_GAME_FILES='./icon128x128.png ./icon32x32.png ./icon48x48.png ./icon48x48.xpm ./icon64x64.png ./Nihilumbra_Data ./Nihilumbra'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='Nihilumbra'
unset APP_MAIN_ICONS_LIST
for res in 32 48 64 128; do
	APP_MAIN_ICONS_LIST="$APP_MAIN_ICONS_LIST APP_MAIN_ICON_${res}"
	export APP_MAIN_ICON_${res}="icon${res}x${res}.png"
	export APP_MAIN_ICON_${res}_RES="$res"
done

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_ARCH_HUMBLE_32='32'
PKG_MAIN_ARCH_HUMBLE_64='64'
PKG_MAIN_DEPS_DEB='libc6, libstdc++6, libxcursor1, libxrandr2, libglu1-mesa | libglu1'
PKG_MAIN_DEPS_ARCH_HUMBLE_32='lib32-libxcursor lib32-libxrandr lib32-glu'
PKG_MAIN_DEPS_ARCH_HUMBLE_64='libxcursor libxrandr glu'

# Load common functions

target_version='2.1'

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

organize_data 'GAME' "$PATH_GAME"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

write_launcher 'APP_MAIN'

# Build package

PATH_ICON="$PATH_ICON_BASE/48x48/apps"
cat > "$postinst" << EOF
if [ ! -e "$PATH_ICON/${GAME_ID}.xpm" ]; then
	mkdir --parents "$PATH_ICON"
	ln --symbolic "$PATH_GAME/icon48x48.xpm" "$PATH_ICON/${GAME_ID}.xpm"
fi
EOF
cat > "$prerm" << EOF
if [ -e "$PATH_ICON/${GAME_ID}.xpm" ]; then
	rm --force "$PATH_ICON/${GAME_ID}.xpm"
	rmdir --ignore-fail-on-non-empty "$PATH_ICON"
fi
EOF
postinst_icons_linking 'APP_MAIN'
write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
