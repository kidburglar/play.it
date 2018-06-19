#!/bin/sh -e
set -o errexit

###
# Copyright (c) 2015-2018, Antoine Le Gonidec
# Copyright (c) 2018, Solène Huault
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
# Syberia
# build native Linux packages from the original installers
# send your bug reports to mopi@dotslashplay.it
###

script_version=20180619.1

# Set game-specific variables

GAME_ID='syberia'
GAME_NAME='Syberia'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_EN_OLD ARCHIVE_GOG_FR ARCHIVE_GOG_FR_OLD'

ARCHIVE_GOG_EN='setup_syberia_1.0.0_hotfix3_(18946).exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/syberia'
ARCHIVE_GOG_EN_MD5='53d91df35a154584812d31b9ee353cb8'
ARCHIVE_GOG_EN_SIZE='1600000'
ARCHIVE_GOG_EN_VERSION='1.0.0.3-gog18946'

ARCHIVE_GOG_EN_OLD='setup_syberia_1.0.0_hotfix2_(17897).exe'
ARCHIVE_GOG_EN_OLD_MD5='d52b7a776df7659d7fda9995715468a0'
ARCHIVE_GOG_EN_OLD_SIZE='1600000'
ARCHIVE_GOG_EN_OLD_VERSION='1.0.0.2-gog17897'

ARCHIVE_GOG_FR='setup_syberia_french_1.0.0_hotfix3_(18946).exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/syberia'
ARCHIVE_GOG_FR_MD5='41881248eefd53929bbaa97c1905a7fe'
ARCHIVE_GOG_FR_SIZE='1600000'
ARCHIVE_GOG_FR_VERSION='1.0.0.3-gog18946'

ARCHIVE_GOG_FR_OLD='setup_syberia_french_1.0.0_hotfix2_(17897).exe'
ARCHIVE_GOG_FR_OLD_MD5='d8a956a47c1b186a4364eff56c8cecb6'
ARCHIVE_GOG_FR_OLD_SIZE='1600000'
ARCHIVE_GOG_FR_OLD_VERSION='1.0.0.2-gog17897'

ARCHIVE_DOC_L10N_PATH='app'
ARCHIVE_DOC_L10N_FILES='./*.pdf ./*.txt'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./binkw32.dll ./ck2.dll ./ckzlib.dll ./dlls ./dvd.dll ./launch ./*.exe ./vxmath.dll'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./data/string.dat ./data/animations/momo/mo_tcheque.nmo ./sounds/*_docu??_*.mp3 ./sounds/*_inter??_*.mp3 ./sounds/*_tel??_*.mp3 ./sounds/*_ticket??_*.mp3 ./sounds/ka*.mp3 ./sounds/pack? ./textures/ingame/cal_aigle*.tga ./textures/ingame/cal_argent*.tga ./textures/ingame/cal_automate*.tga ./textures/ingame/cal_coupdemain*.tga ./textures/ingame/cal_ecluses*.tga ./textures/ingame/cal_fabrication*.tga ./textures/ingame/cal_grotte*.tga ./textures/ingame/cal_oiseau*.tga ./textures/ingame/cal_zeppelin*.tga ./textures/ingame/cel_maman.tga ./textures/ingame/cel_patron.tga ./textures/ingame/inventory_closeup_aguidetouris*.syj ./textures/ingame/inventory_closeup_aregistrehotel*.syj ./textures/ingame/inventory_closeup_blivreamerzone*.syj ./textures/ingame/inventory_closeup_blivrechampignon*.syj ./textures/ingame/inventory_closeup_bplanyouks*.syj ./textures/ingame/inventory_closeup_csansretour*.syj ./textures/ingame/inventory_closeup_vconfessioncure*.syj ./textures/ingame/inventory_closeup_vdepliantval*.syj ./textures/ingame/inventory_closeup_vfacturehuissier*.syj ./textures/ingame/inventory_closeup_vfax*.syj ./textures/ingame/inventory_closeup_vlettreanna*.syj ./textures/ingame/inventory_closeup_vlettreinnacheve*.syj ./textures/ingame/inventory_closeup_clivremusee*.syj ./textures/ingame/inventory_closeup_vjournalanna*.syj ./textures/ingame/inventory_closeup_acodeclienttemp.syj ./textures/ingame/inventory_closeup_apartition.syj ./textures/ingame/inventory_closeup_bdocdouanier.syj ./textures/ingame/inventory_closeup_btickettrain.syj ./textures/ingame/inventory_closeup_clettreastro.syj ./textures/ingame/inventory_closeup_vcoupurejournal.syj ./textures/ingame/inventory_closeup_vdocsortietraina.syj ./textures/ingame/inventory_closeup_vdocsortietrain.syj ./textures/ingame/inventory_closeup_vdocventeusine.syj ./textures/ingame/inventory_closeup_vjournalval.syj ./textures/ingame/inventory_closeup_vtickettrainval.syj ./textures/valreceptioninn/sc10069-0.syj ./video/an/c10_hansanna.syb ./video/anc10_hansanna.syb ./video/an/c2_hansannab.syb ./video/anc2_hansannab.syb ./video/an/c5_hansanna.syb ./video/anc5_hansanna.syb ./video/c10_hansanna.syb ./video/c2_hansannab.syb ./video/c5_hansanna.syb ./video/frc10_hansanna.syb ./video/frc2_hansannab.syb ./video/frc5_hansanna.syb'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./cmo ./data ./sounds ./splash ./textures ./video'

CONFIG_FILES='./*.ini ./launch/*.ini'

APP_REGEDIT="$GAME_ID.reg"

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='game.exe'
APP_MAIN_ICON='syberia.exe'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine"

# Load common functions

target_version='2.9'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Extract icons

PKG='PKG_BIN'
icons_get_from_package 'APP_MAIN'
icons_move_to 'PKG_DATA'

# Create player.ini file

cat > "${PKG_BIN_PATH}${PATH_GAME}/player.ini" << EOF
800 600 16 0 BaseCMO.cmo
EOF

# Add workaround for crash before reaching game menu

cat > "${PKG_BIN_PATH}${PATH_GAME}/$APP_REGEDIT" << 'EOF'
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wine\X11 Driver]
"UseXVidMode"="N"
EOF

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
