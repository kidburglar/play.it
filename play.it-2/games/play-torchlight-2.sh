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
# Torchlight II
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='torchlight-2'
GAME_NAME='Torchlight II'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_HUMBLE'

ARCHIVE_GOG='gog_torchlight_2_2.0.0.2.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/torchlight_ii'
ARCHIVE_GOG_MD5='e107f6d4c6d4cecea37ade420a8d4892'
ARCHIVE_GOG_SIZE='1700000'
ARCHIVE_GOG_VERSION='1.25.9.7-gog2.0.0.2'

ARCHIVE_HUMBLE='Torchlight2-linux-2015-04-01.sh'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/torchlight-ii'
ARCHIVE_HUMBLE_MD5='730a5d08c8f1cd4a65afbc0ca631d85c'
ARCHIVE_HUMBLE_SIZE='1700000'
ARCHIVE_HUMBLE_VERSION='1.25.2.4-humble150402'
ARCHIVE_HUMBLE_TYPE='mojosetup'

ARCHIVE_DOC1_DATA_PATH_GOG='data/noarch/docs'
ARCHIVE_DOC1_DATA_FILES='./*'

ARCHIVE_DOC2_DATA_PATH_HUMBLE='data'
ARCHIVE_DOC2_DATA_FILES='./EULA'

ARCHIVE_DOC3_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_DOC3_DATA_PATH_HUMBLE='data/noarch'
ARCHIVE_DOC3_DATA_FILES='./licenses'

ARCHIVE_GAME_BIN32_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN32_PATH_HUMBLE='data/x86'
ARCHIVE_GAME_BIN32_FILES='./lib ./*.bin.x86'

ARCHIVE_GAME_BIN64_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN64_PATH_HUMBLE='data/x86_64'
ARCHIVE_GAME_BIN64_FILES='./lib64 ./*.bin.x86_64'

ARCHIVE_GAME_MEDIA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_MEDIA_PATH_HUMBLE='data/noarch'
ARCHIVE_GAME_MEDIA_FILES='./movies ./music'

ARCHIVE_GAME_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_HUMBLE='data/noarch'
ARCHIVE_GAME_DATA_FILES='./*.bmp ./*.cfg ./*.png ./icons ./PAKS ./porting ./programs'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_BIN32='Torchlight2.bin.x86'
APP_MAIN_EXE_BIN64='Torchlight2.bin.x86_64'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='Delvers.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_MEDIA PKG_DATA PKG_BIN32 PKG_BIN64'

PKG_MEDIA_ID="${GAME_ID}-media"
PKG_MEDIA_DESCRIPTION='movies & music'

PKG_BIN32_ARCH='32'
PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_MEDIA_ID $PKG_DATA_ID glibc libstdc++ sdl2 freetype glx"
PKG_BIN32_DEPS_ARCH='lib32-bzip2 lib32-libxft'
PKG_BIN32_DEPS_DEB='libbz2-1.0, libxft2'

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"
PKG_BIN64_DEPS_ARCH='bzip2 libxft'
PKG_BIN64_DEPS_DEB="$PKG_BIN32_DEPS_DEB"

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
set_standard_permissions "$PLAYIT_WORKDIR/gamedata"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC1_${PKG#PKG_}" "$PATH_DOC"
	organize_data "DOC2_${PKG#PKG_}" "$PATH_DOC"
	organize_data "DOC3_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

chmod +x "${PKG_BIN32_PATH}${PATH_GAME}"/*.bin.x86
chmod +x "${PKG_BIN64_PATH}${PATH_GAME}"/*.bin.x86_64

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_MEDIA' 'PKG_BIN32' 'PKG_BIN64'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

printf '\n'
printf '32-bit:'
print_instructions 'PKG_MEDIA' 'PKG_DATA' 'PKG_BIN32'
printf '64-bit:'
print_instructions 'PKG_MEDIA' 'PKG_DATA' 'PKG_BIN64'

exit 0
