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
# Xenonauts
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180616.1

# Set game-specific variables

GAME_ID='unreal-tournament'
GAME_NAME='Unreal Tournament'

ARCHIVE_GOG='setup_ut_goty_2.0.0.5.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/unreal_tournament_goty'
ARCHIVE_GOG_MD5='0d25ec835648710a098aff7106187f38'
ARCHIVE_GOG_TYPE='innosetup_nolowercase'
ARCHIVE_GOG_SIZE='640000'
ARCHIVE_GOG_VERSION='451-gog2.0.0.5'

ARCHIVE_LOKI_LINUX_CLIENT='ut99v451-linux.tar.gz'
ARCHIVE_LOKI_LINUX_CLIENT_URL='https://www.dotslashplay.it/ressources/unreal-tournament/'
ARCHIVE_LOKI_LINUX_CLIENT_MD5='d645b0ea2d093e68afc8f1b5288496e5'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./Help/* ./Manual/manual.pdf'

ARCHIVE_GAME_BIN_PATH='.'
ARCHIVE_GAME_BIN_FILES='./System/*-bin ./System/*.so*'

ARCHIVE_GAME0_DATA_PATH='app'
ARCHIVE_GAME0_DATA_FILES='./Maps ./Music ./Sounds ./Textures ./Web ./System/*.ini ./System/*.u ./System/*.int'

ARCHIVE_GAME1_DATA_PATH='.'
ARCHIVE_GAME1_DATA_FILES='./Web ./System/*.ini ./System/*.u ./System/*.int'

CONFIG_FILES='./System/*.ini'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN_ARCH='pulseaudio --start
export LD_PRELOAD="/usr/lib32/pulseaudio/libpulsedsp.so"'
APP_MAIN_PRERUN_DEB='pulseaudio --start
export LD_PRELOAD="/usr/lib/i386-linux-gnu/pulseaudio/libpulsedsp.so"'
APP_MAIN_EXE='System/ut-bin'
APP_MAIN_ICON='app/System/UnrealTournament.exe'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID glibc libstdc++ sdl1.2 pulseaudio"
PKG_BIN_DEPS_ARCH='lib32-libpulse'
PKG_BIN_DEPS_DEB='libpulsedsp'

# Load common functions

target_version='2.9'

[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"

if [ -z "$PLAYIT_LIB2" ]; then
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

# Check presence of Linux client archive

ARCHIVE_MAIN="$ARCHIVE"
archive_set 'ARCHIVE_LINUX_CLIENT' 'ARCHIVE_LOKI_LINUX_CLIENT'
[ "$ARCHIVE_LINUX_CLIENT" ] || archive_set_error_not_found 'ARCHIVE_LOKI_LINUX_CLIENT'
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout

# Extract icon

PKG='PKG_DATA'
icons_get_from_workdir 'APP_MAIN'
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Include Linux client

(
	ARCHIVE='ARCHIVE_LINUX_CLIENT'
	extract_data_from "$ARCHIVE_LINUX_CLIENT"
)
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
case $OPTION_PACKAGE in
	('arch')
		APP_MAIN_PRERUN="$APP_MAIN_PRERUN_ARCH"
	;;
	('deb')
		APP_MAIN_PRERUN="$APP_MAIN_PRERUN_DEB"
	;;
	(*)
		liberror 'OPTION_PACKAGE' "$0"
	;;
esac
write_launcher 'APP_MAIN'

# Set working directory to the directory containing the game binary before running it

pattern='s|^cd "$PATH_PREFIX"$|cd "$PATH_PREFIX/${APP_EXE%/*}"|'
pattern="$pattern"';s|^"\./$APP_EXE"|"./${APP_EXE##*/}"|'
sed --in-place "$pattern" "${PKG_BIN_PATH}${PATH_BIN}/$GAME_ID"

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
