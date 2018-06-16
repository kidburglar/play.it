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
# The Settlers 2
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='the-settlers-2'
GAME_NAME='The Settlers II'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR ARCHIVE_GOG_DE'

ARCHIVE_GOG_EN='setup_settlers2_gold_2.0.0.14.exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/the_settlers_2_gold_edition'
ARCHIVE_GOG_EN_MD5='6f64b47b15f6ba5d43670504dd0bb229'
ARCHIVE_GOG_EN_VERSION='1.51-gog2.0.0.14'
ARCHIVE_GOG_EN_SIZE='370000'

ARCHIVE_GOG_FR='setup_settlers2_gold_french_2.1.0.16.exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/the_settlers_2_gold_edition'
ARCHIVE_GOG_FR_MD5='1eca72ca45d63e4390590d495657d213'
ARCHIVE_GOG_FR_VERSION='1.51-gog2.1.0.16'
ARCHIVE_GOG_FR_SIZE='410000'

ARCHIVE_GOG_DE='setup_settlers2_gold_german_2.1.0.17.exe'
ARCHIVE_GOG_DE_URL='https://www.gog.com/game/the_settlers_2_gold_edition'
ARCHIVE_GOG_DE_MD5='f87a8fded6de455af4e6a284b3c4ed5e'
ARCHIVE_GOG_DE_VERSION='1.51-gog2.1.0.17'
ARCHIVE_GOG_DE_SIZE='370000'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./eula ./*.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./dos4gw.exe ./s2edit.exe ./s2.exe ./setup.exe ./setup.ini video/smackply.exe ./drivers'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./settlers2.gog ./settlers2.inst ./settler2.vmc ./data/animdat ./data/bobs ./data/*.lst ./data/cbob ./data/*.dat ./data/*.idx ./data/io/*.dat ./data/io/*.fnt ./data/masks ./data/mbob ./data/missions/mis_00*.rtx ./data/missions/mis_10*.rtx ./data/sounddat ./data/textures ./gfx/palette ./gfx/pics2 ./gfx/pics/install.lbm ./gfx/pics/mission ./gfx/pics/setup013.lbm ./gfx/pics/setup015.lbm ./gfx/pics/setup666.lbm ./gfx/pics/setup667.lbm ./gfx/pics/setup801.lbm ./gfx/pics/setup802.lbm ./gfx/pics/setup803.lbm ./gfx/pics/setup804.lbm ./gfx/pics/setup805.lbm ./gfx/pics/setup806.lbm ./gfx/pics/setup810.lbm ./gfx/pics/setup811.lbm ./gfx/pics/setup895.lbm ./gfx/pics/setup896.lbm ./gfx/pics/setup899.lbm ./gfx/pics/setup990.lbm ./gfx/pics/world.lbm ./gfx/pics/worldmsk.lbm ./gfx/textures ./gfw_high.ico ./goggame-1207658786.ico'

ARCHIVE_GAME1_L10N_PATH='app'
ARCHIVE_GAME1_L10N_FILES='./install.scr ./video/intro.smk ./save/mission.dat ./gfx/pics/setup000.lbm ./gfx/pics/setup010.lbm ./gfx/pics/setup011.lbm ./gfx/pics/setup012.lbm ./gfx/pics/setup014.lbm ./gfx/pics/setup897.lbm ./gfx/pics/setup898.lbm ./gfx/pics/setup900.lbm ./gfx/pics/setup901.lbm ./gfx/pics/setup996.lbm ./gfx/pics/setup997.lbm ./gfx/pics/setup998.lbm ./data/resource.idx ./data/missions/mis_0100.rtx ./data/txt* ./data/online ./data/maps* ./data/io/editio.idx ./data/io/io.idx'

ARCHIVE_GAME2_L10N_PATH='app/__support/save'
ARCHIVE_GAME2_L10N_FILES='save/mission.dat'

CONFIG_FILES='./setup.ini'
DATA_DIRS='./data ./gfx ./save ./worlds'

GAME_IMAGE='settlers2.inst'
GAME_IMAGE_TYPE='iso'

APP_MAIN_TYPE='dosbox'
APP_MAIN_EXE='s2.exe'
APP_MAIN_PRERUN='@video\smackply video\intro.smk'
APP_MAIN_ICON_GOG_EN='gfw_high.ico'
APP_MAIN_ICON_GOG_FR='goggame-1207658786.ico'
APP_MAIN_ICON_GOG_DE='goggame-1207658786.ico'
APP_MAIN_ICON_RES='16 32 48 256'

APP_EDITOR_TYPE='dosbox'
APP_EDITOR_ID="${GAME_ID}_edit"
APP_EDITOR_EXE='s2edit.exe'
APP_EDITOR_NAME="$GAME_NAME - Editor"

APP_SETUP_TYPE='dosbox'
APP_SETUP_ID="${GAME_ID}_setup"
APP_SETUP_EXE='setup.exe'
APP_SETUP_NAME="$GAME_NAME - Setup"
APP_SETUP_CAT='Settings'

PACKAGES_LIST='PKG_DATA PKG_L10N PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_ID_GOG_DE="${PKG_L10N_ID}-de"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'
PKG_L10N_DESCRIPTION_GOG_DE='German localization'

PKG_BIN_ID="$GAME_ID"
PKG_BIN_ID_GOG_EN="${GAME_ID}-en"
PKG_BIN_ID_GOG_FR="${GAME_ID}-fr"
PKG_BIN_ID_GOG_DE="${GAME_ID}-de"
PKG_BIN_PROVIDE="$PKG_BIN_ID"
PKG_BIN_DESCRIPTION_GOG_EN='English version'
PKG_BIN_DESCRIPTION_GOG_FR='French version'
PKG_BIN_DESCRIPTION_GOG_DE='German version'
PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID $PKG_L10N_ID dosbox"

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
	organize_data "DOC_${PKG#PKG_}"   "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}"  "$PATH_GAME"
	organize_data "GAME1_${PKG#PKG_}" "$PATH_GAME"
	organize_data "GAME2_${PKG#PKG_}" "$PATH_GAME"
done

sed --in-place 's/SETTLERS2.gog/settlers2.gog/' "${PKG_DATA_PATH}${PATH_GAME}/$GAME_IMAGE"

PKG='PKG_DATA'
extract_and_sort_icons_from 'APP_MAIN'
rm "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON"

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_EDITOR' 'APP_SETUP'

# Build package

cat > "$postinst" << EOF
for res in $APP_MAIN_ICON_RES; do
	PATH_ICON="$PATH_ICON_BASE/\${res}x\${res}/apps"
	ln --symbolic $GAME_ID.png "\$PATH_ICON/$APP_EDITOR_ID.png"
	ln --symbolic $GAME_ID.png "\$PATH_ICON/$APP_SETUP_ID.png"
done
EOF

cat > "$prerm" << EOF
for res in $APP_MAIN_ICON_RES; do
	PATH_ICON="$PATH_ICON_BASE/\${res}x\${res}/apps"
	rm "\$PATH_ICON/$APP_EDITOR_ID.png"
	rm "\$PATH_ICON/$APP_SETUP_ID.png"
done
EOF

write_metadata 'PKG_DATA'
write_metadata 'PKG_BIN' 'PKG_L10N'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
