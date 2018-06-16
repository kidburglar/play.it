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
# Divinity Original Sin
# build native Linux packages from the original installers
# send your bug reports to vv221@dotslashplay.it
###

script_version=20180501.4

# Set game-specific variables

GAME_ID='divinity-original-sin'
GAME_NAME='Divinity Original Sin'

ARCHIVES_LIST='ARCHIVE_GOG'

ARCHIVE_GOG='divinity_original_sin_enhanced_edition_en_2_0_119_430_ch_17075.sh'
ARCHIVE_GOG_URL='https://www.gog.com/game/divinity_original_sin_enhanced_edition'
ARCHIVE_GOG_MD5='89f526c1030d6d352b7df65361ab71e6'
ARCHIVE_GOG_VERSION='2.0.119.430-gog17075'
ARCHIVE_GOG_SIZE='11000000'
ARCHIVE_GOG_TYPE='mojosetup_unzip'

ARCHIVE_DOC_L10N_PATH='data/noarch/docs'
ARCHIVE_DOC_L10N_FILES='./*'

ARCHIVE_GAME_BIN_PATH='data/noarch/game'
ARCHIVE_GAME_BIN_FILES='./lib* ./EoCApp'

ARCHIVE_GAME_L10N_PATH='data/noarch/game'
ARCHIVE_GAME_L10N_FILES='./Data/Localization'

ARCHIVE_GAME_DATA_PATH='data/noarch/game'
ARCHIVE_GAME_DATA_FILES='./Data/*.pak ./DigitalMap'

CONFIG_FILES='Data/Localization/language.lsx'

APP_MAIN_TYPE='native'
APP_MAIN_PRERUN='case "${LANG%_*}" in
	('"'"'fr'"'"') lang='"'"'French'"'"' ;;
	('"'"'de'"'"') lang='"'"'German'"'"' ;;
	('"'"'it'"'"') lang='"'"'Italian'"'"' ;;
	('"'"'pl'"'"') lang='"'"'Polish'"'"' ;;
	('"'"'zh'"'"') lang='"'"'Chinese'"'"' ;;
	('"'"'ru'"'"') lang='"'"'Russian'"'"' ;;
	('"'"'es'"'"') lang='"'"'Spanish'"'"' ;;
	('"'"'en'"'"'|*) lang='"'"'English'"'"' ;;
esac
file="$PATH_CONFIG/Data/Localization/language.lsx"
pattern="$(printf '"'"'s/id="Value" value=".*"/id="Value" value="%s" type="20"/g'"'"' "$lang")"
sed --in-place "$pattern" "$file"
pulseaudio --start
gcc -s -O2 -shared -fPIC -o preload.so preload.c -ldl
export LD_PRELOAD=./preload.so'

APP_MAIN_EXE='EoCApp'
APP_MAIN_LIBS='.'
APP_MAIN_ICON='data/noarch/support/icon.png'
APP_MAIN_ICON_RES='256'

PACKAGES_LIST='PKG_BIN PKG_L10N PKG_DATA'

PKG_L10N_ID="${GAME_ID}-l10n"
PKG_L10N_PROVIDE="$PKG_L10N_ID"
PKG_L10N_DESCRIPTION='localization'

PKG_DATA_ID="${GAME_ID}-data"
PKG_DATA_DESCRIPTION='data'

PKG_BIN_ARCH='64'
PKG_BIN_DEPS="$PKG_L10N_ID $PKG_DATA_ID glibc libstdc++ sdl2 openal glx pulseaudio"
PKG_BIN_DEPS_ARCH='gcc mesa'
PKG_BIN_DEPS_DEB='gcc, mesa-common-dev'

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

# Extract game data

extract_data_from "$SOURCE_ARCHIVE"
prepare_package_layout

# Extract icon

PKG='PKG_DATA'
get_icon_from_temp_dir 'APP_MAIN'

rm --recursive "$PLAYIT_WORKDIR/gamedata"

# Write launchers

PKG='PKG_BIN'
write_launcher 'APP_MAIN'

# Hack to work around crash on Mesa drivers

cat > "${PKG_BIN_PATH}${PATH_GAME}/preload.c" << EOF
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <dlfcn.h>
#include <GL/gl.h>
#include <string.h>
#define _GLX_PUBLIC
const GLubyte *GLAPIENTRY glGetString( GLenum name ) {
	static void *next = NULL;
	static const char *vendor = "ATI Technologies, Inc.";
	if(name == GL_VENDOR)
		return (const GLubyte *)vendor;
	if(!next)
		next = dlsym(RTLD_NEXT, "glGetString");
	return ((const GLubyte *GLAPIENTRY (*)(GLenum))next)(name);
}
 _GLX_PUBLIC void (*glXGetProcAddressARB(const GLubyte * procName)) (void) {
	static void *next = NULL;
	if (
		strcmp((const char *) procName, "glNamedStringARB") == 0 ||
		strcmp((const char *) procName, "glDeleteNamedStringARB") == 0 ||
		strcmp((const char *) procName, "glCompileShaderIncludeARB") == 0 ||
		strcmp((const char *) procName, "glIsNamedStringARB") == 0 ||
		strcmp((const char *) procName, "glGetNamedStringARB") == 0 ||
		strcmp((const char *) procName, "glGetNamedStringivARB") == 0
	) return NULL;
	if(!next)
		next = dlsym(RTLD_NEXT, "glXGetProcAddressARB");
		return ((_GLX_PUBLIC void (*(*)(const GLubyte *))(void))next)(procName);
}
EOF

# Build packages

write_metadata
build_pkg

# Clean up

rm --recursive "$PLAYIT_WORKDIR"

# Print instructions

print_instructions

exit 0
