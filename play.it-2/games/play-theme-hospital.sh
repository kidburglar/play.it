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
# Theme Hospital
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180331.3

# Set game-specific variables

GAME_ID='theme-hospital'
GAME_NAME='Theme Hospital'

ARCHIVE_GOG='setup_theme_hospital_2.1.0.8.exe'
ARCHIVE_GOG_URL='https://www.gog.com/game/theme_hospital'
ARCHIVE_GOG_MD5='c1dc6cd19a3e22f7f7b31a72957babf7'
ARCHIVE_GOG_SIZE='210000'
ARCHIVE_GOG_VERSION='1.0-gog2.0.0.7'

ARCHIVE_DOC_DATA_PATH='app'
ARCHIVE_DOC_DATA_FILES='./*.txt ./*.pdf'

ARCHIVE_GAME_BIN_DOSBOX_PATH='app'
ARCHIVE_GAME_BIN_DOSBOX_FILES='./*.bat ./*.cfg ./*.exe ./*.ini ./sound/*.exe ./sound/*.ini ./sound/midi/*.bat ./sound/midi/*.exe'

ARCHIVE_GAME_DATA_PATH='app'
ARCHIVE_GAME_DATA_FILES='./anims ./cfg ./data ./datam ./goggame-1207659026.ico ./intro ./levels ./qdata ./qdatam ./save ./sound'

CONFIG_FILES='./*.ini ./*.cfg'
DATA_DIRS='./save'

APP_MAIN_TYPE='dosbox'
APP_MAIN_EXE='hospital.exe'
APP_MAIN_ICON='goggame-1207659026.ico'
APP_MAIN_ICON_RES='16 32 48 256'

PACKAGES_LIST='PKG_BIN_DOSBOX PKG_BIN_CORSIXTH PKG_DATA'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ID="$GAME_ID"

PKG_BIN_DOSBOX_ID="${PKG_BIN_ID}-dosbox"
PKG_BIN_DOSBOX_PROVIDE="$PKG_BIN_ID"
PKG_BIN_DOSBOX_ARCH='32'
PKG_BIN_DOSBOX_DEPS="$PKG_DATA_ID dosbox"

PKG_BIN_CORSIXTH_ID="${PKG_BIN_ID}-corsixth"
PKG_BIN_CORSIXTH_PROVIDE="$PKG_BIN_ID"
PKG_BIN_CORSIXTH_DEPS="$PKG_DATA_ID corsix-th"

# Load common functions

target_version='2.7'

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

# Set path to CorsixTH depending on target system
case "$OPTION_PACKAGE" in
	('arch')
		PATH_CORSIXTH='/usr/share/CorsixTH'
	;;
	('deb')
		PATH_CORSIXTH='/usr/share/games/corsix-th'
	;;
	(*)
		liberror 'OPTION_PACKAGE' "$0"
	;;
esac

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout
rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Extract icon

PKG='PKG_DATA'
extract_and_sort_icons_from 'APP_MAIN'
rm "${PKG_DATA_PATH}${PATH_GAME}/$APP_MAIN_ICON"

# Write launcher for DOSBox version

PKG='PKG_BIN_DOSBOX'
write_launcher 'APP_MAIN'

# Write launcher for CorsixTH version

PKG='PKG_BIN_CORSIXTH'
file="${PKG_BIN_CORSIXTH_PATH}${PATH_BIN}/$GAME_ID"
mkdir --parents "${file%/*}"
cat > "$file" << EOF
#!/bin/sh
set -o errexit

cd '$PATH_CORSIXTH'
exec ./CorsixTH "\$@"

exit 0
EOF

chmod 755 "$file"
write_desktop 'APP_MAIN'

# Build package

file="$PATH_CORSIXTH/Lua/config_finder.lua"
pattern="s#\\(^  theme_hospital_install\\) = .\\+#\\1 = [[$PATH_GAME]],#"
cat > "$postinst" << EOF
sed --in-place '$pattern' '$file'
EOF
write_metadata 'PKG_BIN_CORSIXTH'
write_metadata 'PKG_BIN_DOSBOX' 'PKG_DATA'
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

printf '\n'
printf 'CorsixTH:'
print_instructions 'PKG_DATA' 'PKG_BIN_CORSIXTH'
printf 'DOSBox:'
print_instructions 'PKG_DATA' 'PKG_BIN_DOSBOX'

exit 0
