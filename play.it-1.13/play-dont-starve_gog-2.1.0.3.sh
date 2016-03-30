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
# conversion script for the Don’t Starve installer sold on GOG.com
# build a .deb package from the .sh MojoSetup installer
# tested on Debian, should work on any .deb-based distribution
#
# send your bug reports to vv221@dotslashplay.it
# start the e-mail subject by "./play.it" to avoid it being flagged as spam
###

script_version=20160224.1

# Set game-specific variables

SCRIPT_DEPS_HARD='fakeroot realpath unzip'

GAME_ID='dont-starve'
GAME_ID_SHORT='dontstarve'
GAME_NAME='Don’t Starve'

GAME_ARCHIVE1='gog_don_t_starve_2.1.0.3.sh'
GAME_ARCHIVE1_MD5='8111ab2909ed2553beebbf9b87ce9059'
GAME_ARCHIVE_FULLSIZE='640000'
PKG_REVISION='gog2.1.0.3'

INSTALLER_DOC='data/noarch/docs/*'
INSTALLER_GAME_ARCH1='data/noarch/game/dontstarve32/*'
INSTALLER_GAME_ARCH2='data/noarch/game/dontstarve64/*'

GAME_CACHE_DIRS=''
GAME_CACHE_FILES=''
GAME_CACHE_FILES_POST=''
GAME_CONFIG_DIRS=''
GAME_CONFIG_FILES=''
GAME_CONFIG_FILES_POST=''
GAME_DATA_DIRS='./mods'
GAME_DATA_FILES='./bin/dontstarve'
GAME_DATA_FILES_POST=''

APP_COMMON_ID="${GAME_ID_SHORT}-common.sh"

APP1_ID="${GAME_ID}"
APP1_EXE_ARCH1='./bin/dontstarve'
APP1_EXE_ARCH2='./bin/dontstarve'
APP1_ICON='./dontstarve.xpm'
APP1_ICON_RES='256x256'
APP1_NAME="${GAME_NAME}"
APP1_NAME_FR="${GAME_NAME}"
APP1_CAT='Game'

PKG_ID="${GAME_ID}"
PKG_VERSION='2015.04.28'
PKG_DEPS='libglu1-mesa | libglu1, libxrandr2, libcurl3-gnutls'
PKG_RECS=''
PKG_DESC="${GAME_NAME}
 package built from GOG.com installer
 ./play.it script version ${script_version}"

PKG1_ID="${PKG_ID}"
PKG1_ARCH='i386'
PKG1_VERSION="${PKG_VERSION}"
PKG1_DEPS="${PKG_DEPS}"
PKG1_RECS="${PKG_RECS}"
PKG1_DESC="${PKG_DESC}"

PKG2_ID="${PKG_ID}"
PKG2_ARCH='amd64'
PKG2_VERSION="${PKG_VERSION}"
PKG2_DEPS="${PKG_DEPS}"
PKG2_RECS="${PKG_RECS}"
PKG2_DESC="${PKG_DESC}"

PKG1_CONFLICTS="${PKG2_ID}:${PKG2_ARCH}"
PKG2_CONFLICTS="${PKG1_ID}:${PKG1_ARCH}"

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
PATH_DOC="${PKG_PREFIX}/share/doc/${GAME_ID}"
PATH_GAME="${PKG_PREFIX}/share/games/${GAME_ID}"
PATH_ICON="/usr/local/share/icons/hicolor/${APP1_ICON_RES}/apps"

printf '\n'

set_target '1' 'gog.com'

printf '\n'

# Check target files integrity

if [ "${GAME_ARCHIVE_CHECKSUM}" = 'md5sum' ]; then
	checksum "${GAME_ARCHIVE}" 'defaults' "${GAME_ARCHIVE1_MD5}"
fi

# Extract game data

build_pkg_dirs '2' "${PATH_BIN}" "${PATH_DESK}" "${PATH_DOC}" "${PATH_GAME}" "${PATH_ICON}"

extract_data 'mojo' "${GAME_ARCHIVE}" "${PKG_TMPDIR}" 'fix_rights,quiet'

for file in ${INSTALLER_DOC}; do
	cp -rl "${PKG_TMPDIR}"/${file} "${PKG1_DIR}${PATH_DOC}"
	cp -rl "${PKG_TMPDIR}"/${file} "${PKG2_DIR}${PATH_DOC}"
done

for file in ${INSTALLER_GAME_ARCH1}; do
	mv "${PKG_TMPDIR}"/${file} "${PKG1_DIR}${PATH_GAME}"
done

for file in ${INSTALLER_GAME_ARCH2}; do
	mv "${PKG_TMPDIR}"/${file} "${PKG2_DIR}${PATH_GAME}"
done

chmod 755 "${PKG1_DIR}${PATH_GAME}/${APP1_EXE_ARCH1}"
chmod 755 "${PKG2_DIR}${PATH_GAME}/${APP1_EXE_ARCH2}"

rm -rf "${PKG_TMPDIR}"

print done

# Write launchers

write_bin_native_prefix_common "${PKG1_DIR}${PATH_BIN}/${APP_COMMON_ID}"
write_bin_native_prefix "${PKG1_DIR}${PATH_BIN}/${APP1_ID}" "${APP1_EXE_ARCH1}" '' './lib32' '' "${APP1_NAME} (${PKG1_ARCH})"
write_bin_native_prefix_common "${PKG2_DIR}${PATH_BIN}/${APP_COMMON_ID}"
write_bin_native_prefix "${PKG2_DIR}${PATH_BIN}/${APP1_ID}" "${APP1_EXE_ARCH2}" '' './lib64' '' "${APP1_NAME} (${PKG2_ARCH})"

sed -i 's|cd "${USERDIR_DATA}"|GAME_EXE_PATH="${USERDIR_DATA}/${GAME_EXE}"\ncd "${GAME_EXE_PATH%/*}"|' "${PKG1_DIR}${PATH_BIN}/${APP1_ID}" "${PKG2_DIR}${PATH_BIN}/${APP1_ID}"
sed -i 's|"${GAME_EXE}" ${GAME_EXE_OPTIONS} $@|./"${GAME_EXE_PATH##\*/}" ${GAME_EXE_OPTIONS} $@|' "${PKG1_DIR}${PATH_BIN}/${APP1_ID}" "${PKG2_DIR}${PATH_BIN}/${APP1_ID}"

write_desktop "${APP1_ID}" "${APP1_NAME}" "${APP1_NAME_FR}" "${PKG1_DIR}${PATH_DESK}/${APP1_ID}.desktop" "${APP1_CAT}" ''
cp -l "${PKG1_DIR}${PATH_DESK}/${APP1_ID}.desktop" "${PKG2_DIR}${PATH_DESK}/${APP1_ID}.desktop"

printf '\n'

# Build packages

printf '%s…\n' "$(l10n 'build_pkgs')"

print wait

for pkg in "${PKG1_DIR}" "${PKG2_DIR}"; do

	file="${pkg}/DEBIAN/postinst"

	cat > "${file}" <<- EOF
	#!/bin/sh -e
	ln -s "${PATH_GAME}/${APP1_ICON}" "${PATH_ICON}/${GAME_ID}.png"
	exit 0
	EOF

	chmod 755 "${file}"

	file="${pkg}/DEBIAN/prerm"

	cat > "${file}" <<- EOF
	#!/bin/sh -e
	rm "${PATH_ICON}/${GAME_ID}.png"
	exit 0
	EOF

	chmod 755 "${file}"
done

write_pkg_debian "${PKG1_DIR}" "${PKG1_ID}" "${PKG1_VERSION}-${PKG_REVISION}" "${PKG1_ARCH}" "${PKG1_CONFLICTS}" "${PKG1_DEPS}" "${PKG1_RECS}" "${PKG1_DESC}" 'arch'
write_pkg_debian "${PKG2_DIR}" "${PKG2_ID}" "${PKG2_VERSION}-${PKG_REVISION}" "${PKG2_ARCH}" "${PKG2_CONFLICTS}" "${PKG2_DEPS}" "${PKG2_RECS}" "${PKG2_DESC}" 'arch'

build_pkg "${PKG1_DIR}" "${PKG1_DESC}" "${PKG_COMPRESSION}" 'quiet' "${PKG1_ARCH}"
build_pkg "${PKG2_DIR}" "${PKG2_DESC}" "${PKG_COMPRESSION}" 'quiet' "${PKG2_ARCH}"

print done

print_instructions "$(printf '%s' "${PKG1_DESC}" | head -n1) (${PKG1_ARCH})" "${PKG1_DIR}"
printf '\n'
print_instructions "$(printf '%s' "${PKG2_DESC}" | head -n1) (${PKG2_ARCH})" "${PKG2_DIR}"

printf '\n%s ;)\n\n' "$(l10n 'have_fun')"

exit 0
