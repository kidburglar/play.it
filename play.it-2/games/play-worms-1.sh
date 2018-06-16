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
# Worms United
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180506.1

# Set game-specific variables

GAME_ID='worms-1'
GAME_NAME='Worms United'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_worms_united_2.0.0.20.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/worms_united'
ARCHIVE_GOG_MD5='619421cafa20f478d19222e3f49d77b6'
ARCHIVE_GOG_SIZE='220000'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.20'

CONFIG_FILES='./worms.cfg'
DATA_DIRS='./data'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./docs ./manual.pdf'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./bin ./*.exe'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./batch ./data ./extras ./gfw_high.ico ./worms*.ogg ./worms.cfg ./worms.dat ./worms.gog'

GAME_IMAGE='worms.dat'

APP_MAIN_TYPE='dosbox'
APP_MAIN_PRERUN='SET wormscfg=C:\\worms.cfg
SET wormscd=D:
D:\\fmv\\play /modex D:\\fmv\\logo2.avi
D:\\fmv\\play /modex D:\\fmv\\logo1.avi
D:\\fmv\\play /modex D:\\fmv\\cinadd.avi
D:\\fmv\\play /modex D:\\fmv\\armup.avi
bin\\black.exe'
APP_MAIN_EXE='bin\wrms.exe'
APP_MAIN_ICON='gfw_high.ico'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID dosbox"

# Load common functions

target_version='2.8'

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
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Extract icons

PKG='PKG_DATA'
icons_get_from_package 'APP_MAIN'
rm "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
