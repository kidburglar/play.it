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
# Chaos Reborn
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='chaos-reborn'
GAME_NAME='Chaos Reborn'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST'

ARCHIVE_GOG='chaos_reborn_en_1_13_2_17223.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/chaos_reborn'
ARCHIVE_GOG_MD5='edb60d98710c87c0adea06f55be99567'
ARCHIVE_GOG_SIZE='1700000'
ARCHIVE_GOG_TYPE='mojosetup'
ARCHIVE_GOG_VERSION='1.13.2-gog17223'

ARCHIVE_GOG_OLD='chaos_reborn_en_1_131_14290.sh'
ARCHIVE_GOG_OLD_MD5='fcfea11ad6a6cbdda2290c4f29bbeb2b'
ARCHIVE_GOG_OLD_SIZE='1700000'
ARCHIVE_GOG_OLD_TYPE='mojosetup'
ARCHIVE_GOG_OLD_VERSION='1.13.1-gog14290'

ARCHIVE_GOG_OLDER='gog_chaos_reborn_2.14.0.16.sh'
ARCHIVE_GOG_OLDER_MD5='97dbfc0a679a7fd104c744b6aa46db36'
ARCHIVE_GOG_OLDER_SIZE='1700000'
ARCHIVE_GOG_OLDER_VERSION='1.13-gog2.14.0.16'

ARCHIVE_GOG_OLDEST='gog_chaos_reborn_2.13.0.15.sh'
ARCHIVE_GOG_OLDEST_MD5='a2abf12572eea8b43059a9bb8d5d3171'
ARCHIVE_GOG_OLDEST_SIZE='1700000'
ARCHIVE_GOG_OLDEST_VERSION='1.12.2-gog2.13.0.15'

ARCHIVE_DOC1_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC1_DATA_FILES='./*'

ARCHIVE_DOC2_DATA_PATH='data/noarch/game'
ARCHIVE_DOC2_DATA_FILES='./*.txt'

ARCHIVE_GAME_BIN32_PATH='data/noarch/game'
ARCHIVE_GAME_BIN32_FILES='./*.x86 *_Data/*/x86'

ARCHIVE_GAME_BIN64_PATH='data/noarch/game'
ARCHIVE_GAME_BIN64_FILES='./*.x86_64 *_Data/*/x86_64'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./*_Data'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='file="$HOME/.config/unity3d/Snapshot Games Inc_/Chaos Reborn/prefs"
mkdir --parents "${file%/*}"
if [ ! -e "$file" ]; then
	cat > "$file" <<- EOF
		<unity_prefs version_major="1" version_minor="1">
		<pref name="Screenmanager Is Fullscreen mode" type="int">0</pref>
		</unity_prefs>
	EOF
fi'
APP_MAIN_EXE_BIN32='ChaosRebornLinux.x86'
APP_MAIN_EXE_BIN64='ChaosRebornLinux.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='*_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_BIN32 PKG_BIN64 PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN32_ARCH='32'
PKG_BIN32_DEPS="$PKG_DATA_ID glibc libstdc++ glu xcursor"

PKG_BIN64_ARCH='64'
PKG_BIN64_DEPS="$PKG_BIN32_DEPS"

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

for PKG in $PACKAGES_LIST; do
	organize_data "DOC1_${PKG#PKG_}" "$PATH_DOC"
	organize_data "DOC2_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

for PKG in 'PKG_BIN32' 'PKG_BIN64'; do
	write_launcher 'APP_MAIN'
done

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN32' 'PKG_BIN64'
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
