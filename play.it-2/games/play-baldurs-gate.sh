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
# Baldur’s Gate
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

SCRIPT_DEPS='unix2dos'

GAME_ID='baldurs-gate'
GAME_NAME='Baldur’s Gate'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='gog_baldur_s_gate_the_original_saga_2.1.0.10.sh'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/baldurs_gate_enhanced_edition'
ARCHIVE_GOG_EN_MD5='6810388ef67960dded254db5750f9aa5'
ARCHIVE_GOG_EN_VERSION='1.3.5521-gog2.1.0.10'
ARCHIVE_GOG_EN_SIZE='3100000'

ARCHIVE_GOG_FR='gog_baldur_s_gate_the_original_saga_french_2.1.0.10.sh'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/baldurs_gate_enhanced_edition'
ARCHIVE_GOG_FR_MD5='87ed67decb79e497b8c0ce9e0b16ac4c'
ARCHIVE_GOG_FR_VERSION='1.3.5521-gog2.1.0.10'
ARCHIVE_GOG_FR_SIZE='3100000'

ARCHIVE_DOC_L10N_PATH='data/noarch/docs'
ARCHIVE_DOC_L10N_FILES='./end?user?license?agreement.txt ./installer_readme.txt ./manual*.pdf ./readme_totsc.txt ./readme.txt'

ARCHIVE_DOC_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC_DATA_FILES='./map.pdf ./readme_patch.txt'

ARCHIVE_GAME_BIN_PATH_GOG_EN="data/noarch/prefix/drive_c/gog games/baldur's gate"
ARCHIVE_GAME_BIN_PATH_GOG_FR="data/noarch/prefix/drive_c/gog games/baldur's gate (french)"
ARCHIVE_GAME_BIN_FILES='./*.cfg ./bgmain.exe ./bgmain2.exe ./mconvert.exe ./keymap.ini ./override/*.dll'

ARCHIVE_GAME_L10N_PATH_GOG_EN="data/noarch/prefix/drive_c/gog games/baldur's gate"
ARCHIVE_GAME_L10N_PATH_GOG_FR="data/noarch/prefix/drive_c/gog games/baldur's gate (french)"
ARCHIVE_GAME_L10N_FILES='./*.tlk ./baldur.exe ./config.exe ./baldur.ini ./*save/*/*.wmp ./data/area000c.bif ./data/chasound.bif ./data/cresound.bif ./data/mpsounds.bif ./data/npcsound.bif ./movies/moviecd1.bif ./movies/moviecd2.bif ./movies/moviecd3.bif ./movies/moviecd4.bif ./override/*.wav ./sounds/*.wav'

ARCHIVE_GAME_DATA_PATH_GOG_EN="data/noarch/prefix/drive_c/gog games/baldur's gate"
ARCHIVE_GAME_DATA_PATH_GOG_FR="data/noarch/prefix/drive_c/gog games/baldur's gate (french)"
ARCHIVE_GAME_DATA_FILES='./*.key ./characters ./music ./scripts ./*save/*/*.bmp ./*save/*/*.gam ./*save/*/*.sav ./data/area000a.bif ./data/area000b.bif ./data/area000d.bif ./data/area000e.bif ./data/area000f.bif ./data/area000g.bif ./data/area000h.bif ./data/area01* ./data/area02* ./data/area03* ./data/area04* ./data/area05* ./data/area06* ./data/area07* ./data/area08* ./data/area09* ./data/area1* ./data/area2* ./data/area3* ./data/area4* ./data/area5* ./data/areas.bif ./data/armisc.bif ./data/chaanim.bif ./data/creanim.bif ./data/creature.bif ./data/default.bif ./data/dialog.bif ./data/effects.bif ./data/exarmaps.bif ./data/expareas.bif ./data/gui.bif ./data/items.bif ./data/mpcreanm.bif ./data/mpgui.bif ./data/objanim.bif ./data/rndencnt.bif ./data/scripts.bif ./data/sfxsound.bif ./data/spells.bif ./movies/moviecd5.bif ./movies/moviecd6.bif ./movies/movies.bif ./override/*.2da ./override/*.are ./override/*.bam ./override/*.bcs ./override/*.bmp ./override/*.cre ./override/*.dlg ./override/*.itm ./override/*.mos ./override/*.spl ./override/*.sto ./override/*.wed ./override/*.wmp ./sounds/*.txt'

CONFIG_FILES='./*.ini'
DATA_DIRS='./characters ./mpsave ./override ./portraits ./save ./scripts'
DATA_FILES='./*.tlk ./chitin.key'

APP_WINETRICKS='vd=800x600'

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='bgmain2.exe'
APP_MAIN_ICON='baldur.exe'
APP_MAIN_ICON_RES='16 32'

APP_CONFIG_ID="${GAME_ID}_config"
APP_CONFIG_TYPE='wine'
APP_CONFIG_EXE='config.exe'
APP_CONFIG_ICON='config.exe'
APP_CONFIG_ICON_RES='16 32'
APP_CONFIG_NAME="$GAME_NAME - configuration"
APP_CONFIG_CAT='Settings'

PACKAGES_LIST='PKG_L10N PKG_DATA PKG_BIN'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_L10N_ID, $PKG_DATA_ID, wine32-development | wine32 | wine-bin | wine-i386 | wine-staging-i386, wine:amd64 | wine, winetricks"
PKG_BIN_DEPS_ARCH="$PKG_L10N_ID $PKG_DATA_ID wine winetricks"

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
set_standard_permissions "$PLAYIT_WORKDIR/gamedata"
tolower "$PLAYIT_WORKDIR/gamedata/data/noarch/docs"
tolower "$PLAYIT_WORKDIR/gamedata/data/noarch/prefix/drive_c"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_L10N'
extract_and_sort_icons_from 'APP_MAIN' 'APP_CONFIG'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Tweak paths in baldur.ini

for drive in 'HD0' 'CD1' 'CD2' 'CD3' 'CD4' 'CD5' 'CD6'; do
	sed --in-place "s/$drive:=.\+/$drive:=C:\\\\$GAME_ID\\\\/" "${PKG_L10N_PATH}${PATH_GAME}/baldur.ini"
done

# Use more sensible default settings for modern hardware

sed --in-place 's/\(Path Search Nodes\)=.\+/\1=400000/' "${PKG_L10N_PATH}${PATH_GAME}/baldur.ini"
sed --in-place 's/\(CacheSize\)=.\+/\1=1024/'           "${PKG_L10N_PATH}${PATH_GAME}/baldur.ini"
unix2dos "${PKG_L10N_PATH}${PATH_GAME}/baldur.ini" > /dev/null

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN' 'APP_CONFIG'

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
