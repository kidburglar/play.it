#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2017, Antoine Le Gonidec
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
# War for the Overworld
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20171216.3

# Set game-specific variables

GAME_ID='war-for-the-overworld'
GAME_NAME='War for the Overworld'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST ARCHIVE_HUMBLE'

ARCHIVE_GOG='war_for_the_overworld_en_1_6_66_16455.sh'
ARCHIVE_GOG_MD5='3317bba3d2ec7dc5715f0d44e6cb70c1'
ARCHIVE_GOG_SIZE='2800000'
ARCHIVE_GOG_VERSION='1.6.66-gog16455'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='war_for_the_overworld_en_1_6_5f1_15803.sh'
ARCHIVE_GOG_OLD_MD5='5fb91f8c86eafeea09c91b36c0c82afe'
ARCHIVE_GOG_OLD_SIZE='2800000'
ARCHIVE_GOG_OLD_VERSION='1.6.5f1-gog15803'
ARCHIVE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_OLDER='war_for_the_overworld_en_1_6_4_15562.sh'
ARCHIVE_GOG_OLDER_MD5='45847e6faf4114e266d0fef99cae42b6'
ARCHIVE_GOG_OLDER_SIZE='2800000'
ARCHIVE_GOG_OLDER_VERSION='1.6.4-gog15562'
ARCHIVE_GOG_OLDER_TYPE='mojosetup'

ARCHIVE_GOG_OLDEST='war_for_the_overworld_en_1_6_4_15447.sh'
ARCHIVE_GOG_OLDEST_MD5='09335b964b387ce911942f6c72ab3fb0'
ARCHIVE_GOG_OLDEST_SIZE='2800000'
ARCHIVE_GOG_OLDEST_VERSION='1.6.4-gog15447'
ARCHIVE_GOG_OLDEST_TYPE='mojosetup'

ARCHIVE_GOG_UNDERLORD='gog_war_for_the_overworld_underlord_edition_upgrade_dlc_2.0.0.1.sh'
ARCHIVE_GOG_UNDERLORD_MD5='635912eed200d45d8907ab1fb4cc53a4'
ARCHIVE_GOG_UNDERLORD_TYPE='mojosetup'

ARCHIVE_HUMBLE='War_for_the_Overworld_v1.5.2_-_Linux_x64.zip'
ARCHIVE_HUMBLE_MD5='bedee8b966767cf42c55c6b883e3127c'
ARCHIVE_HUMBLE_SIZE='2500000'
ARCHIVE_HUMBLE_VERSION='1.5.2-humble170202'

ARCHIVE_DOC_DATA_PATH_GOG='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_BIN_PATH_HUMBLE='Linux'
ARCHIVE_GAME_BIN_FILES='./*.x86_64 ./*_Data/Plugins ./*_Data/Mono ./*_Data/CoherentUI_Host'

ARCHIVE_GAME_ASSETS_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_ASSETS_PATH_HUMBLE='Linux'
ARCHIVE_GAME_ASSETS_FILES='./*_Data/*.assets*'

ARCHIVE_GAME_DATA_PATH_GOG='data/noarch/game'
ARCHIVE_GAME_DATA_PATH_HUMBLE='Linux'
ARCHIVE_GAME_DATA_FILES='./*_Data/globalgamemanagers ./*_Data/resources.resource ./*_Data/level* ./*_Data/*.dat ./*_Data/*.ini ./*_Data/*.png ./*_Data/GameData ./*_Data/Managed ./*_Data/Resources ./*_Data/Translation ./*_Data/uiresources ./*.info'

DATA_DIRS='./logs'
DATA_DIRS_GOG='./WFTOGame_Data/GameData'
DATA_DIRS_HUMBLE='./WFTO_Data/GameData'

APP_MAIN_TYPE='native'
APP_MAIN_EXE_GOG='WFTOGame.x86_64'
APP_MAIN_EXE_HUMBLE='WFTO.x86_64'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICON='*_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'

PACKAGES_LIST='PKG_ASSETS PKG_DATA PKG_BIN'

PKG_ASSETS_ID="${GAME_ID}-assets"
PKG_ASSETS_DESCRIPTION='assets'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS="$PKG_ASSETS_ID $PKG_DATA_ID glibc libstdc++ glx xcursor gconf"

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
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Load extra archives (DLC)

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_UNDERLORD' 'ARCHIVE_GOG_UNDERLORD'
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"

if [ "$ARCHIVE_UNDERLORD" ]; then
	touch "$PLAYIT_WORKDIR/gamedata/$ARCHIVE_GAME_DATA_PATH_GOG/goggame-1906832216.info"
fi

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

chmod +x "${PKG_BIN_PATH}${PATH_GAME}"/*_Data/CoherentUI_Host/linux/CoherentUI_Host
chmod +x "${PKG_BIN_PATH}${PATH_GAME}"/*_Data/CoherentUI_Host/linux/CoherentUI_Host.bin

(
	cd "${PKG_DATA_PATH}${PATH_GAME}"/*_Data/uiresources/maps
	mv 'Stonegate.unity.png' 'stonegate.unity.png'
)

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

case "$ARCHIVE" in
	('ARCHIVE_GOG'*)
		APP_MAIN_EXE="$APP_MAIN_EXE_GOG"
		DATA_DIRS="$DATA_DIRS $DATA_DIRS_GOG"
	;;
	('ARCHIVE_HUMBLE')
		APP_MAIN_EXE="$APP_MAIN_EXE_HUMBLE"
		DATA_DIRS="$DATA_DIRS $DATA_DIRS_HUMBLE"
	;;
esac

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_ASSETS' 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
