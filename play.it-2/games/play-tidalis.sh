#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2018, Antoine Le Gonidec
# Copyright (c) 2018, Solène Huault
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
# Tidalis
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180528.1

# Set game-specific variables

GAME_ID='tidalis'
GAME_NAME='Tidalis'

ARCHIVES_LIST='ARCHIVE_HUMBLE_32 ARCHIVE_HUMBLE_64'

ARCHIVE_HUMBLE_32='Tidalis_Linux32_v1.5.zip'
ARCHIVE_HUMBLE_32_URL='https://www.humblebundle.com/store/tidalis'
ARCHIVE_HUMBLE_32_MD5='c5fd83dd7e6221a5a91e326fc36c9043'
ARCHIVE_HUMBLE_32_SIZE='630000'
ARCHIVE_HUMBLE_32_VERSION='1.5-humble160517'

ARCHIVE_HUMBLE_64='Tidalis_Linux64_v1.5.zip'
ARCHIVE_HUMBLE_64_URL='https://www.humblebundle.com/store/tidalis'
ARCHIVE_HUMBLE_64_MD5='d5893c3ed40ab2266359c88b361ddb57'
ARCHIVE_HUMBLE_64_SIZE='630000'
ARCHIVE_HUMBLE_64_VERSION='1.5-humble160517'

ARCHIVE_DOC_PATH='.'
ARCHIVE_DOC_FILES='./TidalisLicense.txt ./*.pdf'

ARCHIVE_GAME_BIN_PATH='.'
ARCHIVE_GAME_BIN_FILES='./TidalisLinux.x86*'

ARCHIVE_GAME_DATA_PATH='.'
ARCHIVE_GAME_DATA_FILES='./RuntimeData ./Tidalis_Data ./TidalisLinux_Data ./UDA ./sysrequirements.txt'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_HUMBLE_32='TidalisLinux.x86'
APP_MAIN_EXE_HUMBLE_64='TidalisLinux.x86_64'
APP_MAIN_ICON='TidalisLinux_Data/Resources/UnityPlayer.png'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH_HUMBLE_32='32'
PKG_BIN_ARCH_HUMBLE_64='64'
PKG_BIN_DEPS="$PKG_DATA_ID glu glibc xcursor"

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
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
set_standard_permissions "$PLAYIT_WORKDIR/gamedata"
prepare_package_layout

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
use_archive_specific_value 'APP_MAIN_EXE'
write_launcher 'APP_MAIN'

# Build package

PKG='PKG_DATA'
postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
