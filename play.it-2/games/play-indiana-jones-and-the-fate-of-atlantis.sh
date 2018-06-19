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
# Indiana Jones and the Fate of Atlantis
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180619.1

# Set game-specific variables

GAME_ID='indiana-jones-and-the-fate-of-atlantis'
GAME_NAME='Indiana Jones and the Fate of Atlantis'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_EN_OLD ARCHIVE_GOG_FR ARCHIVE_GOG_FR_OLD'

ARCHIVE_GOG_EN='indiana_jones_and_the_fate_of_atlantis_en_gog_2_20145.sh'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/indiana_jones_and_the_fate_of_atlantis'
ARCHIVE_GOG_EN_MD5='f7c093e148b001520809032095d7e8d7'
ARCHIVE_GOG_EN_SIZE='390000'
ARCHIVE_GOG_EN_VERSION='1.0-gog20145'
ARCHIVE_GOG_EN_TYPE='mojosetup'

ARCHIVE_GOG_EN_OLD='gog_indiana_jones_and_the_fate_of_atlantis_2.2.0.27.sh'
ARCHIVE_GOG_EN_OLD_MD5='d56a5850b9d1d4f82eebc282ef7fb52b'
ARCHIVE_GOG_EN_OLD_SIZE='250000'
ARCHIVE_GOG_EN_OLD_VERSION='1.0-gog2.2.0.27'

ARCHIVE_GOG_FR='indiana_jones_and_the_fate_of_atlantis_fr_gog_2_20145.sh'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/indiana_jones_and_the_fate_of_atlantis'
ARCHIVE_GOG_FR_MD5='edbfebcf9daa23e329e41ccf9c89286c'
ARCHIVE_GOG_FR_SIZE='240000'
ARCHIVE_GOG_FR_VERSION='1.0-gog20145'
ARCHIVE_GOG_FR_TYPE='mojosetup'

ARCHIVE_GOG_FR_OLD='gog_indiana_jones_and_the_fate_of_atlantis_french_2.2.0.27.sh'
ARCHIVE_GOG_FR_OLD_MD5='0da3a8b3d0505c86a9f863c27debbca7'
ARCHIVE_GOG_FR_OLD_SIZE='99000'
ARCHIVE_GOG_FR_OLD_VERSION='1.0-gog2.2.0.27'

ARCHIVE_DOC_MAIN_PATH='data/noarch/docs'
ARCHIVE_DOC_MAIN_FILES='./*.pdf ./*.txt'

ARCHIVE_GAME_MAIN_PATH='data/noarch/data'
ARCHIVE_GAME_MAIN_FILES='./atlantis.000 ./atlantis.001 ./monster.sou'

APP_MAIN_TYPE='scummvm'
APP_MAIN_SCUMMID='atlantis'
APP_MAIN_ICON='data/noarch/support/icon.png'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_ID="$GAME_ID"
PKG_MAIN_ID_GOG_EN="${GAME_ID}-en"
PKG_MAIN_ID_GOG_FR="${GAME_ID}-fr"
PKG_MAIN_PROVIDE="$PKG_MAIN_ID"
PKG_MAIN_DEPS_DEB='scummvm'
PKG_MAIN_DEPS_ARCH='scummvm'

# Load common functions

target_version='2.9'

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

# Extract data from game

extract_data_from "$SOURCE_ARCHIVE"
tolower "$PLAYIT_WORKDIR/gamedata"
prepare_package_layout

# Get icon

icons_get_from_workdir 'APP_MAIN'
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
