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
# The Guild 2
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='the-guild-2'
GAME_NAME='The Guild 2'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_the_guild2_2.0.0.4.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/the_guild_2'
ARCHIVE_GOG_MD5='2b14191f4831b3486e95d52245d6cc64'
ARCHIVE_GOG_SIZE='2400000'
ARCHIVE_GOG_VERSION='1.4-gog2.0.0.4'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./manual.pdf ./*.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./dbghelp.dll ./config.ini ./fmod.dll ./guildii.exe ./input.ini ./mfc71.dll ./msvcp71.dll ./msvcr71.dll ./stlport.5.0.dll ./userconfig.ini'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./camerapaths ./db ./editor ./gui ./logfile.log ./movie ./msx ./objects ./particles ./resource ./savegames ./scenes ./scripts ./sfx ./shader ./shots ./sim_commands.dat ./textures ./worlds'

CONFIG_FILES='./*.ini'

APP_WINETRICKS="vd=\$(xrandr|grep '\*'|awk '{print \$1}')"

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='guildii.exe'
APP_MAIN_ICON='guildii.exe'
APP_MAIN_ICON_RES='32'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine winetricks"

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

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"    "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}"   "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Disable intro movie

pattern='s/^\(SplashScreen\)\t.\+/\1 = 0/'
file="${PKG_BIN_PATH}${PATH_GAME}/config.ini"
sed --in-place "$pattern" "$file"

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
