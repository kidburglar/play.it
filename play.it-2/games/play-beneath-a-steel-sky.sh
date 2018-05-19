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
# Beneath a Steel Sky
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180519.1

# Set game-specific variables

GAME_ID='beneath-a-steel-sky'
GAME_NAME='Beneath a Steel Sky'

ARCHIVE_GOG='beneath_a_steel_sky_en_gog_2_20150.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/beneath_a_steel_sky'
ARCHIVE_GOG_MD5='5cc68247b61ba31e37e842fd04409d98'
ARCHIVE_GOG_SIZE='160000'
ARCHIVE_GOG_VERSION='1.0-gog20150'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='gog_beneath_a_steel_sky_2.1.0.4.sh'
ARCHIVE_GOG_OLD_MD5='603887dd11b4dec2ff43553ce40303a0'
ARCHIVE_GOG_OLD_SIZE='130000'
ARCHIVE_GOG_OLD_VERSION='1.0-gog2.1.0.4'
ARCHIVE_GOG_OLD_TYPE='mojosetup_unzip'

ARCHIVE_DOC0_MAIN_PATH='data/noarch/docs'
ARCHIVE_DOC0_MAIN_FILES='./*.pdf ./*.txt'

ARCHIVE_DOC1_MAIN_PATH='data/noarch/data'
ARCHIVE_DOC1_MAIN_FILES='./*.txt'

ARCHIVE_GAME_MAIN_PATH='data/noarch/data'
ARCHIVE_GAME_MAIN_FILES='./sky.cpt ./sky.dnr ./sky.dsk'

APP_MAIN_TYPE='scummvm'
APP_MAIN_SCUMMID='sky'
APP_MAIN_ICON='data/noarch/support/icon.png'

PACKAGES_LIST='PKG_MAIN'

PKG_MAIN_PROVIDE_ARCH='bass'
PKG_MAIN_DEPS='scummvm'

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
prepare_package_layout


# Get icons

icons_get_from_workdir 'APP_MAIN'
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

write_launcher 'APP_MAIN'

# Build package

if [ "$OPTION_PACKAGE" = 'arch' ]; then
	PKG_MAIN_PROVIDE="$PKG_MAIN_PROVIDE_ARCH"
elif [ "$OPTION_PACKAGE" = 'deb' ]; then
	file="$PKG_MAIN_PATH/etc/apt/preferences.d/$GAME_ID"
	mkdir --parents "${file%/*}"
	cat > "$file" <<- EOF
	Package: $GAME_ID
	Pin: release o=Debian
	Pin-Priority: -1
	EOF
fi

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
