#!/bin/sh -e

###
# Copyright (c) 2015-2016, Antoine Le Gonidec
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
# conversion script for the Wing Commander 2 installer sold on GOG.com
# build a .deb package from the Windows installer
#
# send your bug reports to vv221@dotslashplay.it
###

script_version=20160412.1

# Set game-specific variables

SCRIPT_DEPS_HARD='fakeroot innoextract realpath'
SCRIPT_DEPS_SOFT='icotool'

GAME_ID='wing-commander-2'
GAME_ID_SHORT='wc2'
GAME_NAME='Wing Commander 2'
GAME_NAME_SHORT='WC2'

GAME_ARCHIVE1='setup_wing_commander2_2.1.0.18.exe'
GAME_ARCHIVE1_MD5='f94a7eb75e4ed454108d13189d003e9f'
GAME_ARCHIVE_FULLSIZE='49000'
PKG_REVISION='gog2.1.0.18'

INSTALLER_DOC='app/*.pdf tmp/gog_eula.txt tmp/eula.txt'
INSTALLER_GAME='app/*.exe app/*.ico app/*.cfg app/gamedat'
INSTALLER_GAME_EXTRA='app/__support/save/gamedat/*'

GAME_IMAGE=''

GAME_CACHE_DIRS=''
GAME_CACHE_FILES=''
GAME_CACHE_FILES_POST=''
GAME_CONFIG_DIRS=''
GAME_CONFIG_FILES='./*.cfg'
GAME_CONFIG_FILES_POST=''
GAME_DATA_DIRS='./gamedat'
GAME_DATA_FILES=''
GAME_DATA_FILES_POST=''

APP_COMMON_ID="${GAME_ID_SHORT}-common.sh"

MENU_NAME="${GAME_NAME}"
MENU_NAME_FR="${GAME_NAME}"
MENU_CAT='Games'

APP1_ID="${GAME_ID}"
APP1_EXE='./wc2.exe'
APP1_ICON='./goggame-1207662653.ico'
APP1_ICON_RES='16x16 32x32 48x48 256x256'
APP1_NAME="${GAME_NAME_SHORT} - Vengeance of the Kilrathi"
APP1_NAME_FR="${GAME_NAME_SHORT} - Vengeance of the Kilrathi"

APP2_ID="${GAME_ID}_so1"
APP2_EXE='./so1.exe'
APP2_NAME="${GAME_NAME_SHORT} - Special Operations 1"
APP2_NAME_FR="${GAME_NAME_SHORT} - Special Operations 1"

APP3_ID="${GAME_ID}_so2"
APP3_EXE='./so2.exe'
APP3_NAME="${GAME_NAME_SHORT} - Special Operations 2"
APP3_NAME_FR="${GAME_NAME_SHORT} - Special Operations 2"

PKG1_ID="${GAME_ID}"
PKG1_ARCH='all'
PKG1_VERSION='1.0'
PKG1_CONFLICTS=''
PKG1_DEPS='dosbox'
PKG1_RECS=''
PKG1_DESC="${GAME_NAME}
 package built from GOG.com Windows installer
 ./play.it script version ${script_version}"

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

NO_ICON=0

PKG_PREFIX_DEFAULT='/usr/local'
PKG_COMPRESSION_DEFAULT='none'
GAME_ARCHIVE_CHECKSUM_DEFAULT='md5sum'

fetch_args "$@"

set_checksum
set_compression
set_prefix

check_deps_hard ${SCRIPT_DEPS_HARD}
check_deps_soft ${SCRIPT_DEPS_SOFT}

game_mkdir 'PKG_TMPDIR' "$(mktemp -u ${GAME_ID_SHORT}.XXXXX)" "$((${GAME_ARCHIVE_FULLSIZE}*2))"
game_mkdir 'PKG1_DIR' "${PKG1_ID}_${PKG1_VERSION}-${PKG_REVISION}_${PKG1_ARCH}" "$((${GAME_ARCHIVE_FULLSIZE}*2))"

PATH_BIN="${PKG_PREFIX}/games"
PATH_DESK='/usr/local/share/applications'
PATH_DESK_DIR='/usr/local/share/desktop-directories'
PATH_DESK_MERGED='/etc/xdg/menus/applications-merged'
PATH_DOC="${PKG_PREFIX}/share/doc/${GAME_ID}"
PATH_GAME="${PKG_PREFIX}/share/games/${GAME_ID}"
PATH_ICON_BASE='/usr/local/share/icons/hicolor'

printf '\n'
set_target '1' 'gog.com'
printf '\n'

# Check target files integrity

if [ "${GAME_ARCHIVE_CHECKSUM}" = 'md5sum' ]; then
	checksum "${GAME_ARCHIVE}" 'defaults' "${GAME_ARCHIVE1_MD5}"
fi

# Extract game data

build_pkg_dirs '1' "${PATH_BIN}" "${PATH_DOC}" "${PATH_DESK}" "${PATH_DESK_DIR}" "${PATH_DESK_MERGED}" "${PATH_GAME}"
print wait

extract_data 'inno' "${GAME_ARCHIVE}" "${PKG_TMPDIR}" 'quiet'

for file in ${INSTALLER_DOC}; do
	mv "${PKG_TMPDIR}"/${file} "${PKG1_DIR}${PATH_DOC}"
done

for file in ${INSTALLER_GAME}; do
	mv "${PKG_TMPDIR}"/${file} "${PKG1_DIR}${PATH_GAME}"
done

if [ "${NO_ICON}" = '0' ]; then
	extract_icons "${APP1_ID}" "${APP1_ICON}" "${APP1_ICON_RES}" "${PKG_TMPDIR}"
fi
rm "${PKG1_DIR}${PATH_GAME}/${APP1_ICON}"

rm -rf "${PKG_TMPDIR}"
print done

# Write launchers

write_bin_dosbox_common "${PKG1_DIR}${PATH_BIN}/${APP_COMMON_ID}"
write_bin_dosbox "${PKG1_DIR}${PATH_BIN}/${APP1_ID}" "${APP1_EXE}" '' '' "${APP1_NAME}"
write_bin_dosbox "${PKG1_DIR}${PATH_BIN}/${APP2_ID}" "${APP2_EXE}" '' '' "${APP2_NAME}"
write_bin_dosbox "${PKG1_DIR}${PATH_BIN}/${APP3_ID}" "${APP3_EXE}" '' '' "${APP3_NAME}"

sed -i 's/imgmount.\+//' "${PKG1_DIR}${PATH_BIN}/${APP1_ID}"
sed -i 's/imgmount.\+//' "${PKG1_DIR}${PATH_BIN}/${APP2_ID}"
sed -i 's/imgmount.\+//' "${PKG1_DIR}${PATH_BIN}/${APP3_ID}"

write_menu "${GAME_ID}" "${MENU_NAME}" "${MENU_NAME_FR}" "${MENU_CAT}" "${PKG1_DIR}${PATH_DESK_DIR}/${GAME_ID}.directory" "${PKG1_DIR}${PATH_DESK_MERGED}/${GAME_ID}.menu" 'dosbox' "${APP1_ID}" "${APP2_ID}" "${APP3_ID}"
write_desktop "${APP1_ID}" "${APP1_NAME}" "${APP1_NAME_FR}" "${PKG1_DIR}${PATH_DESK}/${APP1_ID}.desktop" '' 'dosbox'
write_desktop "${APP2_ID}" "${APP2_NAME}" "${APP2_NAME_FR}" "${PKG1_DIR}${PATH_DESK}/${APP2_ID}.desktop" '' 'dosbox'
write_desktop "${APP3_ID}" "${APP3_NAME}" "${APP3_NAME_FR}" "${PKG1_DIR}${PATH_DESK}/${APP3_ID}.desktop" '' 'dosbox'
printf '\n'

# Build package

write_pkg_debian "${PKG1_DIR}" "${PKG1_ID}" "${PKG1_VERSION}-${PKG_REVISION}" "${PKG1_ARCH}" "${PKG1_CONFLICTS}" "${PKG1_DEPS}" "${PKG1_RECS}" "${PKG1_DESC}"

if [ "${NO_ICON}" = '0' ]; then
	file="${PKG1_DIR}/DEBIAN/postinst"
	cat > "${file}" <<- EOF
	#!/bin/sh -e
	for res in ${APP1_ICON_RES}; do
	  path_icon="${PATH_ICON_BASE}/\${res}/apps"
	  ln -s "./${APP1_ID}.png" "\${path_icon}/${APP2_ID}.png"
	  ln -s "./${APP1_ID}.png" "\${path_icon}/${APP3_ID}.png"
	done
	exit 0
	EOF
	sed -i 's/  /\t/' "${file}"
	chmod 755 "${file}"

	file="${PKG1_DIR}/DEBIAN/prerm"
	cat > "${file}" <<- EOF
	#!/bin/sh -e
	for res in ${APP1_ICON_RES}; do
	  path_icon="${PATH_ICON_BASE}/\${res}/apps"
	  rm -f "\${path_icon}/${APP2_ID}.png"
	  rm -f "\${path_icon}/${APP3_ID}.png"
	done
	exit 0
	EOF
	sed -i 's/  /\t/' "${file}"
	chmod 755 "${file}"
fi

build_pkg "${PKG1_DIR}" "${PKG1_DESC}" "${PKG_COMPRESSION}"

print_instructions "${PKG1_DESC}" "${PKG1_DIR}"

printf '\n%s ;)\n\n' "$(l10n 'have_fun')"

exit 0
