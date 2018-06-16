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
# Dungeon Keeper
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180302.1

# Set game-specific variables

SCRIPT_DEPS='unar'

GAME_ID='dungeon-keeper-1'
GAME_NAME='Dungeon Keeper'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_dungeon_keeper_gold_2.1.0.7.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/dungeon_keeper'
ARCHIVE_GOG_MD5='8f8890d743c171fb341c9d9c87c52343'
ARCHIVE_GOG_SIZE='400000'
ARCHIVE_GOG_VERSION='1.0-gog2.1.0.7'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./*.pdf'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.cfg ./*.exe ./sound/*.exe ./sound/*.ini'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./*.ico ./*.ogg ./game.* ./ldata ./levels ./sound/*.dig ./sound/*.lst ./sound/*.mdi ./sound/*.sbk ./sound/music.dat ./sound/sound.dat ./data/*.anm ./data/*.cat ./data/*.clm ./data/*.col ./data/*.cub ./data/*.jty ./data/*.obj ./data/*.pal ./data/*.raw ./data/*.rst ./data/*.tab ./data/*.tng ./data/*.txt ./data/dp_prefs ./data/a*.dat ./data/b*.dat ./data/c*.dat ./data/e*.dat ./data/f*.dat ./data/g*.dat ./data/h*.dat ./data/i*.dat ./data/l*.dat ./data/m*.dat ./data/p*.dat ./data/r*.dat ./data/s*.dat ./data/tables.dat ./data/ticon0-0.dat ./data/tmapa*.dat'

ARCHIVE_GAME_L10N_TXT_DE_PATH='keeper/data/german'
ARCHIVE_GAME_L10N_TXT_DE_FILES='./*'

ARCHIVE_GAME_L10N_TXT_EN_PATH='keeper/data/english'
ARCHIVE_GAME_L10N_TXT_EN_FILES='./*'

ARCHIVE_GAME_L10N_TXT_ES_PATH='keeper/data/spanish'
ARCHIVE_GAME_L10N_TXT_ES_FILES='./*'

ARCHIVE_GAME_L10N_TXT_FR_PATH='keeper/data/french'
ARCHIVE_GAME_L10N_TXT_FR_FILES='./*'

ARCHIVE_GAME_L10N_TXT_IT_PATH='keeper/data/italian'
ARCHIVE_GAME_L10N_TXT_IT_FILES='./*'

ARCHIVE_GAME_L10N_TXT_NL_PATH='keeper/data/dutch'
ARCHIVE_GAME_L10N_TXT_NL_FILES='./*'

ARCHIVE_GAME_L10N_TXT_PL_PATH='keeper/data/polish'
ARCHIVE_GAME_L10N_TXT_PL_FILES='./*'

ARCHIVE_GAME_L10N_TXT_SV_PATH='keeper/data/swedish'
ARCHIVE_GAME_L10N_TXT_SV_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_DE_PATH='keeper/sound/speech/german'
ARCHIVE_GAME_L10N_VOICES_DE_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_EN_PATH='keeper/sound/speech/english'
ARCHIVE_GAME_L10N_VOICES_EN_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ES_PATH='keeper/sound/speech/spanish'
ARCHIVE_GAME_L10N_VOICES_ES_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_FR_PATH='keeper/sound/speech/french'
ARCHIVE_GAME_L10N_VOICES_FR_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_NL_PATH='keeper/sound/speech/dutch'
ARCHIVE_GAME_L10N_VOICES_NL_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_PL_PATH='keeper/sound/speech/polish'
ARCHIVE_GAME_L10N_VOICES_PL_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_SV_PATH='keeper/sound/speech/swedish'
ARCHIVE_GAME_L10N_VOICES_SV_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ATLAS_DE_PATH='keeper/sound/atlas/german'
ARCHIVE_GAME_L10N_VOICES_ATLAS_DE_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ATLAS_EN_PATH='keeper/sound/atlas/english'
ARCHIVE_GAME_L10N_VOICES_ATLAS_EN_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ATLAS_ES_PATH='keeper/sound/atlas/spanish'
ARCHIVE_GAME_L10N_VOICES_ATLAS_ES_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ATLAS_FR_PATH='keeper/sound/atlas/french'
ARCHIVE_GAME_L10N_VOICES_ATLAS_FR_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ATLAS_NL_PATH='keeper/sound/atlas/dutch'
ARCHIVE_GAME_L10N_VOICES_ATLAS_NL_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ATLAS_PL_PATH='keeper/sound/atlas/polish'
ARCHIVE_GAME_L10N_VOICES_ATLAS_PL_FILES='./*'

ARCHIVE_GAME_L10N_VOICES_ATLAS_SV_PATH='keeper/sound/atlas/swedish'
ARCHIVE_GAME_L10N_VOICES_ATLAS_SV_FILES='./*'

GAME_IMAGE='game.inst'
GAME_IMAGE_TYPE='iso'

CONFIG_FILES='./*.cfg'
DATA_DIRS='./save'
DATA_FILES='./data/HISCORES.DAT'

APP_MAIN_TYPE='dosbox'
APP_MAIN_EXE='keeper.exe'
APP_MAIN_ICON='goggame-1207658934.ico'
APP_MAIN_ICON_RES='16 32 48 256'

APP_ADDON_ID="${GAME_ID}_deeper-dungeons"
APP_ADDON_NAME="$GAME_NAME - Deeper Dungeons"
APP_ADDON_TYPE='dosbox'
APP_ADDON_EXE='deeper.exe'
APP_ADDON_ICON='gfw_high_addon.ico'
APP_ADDON_ICON_RES='16 32 48 256'

PACKAGES_LIST='PKG_BIN PKG_DATA PKG_L10N_TXT_DE PKG_L10N_TXT_EN PKG_L10N_TXT_ES PKG_L10N_TXT_FR PKG_L10N_TXT_IT PKG_L10N_TXT_NL PKG_L10N_TXT_PL PKG_L10N_TXT_SV PKG_L10N_VOICES_DE PKG_L10N_VOICES_EN PKG_L10N_VOICES_ES PKG_L10N_VOICES_FR PKG_L10N_VOICES_NL PKG_L10N_VOICES_PL PKG_L10N_VOICES_SV'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_L10N_TXT_ID="${GAME_ID}-l10n-txt"
PKG_L10N_TXT_DESCRIPTION='text localization'

PKG_L10N_VOICES_ID="${GAME_ID}-l10n-voices"
PKG_L10N_VOICES_DESCRIPTION='voices localization'

PKG_L10N_TXT_DE_ID="${PKG_L10N_TXT_ID}-de"
PKG_L10N_TXT_DE_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_DE_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - German"

PKG_L10N_TXT_EN_ID="${PKG_L10N_TXT_ID}-en"
PKG_L10N_TXT_EN_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_EN_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - English"

PKG_L10N_TXT_ES_ID="${PKG_L10N_TXT_ID}-es"
PKG_L10N_TXT_ES_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_ES_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Spanish"

PKG_L10N_TXT_FR_ID="${PKG_L10N_TXT_ID}-fr"
PKG_L10N_TXT_FR_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_FR_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - French"

PKG_L10N_TXT_IT_ID="${PKG_L10N_TXT_ID}-it"
PKG_L10N_TXT_IT_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_IT_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Italian"

PKG_L10N_TXT_NL_ID="${PKG_L10N_TXT_ID}-nl"
PKG_L10N_TXT_NL_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_NL_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Dutch"

PKG_L10N_TXT_PL_ID="${PKG_L10N_TXT_ID}-pl"
PKG_L10N_TXT_PL_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_PL_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Polish"

PKG_L10N_TXT_SV_ID="${PKG_L10N_TXT_ID}-sv"
PKG_L10N_TXT_SV_PROVIDE="$PKG_L10N_TXT_ID"
PKG_L10N_TXT_SV_DESCRIPTION="$PKG_L10N_TXT_DESCRIPTION - Swedish"

PKG_L10N_VOICES_DE_ID="${PKG_L10N_VOICES_ID}-de"
PKG_L10N_VOICES_DE_PROVIDE="$PKG_L10N_VOICES_ID"
PKG_L10N_VOICES_DE_DESCRIPTION="$PKG_L10N_VOICES_DESCRIPTION - German"

PKG_L10N_VOICES_EN_ID="${PKG_L10N_VOICES_ID}-en"
PKG_L10N_VOICES_EN_PROVIDE="$PKG_L10N_VOICES_ID"
PKG_L10N_VOICES_EN_DESCRIPTION="$PKG_L10N_VOICES_DESCRIPTION - English"

PKG_L10N_VOICES_ES_ID="${PKG_L10N_VOICES_ID}-es"
PKG_L10N_VOICES_ES_PROVIDE="$PKG_L10N_VOICES_ID"
PKG_L10N_VOICES_ES_DESCRIPTION="$PKG_L10N_VOICES_DESCRIPTION - Spanish"

PKG_L10N_VOICES_FR_ID="${PKG_L10N_VOICES_ID}-fr"
PKG_L10N_VOICES_FR_PROVIDE="$PKG_L10N_VOICES_ID"
PKG_L10N_VOICES_FR_DESCRIPTION="$PKG_L10N_VOICES_DESCRIPTION - French"

PKG_L10N_VOICES_NL_ID="${PKG_L10N_VOICES_ID}-nl"
PKG_L10N_VOICES_NL_PROVIDE="$PKG_L10N_VOICES_ID"
PKG_L10N_VOICES_NL_DESCRIPTION="$PKG_L10N_VOICES_DESCRIPTION - Dutch"

PKG_L10N_VOICES_PL_ID="${PKG_L10N_VOICES_ID}-pl"
PKG_L10N_VOICES_PL_PROVIDE="$PKG_L10N_VOICES_ID"
PKG_L10N_VOICES_PL_DESCRIPTION="$PKG_L10N_VOICES_DESCRIPTION - Polish"

PKG_L10N_VOICES_SV_ID="${PKG_L10N_VOICES_ID}-sv"
PKG_L10N_VOICES_SV_PROVIDE="$PKG_L10N_VOICES_ID"
PKG_L10N_VOICES_SV_DESCRIPTION="$PKG_L10N_VOICES_DESCRIPTION - Swedish"

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_TXT_ID $PKG_L10N_VOICES_ID $PKG_DATA_ID dosbox"

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
(
	ARCHIVE='ARCHIVE_L10N'
	ARCHIVE_L10N="$PLAYIT_WORKDIR/gamedata/app/game.gog"
	ARCHIVE_L10N_TYPE='rar'
	extract_data_from "$ARCHIVE_L10N"
)
tolower "$PLAYIT_WORKDIR/gamedata"

for PKG in 'PKG_BIN' 'PKG_DATA'; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

for lang in 'DE' 'EN' 'ES' 'FR' 'IT' 'NL' 'PL' 'SV'; do
	PKG="PKG_L10N_TXT_$lang"
	organize_data "GAME_L10N_TXT_$lang" "$PATH_GAME/data"
done

for lang in 'DE' 'EN' 'ES' 'FR' 'NL' 'PL' 'SV'; do
	PKG="PKG_L10N_VOICES_$lang"
	organize_data "GAME_L10N_VOICES_$lang"       "$PATH_GAME/sound"
	organize_data "GAME_L10N_VOICES_ATLAS_$lang" "$PATH_GAME/sound/atlas"
done

PKG='PKG_DATA'
extract_and_sort_icons_from 'APP_MAIN' 'APP_ADDON'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_ADDON'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

case "${LANG%_*}" in
	('fr')
		lang_string='version %s :'
		lang_en='anglaise'
		lang_es='espagnole'
		lang_fr='française'
		lang_it='italienne'
		lang_nl='néerlandaise'
		lang_pl='polonaise'
		lang_sv='suédoise'
	;;
	('en'|*)
		lang_string='%s version:'
		lang_en='English'
		lang_es='Spanish'
		lang_fr='French'
		lang_it='Italian'
		lang_nl='Dutch'
		lang_pl='Polish'
		lang_sv='swedish'
	;;
esac
printf '\n'
printf "$lang_string" "$lang_en"
print_instructions 'PKG_L10N_TXT_EN' 'PKG_L10N_VOICES_EN' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_es"
print_instructions 'PKG_L10N_TXT_ES' 'PKG_L10N_VOICES_ES' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_fr"
print_instructions 'PKG_L10N_TXT_FR' 'PKG_L10N_VOICES_FR' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_it"
print_instructions 'PKG_L10N_TXT_IT' 'PKG_L10N_VOICES_EN' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_nl"
print_instructions 'PKG_L10N_TXT_NL' 'PKG_L10N_VOICES_NL' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_pl"
print_instructions 'PKG_L10N_TXT_PL' 'PKG_L10N_VOICES_PL' 'PKG_DATA' 'PKG_BIN'
printf "$lang_string" "$lang_sv"
print_instructions 'PKG_L10N_TXT_SV' 'PKG_L10N_VOICES_SV' 'PKG_DATA' 'PKG_BIN'

exit 0
