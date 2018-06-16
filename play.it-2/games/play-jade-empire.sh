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
# Jade Empire
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='jade-empire'
GAME_NAME='Jade Empire'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_EN_OLD ARCHIVE_GOG_FR ARCHIVE_GOG_FR_OLD'

ARCHIVE_GOG_EN='setup_jade_empire_1.00_(15538).exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/jade_empire_special_edition'
ARCHIVE_GOG_EN_MD5='e68f17f59bde2254ab1e9b70c078e9f1'
ARCHIVE_GOG_EN_VERSION='1.00-gog15538'
ARCHIVE_GOG_EN_SIZE='7600000'
ARCHIVE_GOG_EN_PART1='setup_jade_empire_1.00_(15538)-1.bin'
ARCHIVE_GOG_EN_PART1_MD5='6470aa8dac5486d7c66336686e2e442d'
ARCHIVE_GOG_EN_PART1_TYPE='innosetup'
ARCHIVE_GOG_EN_PART2='setup_jade_empire_1.00_(15538)-2.bin'
ARCHIVE_GOG_EN_PART2_MD5='57f4931e55373a9c994b67d14f43dc1c'
ARCHIVE_GOG_EN_PART2_TYPE='innosetup'

ARCHIVE_GOG_EN_OLD='setup_jade_empire_2.0.0.4.exe'
ARCHIVE_GOG_EN_OLD_MD5='8f9db8c43a9cab6cd00de3d6e69fbda5'
ARCHIVE_GOG_EN_OLD_VERSION='1.0-gog2.0.0.4'
ARCHIVE_GOG_EN_OLD_SIZE='7800000'
ARCHIVE_GOG_EN_OLD_PART1='setup_jade_empire_2.0.0.4-1.bin'
ARCHIVE_GOG_EN_OLD_PART1_MD5='9fbfbc9b047288ebcbac9551a5f27ae8'
ARCHIVE_GOG_EN_OLD_PART1_TYPE='innosetup'
ARCHIVE_GOG_EN_OLD_PART2='setup_jade_empire_2.0.0.4-2.bin'
ARCHIVE_GOG_EN_OLD_PART2_MD5='94af70b645c525b7263258c91d95cd92'
ARCHIVE_GOG_EN_OLD_PART2_TYPE='innosetup'
ARCHIVE_GOG_EN_OLD_PART3='setup_jade_empire_2.0.0.4-3.bin'
ARCHIVE_GOG_EN_OLD_PART3_MD5='3efd05ca48fc9d2dfe79b2fab2456df0'
ARCHIVE_GOG_EN_OLD_PART3_TYPE='innosetup'
ARCHIVE_GOG_EN_OLD_PART4='setup_jade_empire_2.0.0.4-4.bin'
ARCHIVE_GOG_EN_OLD_PART4_MD5='a480e87364cc8ab2a519c1f09a2da2c9'
ARCHIVE_GOG_EN_OLD_PART4_TYPE='innosetup'
ARCHIVE_GOG_EN_OLD_PART5='setup_jade_empire_2.0.0.4-5.bin'
ARCHIVE_GOG_EN_OLD_PART5_MD5='081042ad8561b599add7b2f366cf3da8'
ARCHIVE_GOG_EN_OLD_PART5_TYPE='innosetup'

ARCHIVE_GOG_FR='setup_jade_empire_french_1.00_(15538).exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/jade_empire_special_edition'
ARCHIVE_GOG_FR_MD5='872f400a6af8bae9af9bf0b2025d29f4'
ARCHIVE_GOG_FR_VERSION='1.00-gog15538'
ARCHIVE_GOG_FR_SIZE='7700000'
ARCHIVE_GOG_FR_PART1='setup_jade_empire_french_1.00_(15538)-1.bin'
ARCHIVE_GOG_FR_PART1_MD5='39182b7e8651b92b1703e6c2b89c783c'
ARCHIVE_GOG_FR_PART1_TYPE='innosetup'
ARCHIVE_GOG_FR_PART2='setup_jade_empire_french_1.00_(15538)-2.bin'
ARCHIVE_GOG_FR_PART2_MD5='428bf4eba51fde69fa6fe6fb05aadb96'
ARCHIVE_GOG_FR_PART2_TYPE='innosetup'

ARCHIVE_GOG_FR_OLD='setup_jade_empire_french_2.1.0.8.exe'
ARCHIVE_GOG_FR_OLD_MD5='f3bf58362182f55cfc91f5c975a75862'
ARCHIVE_GOG_FR_OLD_VERSION='1.0-gog2.1.0.8'
ARCHIVE_GOG_FR_OLD_SIZE='7500000'
ARCHIVE_GOG_FR_OLD_TYPE='rar'
ARCHIVE_GOG_FR_OLD_GOGID='1207659237'
ARCHIVE_GOG_FR_OLD_PART1='setup_jade_empire_french_2.1.0.8-1.bin'
ARCHIVE_GOG_FR_OLD_PART1_MD5='3100a81c965ede19b51d8feac8e80e7d'
ARCHIVE_GOG_FR_OLD_PART1_TYPE='rar'
ARCHIVE_GOG_FR_OLD_PART2='setup_jade_empire_french_2.1.0.8-2.bin'
ARCHIVE_GOG_FR_OLD_PART2_MD5='53fb5d838fb7e5d084b529861287e3ae'
ARCHIVE_GOG_FR_OLD_PART2_TYPE='rar'

ARCHIVE_DOC_L10N_PATH_GOG='app/docs'
ARCHIVE_DOC_L10N_PATH_GOG_FR_OLD='game/docs'
ARCHIVE_DOC_L10N_FILES='./*'

ARCHIVE_DOC_DATA_PATH_GOG='app'
ARCHIVE_DOC_DATA_FILES='./*.txt'

ARCHIVE_GAME_BIN_PATH_GOG='app'
ARCHIVE_GAME_BIN_PATH_GOG_FR_OLD='game'
ARCHIVE_GAME_BIN_FILES='./jadeempire*.exe ./binkw32.dll ./d3d9.dll ./ogg.dll ./vorbis.dll ./vorbisfile.dll'

ARCHIVE_GAME_L10N_PATH_GOG='app'
ARCHIVE_GAME_L10N_PATH_GOG_FR_OLD='game'
ARCHIVE_GAME_L10N_FILES='./*.tlk ./sound ./data/bips ./movies/attract.bik ./movies/c01_cutzu.bik ./movies/c04_princisfox.bik ./movies/c06_partycall.bik ./movies/cut_c3escape*.bik ./movies/j00_cut_open_c1.bik ./movies/j00_cut_open_c6.bik ./movies/j01_jiahand_01.bik ./movies/j04_cut_lotfin*.bik ./movies/j04_pop_*.bik ./movies/j06_recover_01.bik ./movies/j07_cut_drop01.bik ./movies/j07_cut_final06b.bik ./movies/j07_cut_final06.bik ./movies/j07_cut_final06c.bik ./movies/j07_cut_final06d.bik ./movies/j07_cut_final06e.bik ./movies/j07_cut_final06f.bik ./movies/j07_cut_final06g.bik ./movies/j08_cut_ending3.bik ./movies/j08_cut_final_01.bik ./movies/j08_cut_stone_01.bik ./movies/j08_ending3_*.bik ./movies/j08_final_01_*.bik ./movies/j08_stone_01_*.bik'

ARCHIVE_GAME_DATA_PATH_GOG='app'
ARCHIVE_GAME_DATA_PATH_GOG_FR_OLD='game'
ARCHIVE_GAME_DATA_FILES='./*.key ./fonts ./override ./shaderpc ./data/*.bif ./data/*.mod ./data/*.rim ./data/*.xml ./data/j* ./data/launcher ./movies/black.bik ./movies/bwlogo.bik ./movies/c02_barfight.bik ./movies/c04_golemfrenzy.bik ./movies/c08_*.bik ./movies/creditmovie.bik ./movies/cut_c2a100fly.bik ./movies/cut_c2damclose.bik ./movies/demon_*.bik ./movies/graymatr.bik ./movies/gsl_short.bik ./movies/j00_cut_dfly_*.bik ./movies/j00_dfly_*.bik ./movies/j01_a_dsflyers.bik ./movies/j01_amul_*.bik ./movies/j01_cut_*.bik ./movies/j01_dfly_sw_to.bik ./movies/j01_ghostmaster.bik ./movies/j01_ml_*.bik ./movies/j01_summoning.bik ./movies/j01_wd*.bik ./movies/j02_*.bik ./movies/j03_*.bik ./movies/j04_bw_stomp.bik ./movies/j04_cho_zhang.bik ./movies/j04_cut_dfly_*.bik ./movies/j04_gangs_prob.bik ./movies/j04_kick_*.bik ./movies/j05_*.bik ./movies/j06_abbot_intro.bik ./movies/j06_cut_restored.bik ./movies/j07_cut_final06z.bik ./movies/j07_cut_romance*.bik ./movies/j07_li_dream*.bik ./movies/j07_romance*.bik ./movies/j08_cut_final_02.bik ./movies/j08_cut_final_03.bik ./movies/j08_cut_stone_02.bik ./movies/j08_final_02_*.bik ./movies/j08_final_03_*.bik ./movies/j08_stone_02_*.bik ./movies/khdie_*.bik ./movies/ninja_*.bik ./movies/publisher.bik ./movies/quickbink.bik ./movies/ravager_*.bik ./movies/rav_*.bik ./movies/soldier_*.bik'

CONFIG_FILES='./*.ini ./data/*.xml'
DATA_DIRS='./logs ./persistent ./save ./scratch'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='jadeempire.exe'
APP_MAIN_ICON='jadeempire.exe'
APP_MAIN_ICON_RES='16 24 32 48'

PACKAGES_LIST='PKG_L10N PKG_DATA PKG_BIN'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${GAME_ID}-l10n-en"
PKG_L10N_ID_GOG_FR="${GAME_ID}-l10n-fr"
PKG_L10N_ID_GOG_EN_OLD="$PKG_L10N_ID_GOG_EN"
PKG_L10N_ID_GOG_FR_OLD="$PKG_L10N_ID_GOG_FR"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine"

# Load common functions

target_version='2.2'

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

# Check that all parts of the installer are present

ARCHIVE_MAIN="$ARCHIVE"
case "$ARCHIVE" in
	('ARCHIVE_GOG_EN')
		set_archive 'ARCHIVE_PART1' 'ARCHIVE_GOG_EN_PART1'
		[ "$ARCHIVE_PART1" ] || set_archive_error_not_found 'ARCHIVE_GOG_EN_PART1'
		set_archive 'ARCHIVE_PART2' 'ARCHIVE_GOG_EN_PART2'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_EN_PART2'
	;;
	('ARCHIVE_GOG_EN_OLD')
		set_archive 'ARCHIVE_PART1' 'ARCHIVE_GOG_EN_OLD_PART1'
		[ "$ARCHIVE_PART1" ] || set_archive_error_not_found 'ARCHIVE_GOG_EN_OLD_PART1'
		set_archive 'ARCHIVE_PART2' 'ARCHIVE_GOG_EN_OLD_PART2'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_EN_OLD_PART2'
		set_archive 'ARCHIVE_PART3' 'ARCHIVE_GOG_EN_OLD_PART3'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_EN_OLD_PART3'
		set_archive 'ARCHIVE_PART4' 'ARCHIVE_GOG_EN_OLD_PART4'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_EN_OLD_PART4'
		set_archive 'ARCHIVE_PART5' 'ARCHIVE_GOG_EN_OLD_PART5'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_EN_OLD_PART5'
	;;
	('ARCHIVE_GOG_FR')
		set_archive 'ARCHIVE_PART1' 'ARCHIVE_GOG_FR_PART1'
		[ "$ARCHIVE_PART1" ] || set_archive_error_not_found 'ARCHIVE_GOG_FR_PART1'
		set_archive 'ARCHIVE_PART2' 'ARCHIVE_GOG_FR_PART2'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_FR_PART2'
	;;
	('ARCHIVE_GOG_FR_OLD')
		set_archive 'ARCHIVE_PART1' 'ARCHIVE_GOG_FR_OLD_PART1'
		[ "$ARCHIVE_PART1" ] || set_archive_error_not_found 'ARCHIVE_GOG_FR_OLD_PART1'
		set_archive 'ARCHIVE_PART2' 'ARCHIVE_GOG_FR_OLD_PART2'
		[ "$ARCHIVE_PART2" ] || set_archive_error_not_found 'ARCHIVE_GOG_FR_OLD_PART2'
	;;
esac
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

case "$ARCHIVE" in
	('ARCHIVE_GOG_FR_OLD')
		ln --symbolic "$(readlink --canonicalize $ARCHIVE_PART1)" "$PLAYIT_WORKDIR/$GAME_ID.r00"
		ln --symbolic "$(readlink --canonicalize $ARCHIVE_PART2)" "$PLAYIT_WORKDIR/$GAME_ID.r01"
		extract_data_from "$PLAYIT_WORKDIR/$GAME_ID.r00"
		tolower "$PLAYIT_WORKDIR/gamedata"
	;;
	(*)
		extract_data_from "$SOURCE_ARCHIVE"
	;;
esac

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

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
