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
# Gobliins 2: The Prince Buffoon
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180426.1

# Set game-specific variables

GAME_ID='gobliins-2'
GAME_NAME='Gobliins 2: The Prince Buffoon'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_gobliiins2_2.1.0.63.exe'
ARCHIVE_GOG_MD5='0baf2ce55d00fce9af4c98848e88d7dc'
ARCHIVE_GOG_SIZE='100000'
ARCHIVE_GOG_VERSION='2.01-gog2.1.0.63'
ARCHIVE_GOG_VERSION_DATA_DISK='2.01-gog2.1.0.63'
ARCHIVE_GOG_VERSION_DATA_FLOPPY='1.02-gog2.1.0.63'

ARCHIVE_GAME_DATA_DISK_PATH='app'
ARCHIVE_GAME_DATA_DISK_FILES='./gobnew.lic ./intro.stk ./track1.mp3'

ARCHIVE_GAME_DATA_FLOPPY_PATH='app/fdd'
ARCHIVE_GAME_DATA_FLOPPY_FILES='./*'

ARCHIVE_DOC_MAIN_PATH='app'
ARCHIVE_DOC_MAIN_FILES='./*.pdf'

ARCHIVE_GAME_MAIN_PATH='app'
ARCHIVE_GAME_MAIN_FILES='./goggame-1207662293.ico'

APP_MAIN_TYPE='scummvm'
APP_MAIN_SCUMMID='gob'
APP_MAIN_ICON='goggame-1207662293.ico'
APP_MAIN_ICON_RES='16 32 48 256'

PACKAGES_LIST='PKG_MAIN PKG_DATA_DISK PKG_DATA_FLOPPY'

PKG_DATA_ID="${GAME_ID}-data"

PKG_DATA_DISK_ID="${PKG_DATA_ID}-disk"
PKG_DATA_DISK_PROVIDE="$PKG_DATA_ID"
PKG_DATA_DISK_DESCRIPTION='data - CD-ROM version'

PKG_DATA_FLOPPY_ID="${PKG_DATA_ID}-floppy"
PKG_DATA_FLOPPY_PROVIDE="$PKG_DATA_ID"
PKG_DATA_FLOPPY_DESCRIPTION='data - floppy version'

PKG_MAIN_DEPS="$PKG_DATA_ID scummvm"

# Load common functions

target_version='2.7'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	if [ -e "$XDG_DATA_HOME/play.it/play.it-2/lib/libplayit2.sh" ]; then
		PLAYIT_LIB2="$XDG_DATA_HOME/play.it/play.it-2/lib/libplayit2.sh"
	elif [ -e './libplayit2.sh' ]; then
		PLAYIT_LIB2='./libplayit2.sh'
	else
		printf '\n\033[1;31mError:\033[0m\n'
		printf 'libplayit2.sh not found.\n'
		return 1
	fi
fi
. "$PLAYIT_LIB2"


# Extract data from game

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout
organize_data 'GAME_MAIN' "$PATH_GAME"

PKG='PKG_MAIN'
extract_and_sort_icons_from 'APP_MAIN'
rm "${PKG_MAIN_PATH}${PATH_GAME}/$APP_MAIN_ICON"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_MAIN'
write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

case "${LANG%_*}" in
	('fr')
		version_string='version %s :'
		version_disk='CD-ROM'
		version_floppy='disquette'
	;;
	('en'|*)
		version_string='%s version:'
		version_disk='CD-ROM'
		version_floppy='Floppy'
	;;
esac
printf '\n'
printf "$version_string" "$version_disk"
print_instructions 'PKG_DATA_DISK' 'PKG_MAIN'
printf "$version_string" "$version_floppy"
print_instructions 'PKG_DATA_FLOPPY' 'PKG_MAIN'

exit 0
