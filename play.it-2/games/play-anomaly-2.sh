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
# Anomaly 2
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180224.1

# Set game-specific variables

GAME_ID='anomaly-2'
GAME_NAME='Anomaly 2'

ARCHIVES_LIST='ARCHIVE_HUMBLE'

ARCHIVE_HUMBLE='Anomaly2_Linux_1387299615.zip'
ARCHIVE_HUMBLE_URL='https://www.humblebundle.com/store/anomaly-2'
ARCHIVE_HUMBLE_MD5='46f0ecd5363106e9eae8642836c29dfc'
ARCHIVE_HUMBLE_SIZE='2500000'
ARCHIVE_HUMBLE_VERSION='1.0-humble1'

ARCHIVE_ICONS_PACK='anomaly-2_icons.tar.gz'
ARCHIVE_ICONS_PACK_MD5='73ddbd1651e08d6c8bb4735e5e0a4a81'

ARCHIVE_GAME_BIN_PATH='Anomaly 2 Linux DRM-free'
ARCHIVE_GAME_BIN_FILES='./Anomaly2 ./libopenal.so.1'

ARCHIVE_GAME_DATA_PATH='Anomaly 2 Linux DRM-free'
ARCHIVE_GAME_DATA_FILES='./*.dat ./*.idx'

ARCHIVE_ICONS_PATH='.'
ARCHIVE_ICONS_FILES='./32x32 ./48x48 ./64x64 ./256x256'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='gcc -m32 -o preload.so preload.c -ldl -shared -fPIC -Wall -Wextra
export LD_PRELOAD=./preload.so'
APP_MAIN_EXE='Anomaly2'

PACKAGES_LIST='PKG_DATA PKG_BIN'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTIOn='data'

PKG_BIN_ARCH='32'
PKG_BIN_DEPS_DEB="$PKG_DATA_ID, libgl1-mesa-glx | libgl1, libopenal1, gcc-multilib:amd64 | gcc, libc6-dev-i386:amd64 | libc6-dev"
PKG_BIN_DEPS_ARCH="$PKG_DATA_ID lib32-libgl lib32-openal gcc-multilib"

# Load common functions

target_version='2.5'

if [ -z "$PLAYIT_LIB2" ]; then
	[ -n "$XDG_DATA_HOME" ] || XDG_DATA_HOME="$HOME/.local/share"
	if [ -e "$XDG_DATA_HOME/play.it/libplayit2.sh" ]; then
		PLAYIT_LIB2="$XDG_DATA_HOME/play.it/libplayit2.sh"
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

PKG='PKG_BIN'
organize_data 'GAME_BIN' "$PATH_GAME"

PKG='PKG_DATA'
organize_data 'GAME_DATA' "$PATH_GAME"

PKG='PKG_DATA'
if [ "$ARCHIVE_ICONS" ]; then
	organize_data 'ICONS' "$PATH_ICON_BASE"
fi

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Hack to work around infinite loading times

cat > "${PKG_BIN_PATH}${PATH_GAME}/preload.c" << EOF
#define _GNU_SOURCE
#include <dlfcn.h>
#include <semaphore.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

static int (*_realSemTimedWait)(sem_t *, const struct timespec *) = NULL;

int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout) {
	if (abs_timeout->tv_nsec >= 1000000000) {
		((struct timespec *)abs_timeout)->tv_nsec -= 1000000000;
		((struct timespec *)abs_timeout)->tv_sec++;
	}
	return _realSemTimedWait(sem, abs_timeout);
}
__attribute__((constructor)) void init(void) {
	_realSemTimedWait = dlsym(RTLD_NEXT, "sem_timedwait");
}
EOF

# Build package

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
