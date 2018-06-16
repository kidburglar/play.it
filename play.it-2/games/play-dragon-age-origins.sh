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
# Dragon Age Origins
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180505.3

# Set game-specific variables

GAME_ID='dragon-age-origins'
GAME_NAME='Dragon Age Origins'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_dragon_age_origins_ultimate_2.1.0.4.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/dragon_age_origins'
ARCHIVE_GOG_MD5='2bfdbc94523ef4c21476f64ef8029479'
ARCHIVE_GOG_SIZE='39000000'
ARCHIVE_GOG_VERSION='1.0-gog2.1.0.4'
ARCHIVE_GOG_TYPE='rar'
ARCHIVE_GOG_PART1='setup_dragon_age_origins_ultimate_2.1.0.4-1.bin'
ARCHIVE_GOG_PART1_MD5='b6e68b1b3b11fdddea809a5f11368036'
ARCHIVE_GOG_PART1_TYPE='rar'
ARCHIVE_GOG_PART2='setup_dragon_age_origins_ultimate_2.1.0.4-2.bin'
ARCHIVE_GOG_PART2_MD5='71d813d6827941a90422a40088d64b78'
ARCHIVE_GOG_PART2_TYPE='rar'
ARCHIVE_GOG_PART3='setup_dragon_age_origins_ultimate_2.1.0.4-3.bin'
ARCHIVE_GOG_PART3_MD5='2ff9cc2bb41435429ee6277106a6a568'
ARCHIVE_GOG_PART3_TYPE='rar'
ARCHIVE_GOG_PART4='setup_dragon_age_origins_ultimate_2.1.0.4-4.bin'
ARCHIVE_GOG_PART4_MD5='a25c58b43a2e468fcf72446f57542115'
ARCHIVE_GOG_PART4_TYPE='rar'
ARCHIVE_GOG_PART5='setup_dragon_age_origins_ultimate_2.1.0.4-5.bin'
ARCHIVE_GOG_PART5_MD5='4ce5f6dceb01c9a1fc85c759c436b7b2'
ARCHIVE_GOG_PART5_TYPE='rar'
ARCHIVE_GOG_PART6='setup_dragon_age_origins_ultimate_2.1.0.4-6.bin'
ARCHIVE_GOG_PART6_MD5='e2d13b236af30f210e0eb65aec5d137e'
ARCHIVE_GOG_PART6_TYPE='rar'

ARCHIVE_DOC0_DATA_PATH='game/docs'
ARCHIVE_DOC0_DATA_FILES='./*'

ARCHIVE_DOC1_DATA_PATH='game'
ARCHIVE_DOC1_DATA_FILES='./manual.pdf'

ARCHIVE_GAME_BIN_PATH='game'
ARCHIVE_GAME_BIN_FILES='./bin_ship ./daoriginslauncher.exe'

ARCHIVE_GAME_DATA_PATH='game'
ARCHIVE_GAME_DATA_FILES='./addins ./data ./modules ./offers ./packages'

ARCHIVE_GAME_ENVIRONMENT_PATH='game'
ARCHIVE_GAME_ENVIRONMENT_FILES='./addins/*/*/env ./packages/*/env'

ARCHIVE_GAME_MOVIES_PATH='game'
ARCHIVE_GAME_MOVIES_FILES='./addins/*/core/data/movies ./modules/*/data/movies ./packages/*/data/movies'

ARCHIVE_GAME_L10N_VOICE_DE_PATH='game'
ARCHIVE_GAME_L10N_VOICE_DE_FILES='./offers/*/module/audio/vo/de-de ./addins/*/module/audio/vo/de-de ./packages/*/audio/vo/de-de ./modules/*/locale/de-de ./modules/*/audio/vo/de-de'

ARCHIVE_GAME_L10N_VOICE_EN_PATH='game'
ARCHIVE_GAME_L10N_VOICE_EN_FILES='./offers/*/module/audio/vo/en-us ./addins/*/module/audio/vo/en-us ./addins/*/core/audio/vo/en-us ./packages/*/audio/vo/en-us ./packages/*/audio/vo/en-us ./modules/*/audio/vo/en-us'

ARCHIVE_GAME_L10N_VOICE_FR_PATH='game'
ARCHIVE_GAME_L10N_VOICE_FR_FILES='./offers/*/module/audio/vo/fr-fr ./addins/*/module/audio/vo/fr-fr ./packages/*/audio/vo/fr-fr ./packages/*/audio/vo/fr-fr ./modules/*/locale/fr-fr ./modules/*/audio/vo/fr-fr'

ARCHIVE_GAME_L10N_VOICE_RU_PATH='game'
ARCHIVE_GAME_L10N_VOICE_RU_FILES='./offers/*/module/audio/vo/ru-ru ./addins/*/module/audio/vo/ru-ru ./addins/*/core/audio/vo/ru-ru ./packages/*/locale/ru-ru ./packages/*/audio/vo/ru-ru ./modules/*/locale/ru-ru ./modules/*/audio/vo/ru-ru'

ARCHIVE_GAME_L10N_VOICE_PL_PATH='game'
ARCHIVE_GAME_L10N_VOICE_PL_FILES='./offers/*/module/audio/vo/pl-pl ./addins/*/module/audio/vo/pl-pl ./addins/*/core/audio/vo/pl-pl ./packages/core/locale/pl-pl ./packages/*/audio/vo/pl-pl ./modules/*/locale/pl-pl ./modules/*/audio/vo/pl-pl'

ARCHIVE_GAME_L10N_TXT_DE_PATH='game'
ARCHIVE_GAME_L10N_TXT_DE_FILES='./addins/*/*/data/talktables/*_de-de* */*/data/talktables/*_de-de*'

ARCHIVE_GAME_L10N_TXT_EN_PATH='game'
ARCHIVE_GAME_L10N_TXT_EN_FILES='./addins/*/*/data/talktables/*_en-us* */*/data/talktables/*_en-us*'

ARCHIVE_GAME_L10N_TXT_FR_PATH='game'
ARCHIVE_GAME_L10N_TXT_FR_FILES='./addins/*/*/data/talktables/*_fr-fr* */*/data/talktables/*_fr-fr*'

ARCHIVE_GAME_L10N_TXT_RU_PATH='game'
ARCHIVE_GAME_L10N_TXT_RU_FILES='./addins/*/*/data/talktables/*_ru-ru* */*/data/talktables/*_ru-ru*'

ARCHIVE_GAME_L10N_TXT_PL_PATH='game'
ARCHIVE_GAME_L10N_TXT_PL_FILES='./addins/*/*/data/talktables/*_pl-pl* */*/data/talktables/*_pl-pl*'

ARCHIVE_GAME_L10N_TXT_CS_PATH='game'
ARCHIVE_GAME_L10N_TXT_CS_FILES='./modules/single?player/locale/cs-cz ./addins/*/*/data/talktables/*_cs-cz* */*/data/talktables/*_cs-cz*'

ARCHIVE_GAME_L10N_TXT_ES_PATH='game'
ARCHIVE_GAME_L10N_TXT_ES_FILES='./modules/single?player/locale/es-es ./addins/*/*/data/talktables/*_es-es* */*/data/talktables/*_es-es*'

ARCHIVE_GAME_L10N_TXT_HU_PATH='game'
ARCHIVE_GAME_L10N_TXT_HU_FILES='./modules/single?player/locale/hu-hu ./addins/*/*/data/talktables/*_hu-hu* */*/data/talktables/*_hu-hu*'

ARCHIVE_GAME_L10N_TXT_IT_PATH='game'
ARCHIVE_GAME_L10N_TXT_IT_FILES='./modules/single?player/locale/it-it ./addins/*/*/data/talktables/*_it-it* */*/data/talktables/*_it-it*'

ARCHIVE_SETTINGS_PATH='support/userdocs'
ARCHIVE_SETTINGS_FILES='./*'

CONFIG_DIRS='./settings'
DATA_DIRS='./characters'

APP_WINETRICKS='physx csmt=on'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='bin_ship/daorigins.exe'
APP_MAIN_ICON='bin_ship/daorigins.exe'
APP_MAIN_ICON_RES='16 24 32 48 256'

PACKAGES_LIST='PKG_BIN PKG_L10N_VOICE_DE PKG_L10N_VOICE_EN PKG_L10N_VOICE_FR PKG_L10N_VOICE_RU PKG_L10N_VOICE_PL PKG_L10N_TXT_DE PKG_L10N_TXT_EN PKG_L10N_TXT_FR PKG_L10N_TXT_RU PKG_L10N_TXT_PL PKG_L10N_TXT_CS PKG_L10N_TXT_ES PKG_L10N_TXT_HU PKG_L10N_TXT_IT PKG_ENVIRONMENT PKG_MOVIES PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_ENVIRONMENT_ID="${GAME_ID}-environment"
PKG_ENVIRONMENT_DESCRIPTION='environment'

PKG_MOVIES_ID="${GAME_ID}-movies"
PKG_MOVIES_DESCRIPTION='movies'

PKG_L10N_VOICE_ID="${GAME_ID}-l10n-voice"
PKG_L10N_VOICE_DESCRIPTION='voice localization'

PKG_L10N_TXT_ID="${GAME_ID}-l10n-text"
PKG_L10N_TXT_DESCRIPTION='text localization'

PKG_L10N_VOICE_DE_ID="${PKG_L10N_VOICE_ID}-de"
PKG_L10N_VOICE_DE_PROVIDE="$PKG_L10N_VOICE_ID"
PKG_L10N_VOICE_DE_DESCRIPTION="$PKG_L10N_VOICE_DESCRIPTION - German"

PKG_L10N_VOICE_EN_ID="${PKG_L10N_VOICE_ID}-en"
PKG_L10N_VOICE_EN_PROVIDE="$PKG_L10N_VOICE_ID"
PKG_L10N_VOICE_EN_DESCRIPTION="$PKG_L10N_VOICE_DESCRIPTION - English"

PKG_L10N_VOICE_FR_ID="${PKG_L10N_VOICE_ID}-fr"
PKG_L10N_VOICE_FR_PROVIDE="$PKG_L10N_VOICE_ID"
PKG_L10N_VOICE_FR_DESCRIPTION="$PKG_L10N_VOICE_DESCRIPTION - French"

PKG_L10N_VOICE_RU_ID="${PKG_L10N_VOICE_ID}-ru"
PKG_L10N_VOICE_RU_PROVIDE="$PKG_L10N_VOICE_ID"
PKG_L10N_VOICE_RU_DESCRIPTION="$PKG_L10N_VOICE_DESCRIPTION - Russian"

PKG_L10N_VOICE_PL_ID="${PKG_L10N_VOICE_ID}-pl"
PKG_L10N_VOICE_PL_PROVIDE="$PKG_L10N_VOICE_ID"
PKG_L10N_VOICE_PL_DESCRIPTION="$PKG_L10N_VOICE_DESCRIPTION - Polish"

PKG_L10N_TXT_DE_ID="${PKG_L10N_TXT_ID}-de"
PKG_L10N_TXT_DE_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_DE_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - German"

PKG_L10N_TXT_EN_ID="${PKG_L10N_TXT_ID}-en"
PKG_L10N_TXT_EN_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_EN_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - English"

PKG_L10N_TXT_FR_ID="${PKG_L10N_TXT_ID}-fr"
PKG_L10N_TXT_FR_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_FR_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - French"

PKG_L10N_TXT_RU_ID="${PKG_L10N_TXT_ID}-ru"
PKG_L10N_TXT_RU_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_RU_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Russian"

PKG_L10N_TXT_PL_ID="${PKG_L10N_TXT_ID}-pl"
PKG_L10N_TXT_PL_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_PL_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Polish"

PKG_L10N_TXT_CS_ID="${PKG_L10N_TXT_ID}-cs"
PKG_L10N_TXT_CS_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_CS_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Czech"

PKG_L10N_TXT_ES_ID="${PKG_L10N_TXT_ID}-es"
PKG_L10N_TXT_ES_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_ES_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Spanish"

PKG_L10N_TXT_HU_ID="${PKG_L10N_TXT_ID}-hu"
PKG_L10N_TXT_HU_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_HU_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Hungarian"

PKG_L10N_TXT_IT_ID="${PKG_L10N_TXT_ID}-it"
PKG_L10N_TXT_IT_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_IT_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Italian"

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_VOICE_ID $PKG_L10N_TXT_ID $PKG_ENVIRONMENT_ID $PKG_MOVIES_ID $PKG_DATA_ID wine winetricks"

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

ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE_PART1")" "$PLAYIT_WORKDIR/$GAME_ID.r00"
ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE_PART2")" "$PLAYIT_WORKDIR/$GAME_ID.r01"
ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE_PART3")" "$PLAYIT_WORKDIR/$GAME_ID.r02"
ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE_PART4")" "$PLAYIT_WORKDIR/$GAME_ID.r03"
ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE_PART5")" "$PLAYIT_WORKDIR/$GAME_ID.r04"
ln --symbolic "$(readlink --canonicalize "$SOURCE_ARCHIVE_PART6")" "$PLAYIT_WORKDIR/$GAME_ID.r05"
extract_data_from "$PLAYIT_WORKDIR/$GAME_ID.r00"
tolower "$PLAYIT_WORKDIR/gamedata"
prepare_package_layout

PKG='PKG_DATA'
organize_data 'SETTINGS' "$PATH_GAME/settings"

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Enable included DLCs

settings_path='$WINEPREFIX/drive_c/users/$(whoami)/My Documents/BioWare/Dragon Age/Settings'
pattern='s#init_prefix_dirs "$PATH_DATA" "$DATA_DIRS"#&'
pattern="$pattern\\nif [ ! -e \"$settings_path\" ]; then"
pattern="$pattern\\n\\tmkdir --parents \"${settings_path%/*}\""
pattern="$pattern\\n\\tln --symbolic \"\$PATH_CONFIG/settings\" \"$settings_path\""
pattern="$pattern\\nfi#"
sed --in-place "$pattern" "${PKG_BIN_PATH}${PATH_BIN}"/*

# Store saved games outside of WINE prefix

saves_path='$WINEPREFIX/drive_c/users/$(whoami)/My Documents/BioWare/Dragon Age/Characters'
pattern='s#init_prefix_dirs "$PATH_DATA" "$DATA_DIRS"#&'
pattern="$pattern\\nif [ ! -e \"$saves_path\" ]; then"
pattern="$pattern\\n\\tmkdir --parents \"${saves_path%/*}\""
pattern="$pattern\\n\\tln --symbolic \"\$PATH_DATA/characters\" \"$saves_path\""
pattern="$pattern\\nfi#"
sed --in-place "$pattern" "${PKG_BIN_PATH}${PATH_BIN}"/*

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

case "${LANG%_*}" in
	('fr')
		lang_string='version %s :'
		lang_de='allemande'
		lang_en='anglaise'
		lang_fr='française'
		lang_ru='russe'
		lang_pl='polonaise'
		lang_cs='tchèque'
		lang_es='espagnole'
		lang_hu='hongroise'
		lang_it='italienne'
	;;
	('en'|*)
		lang_string='%s version:'
		lang_de='German'
		lang_en='English'
		lang_fr='French'
		lang_ru='Russian'
		lang_pl='Polish'
		lang_cs='Czech'
		lang_es='Spanish'
		lang_hu='Hungarian'
		lang_it='Italian'
	;;
esac
printf '\n'
printf "$lang_string" "$lang_de"
print_instructions 'PKG_L10N_VOICE_DE' 'PKG_L10N_TXT_DE' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_en"
print_instructions 'PKG_L10N_VOICE_EN' 'PKG_L10N_TXT_EN' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_fr"
print_instructions 'PKG_L10N_VOICE_FR' 'PKG_L10N_TXT_FR' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_ru"
print_instructions 'PKG_L10N_VOICE_RU' 'PKG_L10N_TXT_RU' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_pl"
print_instructions 'PKG_L10N_VOICE_PL' 'PKG_L10N_TXT_PL' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_cs"
print_instructions 'PKG_L10N_VOICE_EN' 'PKG_L10N_TXT_CS' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_es"
print_instructions 'PKG_L10N_VOICE_EN' 'PKG_L10N_TXT_ES' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_hu"
print_instructions 'PKG_L10N_VOICE_EN' 'PKG_L10N_TXT_HU' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_it"
print_instructions 'PKG_L10N_VOICE_EN' 'PKG_L10N_TXT_IT' 'PKG_ENVIRONMENT' 'PKG_MOVIES' 'PKG_DATA' 'PKG_BIN'

exit 0
