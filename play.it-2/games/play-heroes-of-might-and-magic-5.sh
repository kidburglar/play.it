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
# Heroes of Might and Magic V
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180506.1

# Set game-specific variables

GAME_ID='heroes-of-might-and-magic-5'
GAME_NAME='Heroes of Might and Magic V'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_homm5_2.1.0.22.exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/heroes_of_might_and_magic_5_bundle'
ARCHIVE_GOG_EN_MD5='74f32ce4fd9580842d6f4230034c04ba'
ARCHIVE_GOG_EN_TYPE='rar'
ARCHIVE_GOG_EN_SIZE='2500000'
ARCHIVE_GOG_EN_VERSION='2.1-gog2.1.0.22'
ARCHIVE_GOG_EN_PART1='setup_homm5_2.1.0.22.bin'
ARCHIVE_GOG_EN_PART1_MD5='9a31aecfcd072f1a01ab4e810f57f894'
ARCHIVE_GOG_EN_PART1_TYPE='rar'

ARCHIVE_GOG_FR='setup_homm5_french_2.1.0.22.exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/heroes_of_might_and_magic_5_bundle'
ARCHIVE_GOG_FR_MD5='51766fd6456879ee261a2924464a1be0'
ARCHIVE_GOG_FR_TYPE='rar'
ARCHIVE_GOG_FR_SIZE='2500000'
ARCHIVE_GOG_FR_VERSION='2.1-gog2.1.0.22'
ARCHIVE_GOG_FR_PART1='setup_homm5_french_2.1.0.22.bin'
ARCHIVE_GOG_FR_PART1_MD5='4d56a95f779c9583cdfdc451ca865927'
ARCHIVE_GOG_FR_PART1_TYPE='rar'

ARCHIVE_DOC_L10N_PATH='game'
ARCHIVE_DOC_L10N_FILES='./*.txt ./*.pdf ./editor?documentation/homm5_combat_replay.pdf ./editor?documentation/homm5_dialogs_replay.pdf ./editor?documentation/homm5_preset_editor.pdf ./editor?documentation/homm5_spectator_mode.pdf ./editor?documentation/homm5_users_campaign_editor.pdf'

ARCHIVE_DOC_DATA_PATH='game'
ARCHIVE_DOC_DATA_FILES='./editor?documentation'

ARCHIVE_GAME_BIN_PATH='game'
ARCHIVE_GAME_BIN_FILES='./bin ./bina1'

ARCHIVE_GAME_L10N_PATH='game'
ARCHIVE_GAME_L10N_FILES='./dataa1/a1p1-texts.pak ./dataa1/a1-sound.pak ./dataa1/a1-texts.pak ./dataa1/p3-texts.pak ./dataa1/texts.pak ./datals/p5-texts.pak ./datals/p6-texts.pak ./data/p3-texts.pak ./data/sound.pak ./data/texts.pak ./music/cs/death-berein.ogg ./music/cs/death-nico.ogg ./music/cs/heart-griffin.ogg ./music/cs/isabel-trap.ogg ./music/cs/nico-vampire.ogg ./music/cs/ritual-isabel.ogg ./video/intro.ogg ./video/outro.ogg'

ARCHIVE_GAME_DATA_PATH='game'
ARCHIVE_GAME_DATA_FILES='./data ./dataa1 ./datals ./duelpresets ./editor ./hwcursors ./music ./profiles ./splasha1.bmp ./splash.bmp ./video'

DATA_DIRS='./profiles'
DATA_FILES='./*.log'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='bin/h5_game.exe'
APP_MAIN_ICON='bin/h5_game.exe'

APP_HOF_ID="${GAME_ID}_hof"
APP_HOF_TYPE='wine'
APP_HOF_EXE='bina1/h5_game.exe'
APP_HOF_ICON='bina1/h5_game.exe'
APP_HOF_NAME="$GAME_NAME - Hammers of Fate"

APP_EDIT_ID="${GAME_ID}_edit"
APP_EDIT_TYPE='wine'
APP_EDIT_EXE='bin/h5_mapeditor.exe'
APP_EDIT_ICON='bin/h5_mapeditor.exe'
APP_EDIT_ICON_ID='128'
APP_EDIT_NAME="$GAME_NAME - Map Editor"

APP_HOFEDIT_ID="${GAME_ID}_hofedit"
APP_HOFEDIT_TYPE='wine'
APP_HOFEDIT_EXE='bina1/h5_mapeditor.exe'
APP_HOFEDIT_ICON='bina1/h5_mapeditor.exe'
APP_HOFEDIT_ICON_ID='128'
APP_HOFEDIT_NAME="$GAME_NAME - Hammers of Fate - Map Editor"

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${GAME_ID}-l10n-en"
PKG_L10N_ID_GOG_FR="${GAME_ID}-l10n-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID $PKG_L10N_ID wine"

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
		return 1
	fi
fi
. "$PLAYIT_LIB2"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE_PART1"
tolower "$PLAYIT_WORKDIR/gamedata"
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Extract icons

PKG='PKG_BIN'
icons_get_from_package 'APP_MAIN' 'APP_HOF' 'APP_EDIT' 'APP_HOFEDIT'
icons_move_to 'PKG_DATA'

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_HOF' 'APP_EDIT' 'APP_HOFEDIT'
pattern='s|^cd "$PATH_PREFIX"$'
pattern="$pattern|cd \"\$PATH_PREFIX/\${APP_EXE%/*}\"|"
pattern="$pattern;s|^wine \"\$APP_EXE\" \$APP_OPTIONS \$@$"
pattern="$pattern|wine \"\${APP_EXE##*/}\" \$APP_OPTIONS \$@|"
sed --in-place "$pattern" "${PKG_BIN_PATH}${PATH_BIN}"/*

# Store saved games outside of WINE prefix

saves_path_base='$WINEPREFIX/drive_c/users/$(whoami)/My Documents/My Games/Heroes of Might and Magic V'
saves_path1="$saves_path_base/Profiles"
saves_path2="$saves_path_base/Hammers of Fate/Profiles"
pattern='s#^init_prefix_dirs "$PATH_DATA" "$DATA_DIRS"$#&'
pattern="$pattern\\nif [ ! -e \"$saves_path1\" ]; then"
pattern="$pattern\\n\\tmkdir --parents \"${saves_path1%/*}\""
pattern="$pattern\\n\\tln --symbolic \"\$PATH_DATA/profiles\" \"$saves_path1\""
pattern="$pattern\\nfi"
pattern="$pattern\\nif [ ! -e \"$saves_path2\" ]; then"
pattern="$pattern\\n\\tmkdir --parents \"${saves_path2%/*}\""
pattern="$pattern\\n\\tln --symbolic \"\$PATH_DATA/profiles\" \"$saves_path2\""
pattern="$pattern\\nfi#"
sed --in-place "$pattern" "${PKG_BIN_PATH}${PATH_BIN}"/*

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
