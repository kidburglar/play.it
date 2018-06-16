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
# Pillars of Eternity
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='pillars-of-eternity'
GAME_NAME='Pillars of Eternity'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST'

ARCHIVE_GOG='pillars_of_eternity_en_3_07_0_1318_17461.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/pillars_of_eternity_hero_edition'
ARCHIVE_GOG_MD5='57164ad0cbc53d188dde0b38e7491916'
ARCHIVE_GOG_SIZE='15000000'
ARCHIVE_GOG_VERSION='3.7.0.1318-gog17461'
ARCHIVE_GOG_TYPE='mojosetup_unzip'

ARCHIVE_GOG_OLD='pillars_of_eternity_en_3_07_16405.sh'
ARCHIVE_GOG_OLD_MD5='e4271b5e72f1ecc9fbbc4d90937ede05'
ARCHIVE_GOG_OLD_SIZE='15000000'
ARCHIVE_GOG_OLD_VERSION='3.7.0.1284-gog16405'
ARCHIVE_GOG_OLD_TYPE='mojosetup_unzip'

ARCHIVE_GOG_OLDER='gog_pillars_of_eternity_2.16.0.20.sh'
ARCHIVE_GOG_OLDER_MD5='0d21cf95bda070bdbfbe3e79f8fc32d6'
ARCHIVE_GOG_OLDER_SIZE='15000000'
ARCHIVE_GOG_OLDER_VERSION='3.06.1254-gog2.16.0.20'
ARCHIVE_GOG_OLDER_TYPE='mojosetup_unzip'

ARCHIVE_GOG_OLDEST='gog_pillars_of_eternity_2.15.0.19.sh'
ARCHIVE_GOG_OLDEST_MD5='2000052541abb1ef8a644049734e8526'
ARCHIVE_GOG_OLDEST_SIZE='15000000'
ARCHIVE_GOG_OLDEST_VERSION='3.05.1186-gog2.15.0.19'
ARCHIVE_GOG_OLDEST_TYPE='mojosetup_unzip'

ARCHIVES_DEADFIRE_LIST='ARCHIVE_DEADFIRE_GOG ARCHIVE_DEADFIRE_GOG_OLD'

ARCHIVE_DEADFIRE_GOG='pillars_of_eternity_deadfire_pack_dlc_en_3_07_0_1318_17462.sh'
ARCHIVE_DEADFIRE_GOG_MD5='021362da5912dc8a3e47473e97726f7f'
ARCHIVE_DEADFIRE_GOG_TYPE='mojosetup'

ARCHIVE_DEADFIRE_GOG_OLD='pillars_of_eternity_deadfire_pack_dlc_en_3_07_16380.sh'
ARCHIVE_DEADFIRE_GOG_OLD_MD5='2fc0dc21648953be1c571e28b1e3d002'
ARCHIVE_DEADFIRE_GOG_OLD_TYPE='mojosetup'

ARCHIVE_GOG_DLC1='gog_pillars_of_eternity_kickstarter_item_dlc_2.0.0.2.sh'
ARCHIVE_GOG_DLC1_MD5='b4c29ae17c87956471f2d76d8931a4e5'

ARCHIVE_GOG_DLC2='gog_pillars_of_eternity_kickstarter_pet_dlc_2.0.0.2.sh'
ARCHIVE_GOG_DLC2_MD5='3653fc2a98ef578335f89b607f0b7968'

ARCHIVE_GOG_DLC3='gog_pillars_of_eternity_preorder_item_and_pet_dlc_2.0.0.2.sh'
ARCHIVE_GOG_DLC3_MD5='b86ad866acb62937d2127407e4beab19'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./PillarsOfEternity ./PillarsOfEternity_Data/Mono ./PillarsOfEternity_Data/Plugins'

ARCHIVE_GAME_AREAS_PATH='data/noarch/game'
ARCHIVE_GAME_AREAS_FILES='./PillarsOfEternity_Data/assetbundles/st_ar_*'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./PillarsOfEternity.png ./PillarsOfEternity_Data/assetbundles/art ./PillarsOfEternity_Data/assetbundles/override ./PillarsOfEternity_Data/assetbundles/prefabs ./PillarsOfEternity_Data/assetbundles/st_1501_yenwood.assetbundle ./PillarsOfEternity_Data/assetbundles/st_dfb_firstfires_ruins.assetbundle ./PillarsOfEternity_Data/assetbundles/st_pro* ./PillarsOfEternity_Data/assetbundles/st_px4_cave01.assetbundle ./PillarsOfEternity_Data/assetbundles/*.unity3d ./PillarsOfEternity_Data/assetbundles/vo ./PillarsOfEternity_Data/level* ./PillarsOfEternity_Data/*.assets ./PillarsOfEternity_Data/*.assets.resS ./PillarsOfEternity_Data/data ./PillarsOfEternity_Data/data_expansion4 ./PillarsOfEternity_Data/mainData ./PillarsOfEternity_Data/Managed ./PillarsOfEternity_Data/PlayerConnectionConfigFile ./PillarsOfEternity_Data/Resources ./PillarsOfEternity_Data/ScreenSelector.png ./PillarsOfEternity_Data/StreamingAssets'

DATA_DIRS='./logs'

APP_MAIN_TYPE='native'
APP_MAIN_EXE='PillarsOfEternity'
APP_MAIN_OPTIONS='-logFile ./logs/$(date +%F-%R).log'
APP_MAIN_ICONS_LIST='APP_MAIN_ICON'
APP_MAIN_ICONS_LIST_OLD="$APP_MAIN_ICONS_LIST APP_MAIN_ICON_OLD"
APP_MAIN_ICON='./PillarsOfEternity_Data/Resources/UnityPlayer.png'
APP_MAIN_ICON_RES='128'
APP_MAIN_ICON_OLD='./PillarsOfEternity.png'
APP_MAIN_ICON_OLD_RES='512'

PACKAGES_LIST='PKG_AREAS PKG_DATA PKG_BIN'

PKG_AREAS_ID="${GAME_ID}-areas"
PKG_AREAS_DESCRIPTION='areas'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS="$PKG_AREAS_ID $PKG_DATA_ID glu xcursor libxrandr"

# Load common functions

target_version='2.4'

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

# Load extra archives (DLC)

ARCHIVE_MAIN="$ARCHIVE"
for archive in $ARCHIVES_DEADFIRE_LIST; do
	[ "$ARCHIVE_DEADFIRE" ] || set_archive 'ARCHIVE_DEADFIRE' "$archive"
done
for dlc in 'DLC1' 'DLC2' 'DLC3'; do
	set_archive "ARCHIVE_$dlc" "ARCHIVE_GOG_$dlc"
done
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
(
	if [ "$ARCHIVE_DLC1" ]; then
		ARCHIVE='ARCHIVE_GOG_DLC1'
		extract_data_from "$ARCHIVE_DLC1"
	fi
	if [ "$ARCHIVE_DLC2" ]; then
		ARCHIVE='ARCHIVE_GOG_DLC2'
		extract_data_from "$ARCHIVE_DLC2"
	fi
	if [ "$ARCHIVE_DLC3" ]; then
		ARCHIVE='ARCHIVE_GOG_DLC3'
		extract_data_from "$ARCHIVE_DLC3"
	fi
)

if [ "$ARCHIVE_DEADFIRE" ]; then
	touch "$PLAYIT_WORKDIR/gamedata/$ARCHIVE_GAME_DATA_PATH/PillarsOfEternity_Data/assetbundles/px4.unity3d"
fi

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Build package

case "$ARCHIVE" in
	('ARCHIVE_GOG_OLDER'|'ARCHIVE_GOG_OLDEST')
		APP_MAIN_ICONS_LIST="$APP_MAIN_ICONS_LIST_OLD"
	;;
esac
postinst_icons_linking 'APP_MAIN'
write_metadata 'PKG_DATA'
write_metadata 'PKG_AREAS' 'PKG_BIN'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
