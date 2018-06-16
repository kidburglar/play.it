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
# Heroes of Might and Magic V - Tribes of the East
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='heroes-of-might-and-magic-5-tribes-of-the-east'
GAME_NAME='Heroes of Might and Magic V - Tribes of the East'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_homm5_tote_2.1.0.24.bin'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/heroes_of_might_and_magic_5_bundle'
ARCHIVE_GOG_EN_MD5='48a783c1f6d3e15a0439fc58d85c5b28'
ARCHIVE_GOG_EN_TYPE='rar'
ARCHIVE_GOG_EN_SIZE='2300000'
ARCHIVE_GOG_EN_VERSION='3.1-gog2.1.0.24'

ARCHIVE_GOG_FR='setup_homm5_tote_french_2.1.0.24-1.bin'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/heroes_of_might_and_magic_5_bundle'
ARCHIVE_GOG_FR_MD5='bfb583edb64c548cf60f074e4abc2043'
ARCHIVE_GOG_FR_TYPE='rar'
ARCHIVE_GOG_FR_SIZE='2300000'
ARCHIVE_GOG_FR_VERSION='3.1-gog2.1.0.24'

ARCHIVE_DOC_L10N_PATH='game'
ARCHIVE_DOC_L10N_FILES='./*.pdf ./*.txt ./editor?documentation ./fandocuments/*.pdf ./fandocuments/*.txt'

ARCHIVE_GAME_BIN_PATH='game'
ARCHIVE_GAME_BIN_FILES='./bindm ./bin/*.exe ./bin/*.ini ./bin/dbghelp.dll ./bin/fmod.dll ./bin/granny2.dll ./bin/libcurl.dll ./bin/mfc71.dll ./bin/mfc71enu.dll ./bin/msvcp71.dll ./bin/msvcr71.dll ./bin/ubistats.dll ./bin/um.dll ./bin/zlib1.dll ./bin/zlibwapi.dll'

ARCHIVE_GAME_L10N_PATH='game'
ARCHIVE_GAME_L10N_FILES='./fandocuments/*.exe ./data/a2p1-texts.pak ./data/sound.pak ./data/texts.pak'

ARCHIVE_GAME_DATA_PATH='game'
ARCHIVE_GAME_DATA_FILES='./*.bmp ./customcontentdm ./editor ./hwcursors ./music ./profiles ./video ./data/a2p1-data.pak ./data/data.pak ./data/soundsfx.pak'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='bin/h5_game.exe'
APP_MAIN_ICON='bin/h5_game.exe'
APP_MAIN_ICON_RES='16 32 48 64 256'

APP_EDIT_ID="${GAME_ID}_edit"
APP_EDIT_TYPE='wine'
APP_EDIT_EXE='bin/h5_mapeditor.exe'
APP_EDIT_ICON='bin/h5_mapeditor.exe'
APP_EDIT_ICON_ID='128'
APP_EDIT_ICON_RES='32'
APP_EDIT_NAME="$GAME_NAME - Map Editor"

APP_DM_ID="${GAME_ID}_dm"
APP_DM_TYPE='wine'
APP_DM_EXE='bindm/h5_game.exe'
APP_DM_ICON='bindm/h5_game.exe'
APP_DM_ICON_ID='101'
APP_DM_ICON_RES='16 32 48 64 256'
APP_DM_NAME="$GAME_NAME - Dark Messiah"

APP_SKILLS_ID="${GAME_ID}_skills"
APP_SKILLS_TYPE='wine'
APP_SKILLS_EXE='fandocuments/skillwheel.exe'
APP_SKILLS_ICON='fandocuments/skillwheel.exe'
APP_SKILLS_ICON_ID='200'
APP_SKILLS_ICON_RES='16 32 48'
APP_SKILLS_NAME="$GAME_NAME - SkillWheel"

PACKAGES_LIST='PKG_L10N PKG_DATA PKG_BIN'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${GAME_ID}-l10n-en"
PKG_L10N_ID_GOG_FR="${GAME_ID}-l10n-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, $PKG_L10N_ID, wine32-development | wine32 | wine-bin | wine-i386 | wine-staging-i386, wine:amd64 | wine"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID $PKG_L10N_ID wine"

# Load common functions

target_version='2.1'

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
tolower "$PLAYIT_WORKDIR/gamedata"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN' 'APP_EDIT' 'APP_DM'
move_icons_to 'PKG_DATA'

PKG='PKG_L10N'
extract_and_sort_icons_from 'APP_SKILLS'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_EDIT' 'APP_DM' 'APP_SKILLS'
(
	cd "${PKG_BIN_PATH}${PATH_BIN}"
	sed --in-place 's|cd "$PATH_PREFIX"|cd "$PATH_PREFIX/${APP_EXE%/*}"|'                     "$GAME_ID" "$APP_EDIT_ID" "$APP_DM_ID"
	sed --in-place 's|wine "$APP_EXE" $APP_OPTIONS $@|wine "${APP_EXE##*/}" $APP_OPTIONS $@|' "$GAME_ID" "$APP_EDIT_ID" "$APP_DM_ID"
)

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
