#!/bin/sh -e

###
# Copyright (c) 2015-2017, Antoine Le Gonidec
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
# conversion script for the Beatbuddy archive sold on HumbleBundle.com
# build a .deb package from the .zip archive
#
# send your bug reports to vv221@dotslashplay.it
###

script_version=20160717.1

# Set game-specific variables

SCRIPT_DEPS_HARD='fakeroot unzip'

GAME_ID='beatbuddy'
GAME_ID_SHORT='beat'
GAME_NAME='Beatbuddy: Tale of the Guardians'

GAME_ARCHIVE1='BeatbuddyLinux1439603370.zip'
GAME_ARCHIVE1_MD5='156d19b327a02ac4a277f6f6ad4e188e'
GAME_ARCHIVE_FULLSIZE='1100000'
PKG_REVISION='humble150815'

INSTALLER_GAME_PKG1='Beatbuddy/*'
INSTALLER_GAME_PKG2='Beatbuddy/Beatbuddy_Data/*.assets'

GAME_CACHE_DIRS=''
GAME_CACHE_FILES=''
GAME_CACHE_FILES_POST=''
GAME_CONFIG_DIRS=''
GAME_CONFIG_FILES=''
GAME_CONFIG_FILES_POST=''
GAME_DATA_DIRS='./logs'
GAME_DATA_FILES='./Beatbuddy.x86'
GAME_DATA_FILES_POST=''

APP_COMMON_ID="${GAME_ID_SHORT}-common.sh"

APP1_ID="${GAME_ID}"
APP1_EXE='./Beatbuddy.x86'
APP1_ICON='./Beatbuddy_Data/Resources/UnityPlayer.png'
APP1_ICON_RES='128x128'
APP1_NAME="${GAME_NAME}"
APP1_NAME_FR="${GAME_NAME}"
APP1_CAT='Game'

PKG_VERSION='1.0'

PKG1_ID="${GAME_ID}"
PKG1_VERSION="${PKG_VERSION}"
PKG1_ARCH='i386'
PKG1_CONFLICTS=''
PKG1_DEPS="libglu1-mesa | libglu1"
PKG1_RECS=''
PKG1_DESC="${GAME_NAME}
 package built from HumbleBundle.com archive
 ./play.it script version ${script_version}"

PKG2_ID="${GAME_ID}-assets"
PKG2_VERSION="${PKG_VERSION}"
PKG2_ARCH='all'
PKG2_CONFLICTS=''
PKG2_DEPS=''
PKG2_RECS=''
PKG2_DESC="${GAME_NAME} - assets
 package built from HumbleBundle.com archive
 ./play.it script version ${script_version}"

PKG1_DEPS="${PKG2_ID} (= ${PKG_VERSION}-${PKG_REVISION}), ${PKG1_DEPS}"

# Load common functions

TARGET_LIB_VERSION='1.13'

if [ -z "${PLAYIT_LIB}" ]; then
	PLAYIT_LIB='./play-anything.sh'
fi

if ! [ -e "${PLAYIT_LIB}" ]; then
	printf '\n\033[1;31mError:\033[0m\n'
	printf 'play-anything.sh not found.\n'
	printf 'It must be placed in the same directory than this script.\n\n'
	exit 1
fi

LIB_VERSION="$(grep '^# library version' "${PLAYIT_LIB}" | cut -d' ' -f4 | cut -d'.' -f1,2)"

if [ ${LIB_VERSION%.*} -ne ${TARGET_LIB_VERSION%.*} ] || [ ${LIB_VERSION#*.} -lt ${TARGET_LIB_VERSION#*.} ]; then
	printf '\n\033[1;31mError:\033[0m\n'
	printf 'Wrong version of play-anything.\n'
	printf 'It must be at least %s ' "${TARGET_LIB_VERSION}"
	printf 'but lower than %s.\n\n' "$((${TARGET_LIB_VERSION%.*}+1)).0"
	exit 1
fi

. "${PLAYIT_LIB}"

# Set extra variables

GAME_ARCHIVE_CHECKSUM_DEFAULT='md5sum'
PKG_COMPRESSION_DEFAULT='none'
PKG_PREFIX_DEFAULT='/usr/local'

fetch_args "$@"

set_checksum
set_compression
set_prefix

check_deps_hard ${SCRIPT_DEPS_HARD}

game_mkdir 'PKG_TMPDIR' "$(mktemp -u ${GAME_ID_SHORT}.XXXXX)" "$((${GAME_ARCHIVE_FULLSIZE}*2))"
game_mkdir 'PKG1_DIR' "${PKG1_ID}_${PKG1_VERSION}-${PKG_REVISION}_${PKG1_ARCH}" "$((${GAME_ARCHIVE_FULLSIZE}*2))"
game_mkdir 'PKG2_DIR' "${PKG2_ID}_${PKG2_VERSION}-${PKG_REVISION}_${PKG2_ARCH}" "$((${GAME_ARCHIVE_FULLSIZE}*2))"

PATH_BIN="${PKG_PREFIX}/games"
PATH_DESK='/usr/local/share/applications'
PATH_GAME="${PKG_PREFIX}/share/games/${GAME_ID}"
PATH_ICON_BASE="/usr/local/share/icons/hicolor"

printf '\n'
set_target '1' 'humblebundle.com'
printf '\n'

# Check target files integrity

if [ "${GAME_ARCHIVE_CHECKSUM}" = 'md5sum' ]; then
	checksum "${GAME_ARCHIVE}" 'defaults' "${GAME_ARCHIVE1_MD5}"
fi

# Extract game data

PATH_ICON="${PATH_ICON_BASE}/${APP1_ICON_RES}/apps"
build_pkg_dirs '1' "${PATH_BIN}" "${PATH_GAME}" "${PATH_DESK}" "${PATH_ICON}"
rm -rf "${PKG2_DIR}"
mkdir -p "${PKG2_DIR}/DEBIAN" "${PKG2_DIR}${PATH_GAME}/Beatbuddy_Data"
print wait

extract_data 'zip' "${GAME_ARCHIVE}" "${PKG_TMPDIR}" 'fix_rights,quiet'

for file in ${INSTALLER_GAME_PKG2}; do
	mv "${PKG_TMPDIR}"/${file} "${PKG2_DIR}${PATH_GAME}/Beatbuddy_Data"
done

for file in ${INSTALLER_GAME_PKG1}; do
	mv "${PKG_TMPDIR}"/${file} "${PKG1_DIR}${PATH_GAME}"
done

chmod 755 "${PKG1_DIR}${PATH_GAME}/${APP1_EXE}"

rm -rf "${PKG_TMPDIR}"
print done

# Write launchers

write_bin_native_prefix_common "${PKG1_DIR}${PATH_BIN}/${APP_COMMON_ID}"
write_bin_native_prefix "${PKG1_DIR}${PATH_BIN}/${APP1_ID}" "${APP1_EXE}" '-logFile ./logs/${GAME_EXE}_$(date +%F-%R).log' '' '' "${APP1_NAME}"

write_desktop "${APP1_ID}" "${APP1_NAME}" "${APP1_NAME_FR}" "${PKG1_DIR}${PATH_DESK}/${APP1_ID}.desktop" "${APP1_CAT}" ''
printf '\n'

# Build package

printf '%s…\n' "$(l10n 'build_pkgs')"
print wait

write_pkg_debian "${PKG1_DIR}" "${PKG1_ID}" "${PKG1_VERSION}-${PKG_REVISION}" "${PKG1_ARCH}" "${PKG1_CONFLICTS}" "${PKG1_DEPS}" "${PKG1_RECS}" "${PKG1_DESC}"
write_pkg_debian "${PKG2_DIR}" "${PKG2_ID}" "${PKG2_VERSION}-${PKG_REVISION}" "${PKG2_ARCH}" "${PKG2_CONFLICTS}" "${PKG2_DEPS}" "${PKG2_RECS}" "${PKG2_DESC}"

file="${PKG1_DIR}/DEBIAN/postinst"
cat > "${file}" << EOF
#!/bin/sh -e
ln -s "${PATH_GAME}/${APP1_ICON}" "${PATH_ICON}/${GAME_ID}.png"
exit 0
EOF
chmod 755 "${file}"

file="${PKG1_DIR}/DEBIAN/prerm"
cat > "${file}" << EOF
#!/bin/sh -e
rm "${PATH_ICON}/${GAME_ID}.png"
exit 0
EOF
chmod 755 "${file}"

build_pkg "${PKG1_DIR}" "${PKG1_DESC}" "${PKG_COMPRESSION}" 'quiet'
build_pkg "${PKG2_DIR}" "${PKG2_DESC}" "${PKG_COMPRESSION}" 'quiet'
print done

print_instructions "${PKG1_DESC}" "${PKG2_DIR}" "${PKG1_DIR}"
printf '\n%s ;)\n\n' "$(l10n 'have_fun')"

exit 0
