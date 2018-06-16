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
# Thief 3: Deadly Shadows
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='thief3'
GAME_NAME='Thief 3: Deadly Shadows'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='setup_thief3_2.0.0.6.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/thief_3'
ARCHIVE_GOG_MD5='e5b84de58a1037f3e8aa3a1bb2a982be'
ARCHIVE_GOG_VERSION='1.1-gog2.0.0.6'
ARCHIVE_GOG_SIZE='2300000'
ARCHIVE_GOG_TYPE='innosetup'

#ARCHIVE_SNEAKY='Setup_T3SneakyUpgrade_Full_1.1.8.exe'
#ARCHIVE_SNEAKY_MD5='b1e96ddb28340f29c9da315e3a47bdbb'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./*.pdf ./eula.txt ./readme.rtf'

ARCHIVE_GAME_BIN_PATH='app'
ARCHIVE_GAME_BIN_FILES='./*.dll ./*.reg ./system/*.exe ./system/*.dll'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./*.ini ./system ./content'

CONFIG_FILES='./*.ini'
CONFIG_DIRS='./saves'

APP_REGEDIT="thief.reg"

APP_MAIN_TYPE='wine'
APP_MAIN_EXE='system/t3.exe'
APP_MAIN_ICON='gfw_high.ico'
APP_MAIN_ICON_RES='32'

PACKAGES_LIST='PKG_BIN PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS="$PKG_DATA_ID wine"

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

# Add regedit file

cat > "$PLAYIT_WORKDIR/gamedata/app/thief.reg" <<- 'EOF'
	Windows Registry Editor Version 5.00

	[HKEY_LOCAL_MACHINE\Software\Ion Storm]

	[HKEY_LOCAL_MACHINE\Software\Ion Storm\Thief - Deadly Shadows]
EOF
cat >> "$PLAYIT_WORKDIR/gamedata/app/thief.reg" <<- EOF
	"ION_ROOT"="C:\\\\$GAME_ID"
	"SaveGamePath"="C:\\\\$GAME_ID\\\\saves"
EOF

cat >> "$PLAYIT_WORKDIR/gamedata/app/thief.reg" <<- 'EOF'
	[HKEY_LOCAL_MACHINE\Software\Ion Storm\Thief - Deadly Shadows\SecuROM]

	[HKEY_LOCAL_MACHINE\Software\Ion Storm\Thief - Deadly Shadows\SecuROM\Locale]
	"ADMIN_RIGHTS"="Application requires Windows administrator rights."
	"ANALYSIS_DISCLAIMER"="Dear Software User,\\n\\nThis test program has been developed with your personal interest in mind to check for possible hardware and/or software incompatibility on your PC. To shorten the analysis time, system information is collected (similar to the Microsoft's msinfo32.exe program).\\n\\nData will be compared with our knowledge base to discover hardware/software conflicts. Submitting the log file is totally voluntary. The collected data is for evaluation purposes only and is not used in any other manner.\\n\\nYour Support Team\\n\\nDo you want to start?"
	"ANALYSIS_DONE"="The Information was successfully collected and stored to the following file:\\n\\n\\\"%FILE%\\\"\\n\\nPlease contact Customer Support for forwarding instructions."
	"AUTH_TIMEOUT"="Unable to authenticate original disc within time limit."
	"EMULATION_DETECTED"="Conflict with Disc Emulator Software detected."
	"NO_DISC"="No disc inserted."
	"NO_DRIVE"="No CD or DVD drive found."
	"NO_ORIG_FOUND"="Please insert the original disc instead of a backup."
	"TITLEBAR"="Thief: Deadly Shadows"
	"WRONG_DISC"="Wrong Disc inserted.  Please insert the Thief: Deadly Shadows disc into your CD/DVD drive."
EOF

set_standard_permissions "$PLAYIT_WORKDIR/gamedata"

for PKG in $PACKAGES_LIST; do
	organize_data "DOC_${PKG#PKG_}"  "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

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
