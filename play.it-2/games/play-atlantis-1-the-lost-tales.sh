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
# Atlantis: The Lost Tales
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='atlantis-1-the-lost-tales'
GAME_NAME='Atlantis: The Lost Tales'

ARCHIVES_LIST='ARCHIVE_GOG_EN ARCHIVE_GOG_FR'

ARCHIVE_GOG_EN='setup_atlantis_the_lost_tales_2.0.0.15.exe'
ARCHIVE_GOG_EN_URL='https://www.gog.com/game/atlantis_the_lost_tales'
ARCHIVE_GOG_EN_MD5='287170bea9041b4e29888d97f87eb9fc'
ARCHIVE_GOG_EN_VERSION='1.0-gog2.0.0.15'
ARCHIVE_GOG_EN_SIZE='1900000'

ARCHIVE_GOG_FR='setup_atlantis_the_lost_tales_french_2.1.0.15.exe'
ARCHIVE_GOG_FR_URL='https://www.gog.com/game/atlantis_the_lost_tales'
ARCHIVE_GOG_FR_MD5='0cb6b037a457d35dacd23e1f22aea57b'
ARCHIVE_GOG_FR_VERSION='1.0-gog2.1.0.15'
ARCHIVE_GOG_FR_SIZE='1900000'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./manual.pdf'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.exe ./cryo.dll ./mss32.dll'

ARCHIVE_GAME_L10N_PATH='app'
ARCHIVE_GAME_L10N_FILES='./images/end.tga ./scenar ./sprlist ./wav'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./*.big ./cyclo ./dialog ./images/credit*.tga ./images/gover*.tga ./images/preintro.tga ./puzzles ./sprite ./ubb_vue ./wam'

APP_REGEDIT="$GAME_ID.reg"

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='atlantis.exe'
APP_MAIN_ICON='atlantis.exe'
APP_MAIN_ICON_RES='32'

PACKAGES_LIST='PKG_DATA PKG_L10N PKG_BIN'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_ID_GOG_EN="${PKG_L10N_ID}-en"
PKG_L10N_ID_GOG_FR="${PKG_L10N_ID}-fr"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION_GOG_EN='English localization'
PKG_L10N_DESCRIPTION_GOG_FR='French localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ID="$GAME_ID"
PKG_BIN_ARCH='32'
PKG_BIN_ID_GOG_EN="${PKG_BIN_ID}-en"
PKG_BIN_ID_GOG_FR="${PKG_BIN_ID}-fr"
PKG_BIN_PROVIDE="$PKG_BIN_ID"
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID wine"
PKG_BIN_DESCRIPTION_GOG_EN='English version'
PKG_BIN_DESCRIPTION_GOG_FR='French version'

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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
tolower "$PLAYIT_WORKDIR/gamedata"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_BIN'
extract_and_sort_icons_from 'APP_MAIN'
move_icons_to 'PKG_DATA'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Create registry file

cat > "${PKG_BIN_PATH}${PATH_GAME}/$GAME_ID.reg" <<- 'EOF'
REGEDIT4

[HKEY_CURRENT_USER\Software\CRYO\Atlantis\GameDirectory]
@="C:\\atlantis-1-the-lost-tales\\"
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
