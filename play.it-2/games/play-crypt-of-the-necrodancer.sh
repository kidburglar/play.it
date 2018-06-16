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
# Crypt of the Necrodancer
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='crypt-of-the-necrodancer'
GAME_NAME='Crypt of the NecroDancer'

ARCHIVES_LIST='ARCHIVE_GOG ARCHIVE_GOG_OLD ARCHIVE_GOG_OLDER ARCHIVE_GOG_OLDEST'

ARCHIVE_GOG='crypt_of_the_necrodancer_en_1_29_14917.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/crypt_of_the_necrodancer'
ARCHIVE_GOG_MD5='70d3e29a2a48901d02541d8b1c6326ba'
ARCHIVE_GOG_SIZE='1600000'
ARCHIVE_GOG_VERSION='1.29-gog14917'
ARCHIVE_GOG_TYPE='mojosetup'

ARCHIVE_GOG_OLD='gog_crypt_of_the_necrodancer_2.4.0.7.sh'
ARCHIVE_GOG_OLD_MD5='a8c21ce12e7e4c769aaddd76321672e4'
ARCHIVE_GOG_OLD_SIZE='1700000'
ARCHIVE_GOG_OLD_VERSION='1.28-gog2.4.0.7'

ARCHIVE_GOG_OLDER='gog_crypt_of_the_necrodancer_2.3.0.6.sh'
ARCHIVE_GOG_OLDER_MD5='bece155772937aa32d2b4eba3aac0dd0'
ARCHIVE_GOG_OLDER_SIZE='1500000'
ARCHIVE_GOG_OLDER_VERSION='1.27-gog2.3.0.6'

ARCHIVE_GOG_OLDEST='gog_crypt_of_the_necrodancer_2.3.0.5.sh'
ARCHIVE_GOG_OLDEST_MD5='8a6e7c3d26461aa2fa959b8607e676f7'
ARCHIVE_GOG_OLDEST_SIZE='1500000'
ARCHIVE_GOG_OLDEST_VERSION='1.27-gog2.3.0.5'

ARCHIVE_ICONS_PACK='crypt-of-the-necrodancer_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='04d2bb19adc13dbadce6161bd92bf59a'

ARCHIVE_DOC1_DATA_PATH='data/noarch/docs'
ARCHIVE_DOC1_DATA_FILES='./*'

ARCHIVE_DOC2_DATA_PATH='data/noarch/game/'
ARCHIVE_DOC2_DATA_FILES='./license.txt'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./*.so.* ./fmod ./NecroDancer ./essentia*'

ARCHIVE_GAME_MUSIC_PATH='data/noarch/game'
ARCHIVE_GAME_MUSIC_FILES='./data/music'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./data/*.png ./data/*.xml ./data/bestiary ./data/entities ./data/essentia ./data/gui ./data/items ./data/languages ./data/level ./data/lua ./data/mainmenu ./data/mentor ./data/particles ./data/sounds* ./data/spells ./data/swipes ./data/text ./data/traps ./data/video'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./16x16 ./32x32 ./128x128 ./256x256'

DATA_DIRS='./data/custom_music ./downloaded_dungeons ./downloaded_mods ./logs ./mods ./replays'
DATA_FILES='./data/save_data.xml ./data/played.dat'

APP_MAIN_TYPE='native'
APP_MAIN_LIBS='.'
APP_MAIN_EXE='NecroDancer'
APP_MAIN_ICON_GOG='data/noarch/support/icon.png'
APP_MAIN_ICON_GOG_RES='256'

PACKAGES_LIST='PKG_MUSIC PKG_DATA PKG_BIN'

PKG_MUSIC_ID="${GAME_ID}-music"
PKG_MUSIC_DESCRIPTION='music'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_PROVIDE="${GAME_ID}-video"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_MUSIC_ID, $PKG_DATA_ID, libc6, libstdc++6, libgl1-mesa-glx | libgl1, libxrandr2, libopenal1, libvorbis0a"
PKG_BIN_DEPS_ARCH="$PKG_MUSIC_ID $PKG_DATA_ID lib32-glibc lib32-gcc-libs lib32-libgl lib32-libxrandr lib32-openal lib32-libogg lib32-libvorbis"

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

# Try to load icons archive

ARCHIVE_MAIN="$ARCHIVE"
set_archive 'ARCHIVE_ICONS' 'ARCHIVE_ICONS_PACK'
ARCHIVE="$ARCHIVE_MAIN"

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
if [ "$ARCHIVE_ICONS" ]; then
	(
		ARCHIVE='ARCHIVE_ICONS'
		extract_data_from "$ARCHIVE_ICONS"
	)
fi

for PKG in $PACKAGES_LIST; do
	organize_data "DOC1_${PKG#PKG_}" "$PATH_DOC"
	organize_data "DOC2_${PKG#PKG_}" "$PATH_DOC"
	organize_data "GAME_${PKG#PKG_}" "$PATH_GAME"
done

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	organize_data 'ICONS' "$PATH_ICON_BASE"
else
	get_icon_from_temp_dir 'APP_MAIN'
fi

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
