#!/bin/sh -e

###
# script de conversion pour le paquet .deb de Sam & Max Hit the Road vendu sur GOG.com
# construit un paquet .deb proposant une meilleure intégration au système à partir de celui fourni par GOG
# testé sur Debian, théoriquement compatible avec ses distributions dérivées
#
# version du script construite le 2015-07-05
#
# envoyez vos rapports de bugs à vv221@dotslashplay.it
# débutez le sujet du mail par "./play.it" pour éviter qu’il ne soit traité comme spam
###

printf "\n"

# Contrôle des dépendances
if [ -z $(which fakeroot) ]; then
	printf "\033[1;31mErreur :\033[0m\n"
	printf "fakeroot est introuvable.\n"
	printf "Installez-le avant de lancer ce script.\n"
	exit 1
fi

# Initialisation des variables (modifiez ces variables pour adapter ce script à un autre jeu)
GAME_ID="sam-and-max-hit-the-road"
GAME_ARCHIVE1="gog_sam_and_max_hit_the_road_french_1.0.0.6.deb"
GAME_ARCHIVE1_MD5="253a6e724c177b0cbc56544d5365a42a"
GAME_ARCHIVE2="gog_sam_and_max_hit_the_road_1.0.0.6.deb"
GAME_ARCHIVE2_MD5="f383ac0db144128a3cc8f8215337e2dd"
PKG_VERSION="1.0"
PKG_REVISION="1.0.0.6"
PKG_FULLVERSION="${PKG_VERSION}-gog${PKG_REVISION}"
PKG_ARCH="all"
PKG1_ID="${GAME_ID}"
PKG1_DEPS="scummvm"
PKG1_DESC="Sam & Max Hit the Road"
SCUMMVM_ID="samnmax"
APP1_ID="${GAME_ID}"
APP1_NAME="Sam & Max Hit the Road"
APP1_CAT="Game"

# Initialisation des variables supplémentaires (ne modifiez pas les déclarations de variables suivantes)
PKG1_NAME="${PKG1_ID}_${PKG_FULLVERSION}_${PKG_ARCH}"
PKG_TMPDIR="${GAME_ID}.tmp-$(date +%s)"

# Définition des fonctions internes au script
build_package () {
local PKG_NAME="$@"
printf "Construction du paquet ${PKG_NAME}.deb…\n"
printf "Cette étape peut durer plusieurs minutes.\n"
fakeroot -- dpkg-deb -Z"${PKG_COMPRESSION}" -b "${PKG_NAME}" 1>/dev/null
rm -rf "${PKG_NAME}"
printf "\033[0;32mFait.\033[0m\n"
}

archive_checksum () {
local GAME_ARCHIVE="$(printf "$*" | cut -d',' -f1)"
local GAME_ARCHIVE1_MD5="$(printf "$*" | cut -d',' -f2)"
local GAME_ARCHIVE2_MD5="$(printf "$*" | cut -d',' -f3)"
printf "Contrôle de l’intégrité de $(basename "${GAME_ARCHIVE}")…\n"
printf "Cette étape peut durer plusieurs minutes.\n"
game_readsum=$(md5sum "${GAME_ARCHIVE}" | cut -d' ' -f1)
if ! [ "${game_readsum}" = "${GAME_ARCHIVE1_MD5}" -o "${game_readsum}" = "${GAME_ARCHIVE2_MD5}" ]; then
	printf "\033[1;31mErreur :\033[0m\n"
	printf "Somme de contrôle incohérente.\n"
	printf "Le fichier ${GAME_ARCHIVE} n’est pas celui attendu, ou il est corrompu.\n"
	exit 1
fi
printf "\033[0;32mFait.\033[0m\n"
}

extract_gamedata () {
local GAME_ARCHIVE="$@"
printf "Extraction des données du jeu depuis $(basename "${GAME_ARCHIVE}")…\n"
printf "Cette étape peut durer plusieurs minutes.\n"
dpkg-deb -x "${GAME_ARCHIVE}" "${PKG_TMPDIR}"
}

write_bin () {
local APP_ID="$(printf "$*" | cut -d',' -f1)"
local APP_NAME="$(printf "$*" | cut -d',' -f2)"
local file_path="${PKG1_NAME}${PATH_BIN}/${APP_ID}"
printf "Écriture du script de lancement pour ${APP_NAME}…\n"
cat > "${file_path}" << EOF
#!/bin/sh -e

# Initialisation des variables (modifiez ces variables pour adapter ce script à un autre jeu)
PATH_GAME="${PATH_GAME}"
SCUMMVM_ID="${SCUMMVM_ID}"

scummvm -p "\${PATH_GAME}" \$@ ${SCUMMVM_ID}
exit 0
EOF
chmod 755 "${file_path}"
}

write_desktop () {
local APP_ID="$(printf "$*" | cut -d',' -f1)"
local APP_NAME="$(printf "$*" | cut -d',' -f2)"
local APP_CAT="$(printf "$*" | cut -d',' -f3)"
local file_path="${PKG1_NAME}${PATH_DESK}/${APP_ID}.desktop"
printf "Écriture de l’entrée de menu pour ${APP_NAME}…\n"
cat > "${file_path}" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_NAME}
Icon=scummvm
Exec=${APP_ID}
Categories=${APP_CAT}
EOF
}

write_pkg_debian () {
local PKG_NAME="$(printf "$*" | cut -d'^' -f1)"
local PKG_ID="$(printf "$*" | cut -d'^' -f2)"
local PKG_FULLVERSION="$(printf "$*" | cut -d'^' -f3)"
local PKG_ARCH="$(printf "$*" | cut -d'^' -f4)"
local PKG_DEPS="$(printf "$*" | cut -d'^' -f5)"
local PKG_DESC="$(printf "$*" | cut -d'^' -f6)"
local PKG_SIZE="$(du -cks $(realpath ${PKG_NAME}/* | grep -v DEBIAN$) | grep total | cut -f1)"
local PKG_MAINT="$(whoami)@$(hostname)"
local file_path="${PKG_NAME}/DEBIAN/control"
cat > "${file_path}" << EOF
Package: ${PKG_ID}
Version: ${PKG_FULLVERSION}
Section: non-free/games
Architecture: ${PKG_ARCH}
Installed-Size: ${PKG_SIZE}
Maintainer: ${PKG_MAINT}
Depends: ${PKG_DEPS}
Description: ${PKG_DESC}
EOF
}

# Définition du préfixe d’installation
if [ -n "${PREFIX}" ]; then
	PKG_PREFIX="${PREFIX}"
else
	PKG_PREFIX="/usr/local"
fi
printf "Préfixe d’installation défini à : ${PKG_PREFIX}\n"
if [ "$(printf "${PKG_PREFIX}" | cut -c1)" != "/" ]; then
	printf "\033[1;31mErreur :\033[0m\n"
	printf "\$PREFIX doit être un chemin absolu.\n"
	printf "La valeur par défaut est : /usr/local\n"
	exit 1
fi
PATH_GAME="${PKG_PREFIX}/share/games/${GAME_ID}"
PATH_DOC="${PKG_PREFIX}/share/doc/${GAME_ID}"
PATH_BIN="${PKG_PREFIX}/games"
PATH_DESK="/usr/local/share/applications"
printf "\n"

# Définition de la méthode de compression
if [ -n "${COMPRESSION}" ]; then
	PKG_COMPRESSION="${COMPRESSION}"
else
	PKG_COMPRESSION="none"
fi
printf "Méthode de compression définie à : ${PKG_COMPRESSION}\n"
if ! [ "${PKG_COMPRESSION}" = "gzip" -o "${PKG_COMPRESSION}" = "xz" -o "${PKG_COMPRESSION}" = "none" ]; then
	printf "\033[1;31mErreur :\033[0m\n"
	printf "${PKG_COMPRESSION} n’est pas une valeur valide pour la variable \$COMPRESSION.\n"
	printf "Les valeurs acceptées sont : none, gzip, xz\n"
	printf "La valeur par défaut est : none\n"
	exit 1
fi
if [ "${PKG_COMPRESSION}" != "none" ]; then
	printf "\033[1;33mAvertissement :\033[0m\n"
	printf "Le paquet .deb final sera compressés par ${PKG_COMPRESSION}\n"
	printf "Les temps de contruction et d’installation du paquet seront (beaucoup) plus longs qu’en l’absence de compression.\n"
fi
printf "\n"

# Définition de la méthode de vérification de l’archive
if [ -n "${CHECKSUM}" ]; then
	GAME_CHECKSUM="${CHECKSUM}"
else
	GAME_CHECKSUM="md5sum"
fi
printf "Méthode de vérification de l’archive définie à : ${GAME_CHECKSUM}\n"
if ! [ "${GAME_CHECKSUM}" = "none" -o "${GAME_CHECKSUM}" = "md5sum" ]; then
	printf "\033[1;31mErreur :\033[0m\n"
	printf "${GAME_CHECKSUM} n’est pas une valeur valide pour la variable \$CHECKSUM.\n"
	printf "Les valeurs acceptées sont : none, md5sum\n"
	printf "La valeur par défaut est : md5sum\n"
	exit 1
fi
if [ "${GAME_CHECKSUM}" = "none" ]; then
	printf "\033[1;33mAvertissement :\033[0m\n"
	printf "L’intégrité du fichier donné en entrée ne sera pas vérifiée.\n"
	printf "Si ce n’est pas le fichier attendu ou qu’il est corrompu, un comportement incohérent du script est possible.\n"
fi
printf "\n"

# Recherche de la cible
if [ -n "$@" ]; then
	GAME_ARCHIVE="$(realpath "$@")"
else
	if [ -f "${PWD}/${GAME_ARCHIVE1}" ]; then
		GAME_ARCHIVE="$(realpath "${PWD}/${GAME_ARCHIVE1}")"
	elif [ -f "${PWD}/${GAME_ARCHIVE2}" ]; then
		GAME_ARCHIVE="$(realpath "${PWD}/${GAME_ARCHIVE2}")"
	elif [ -f "${HOME}/${GAME_ARCHIVE1}" ]; then
		GAME_ARCHIVE="$(realpath "${HOME}/${GAME_ARCHIVE1}")"
	elif [ -f "${HOME}/${GAME_ARCHIVE2}" ]; then
		GAME_ARCHIVE="$(realpath "${HOME}/${GAME_ARCHIVE2}")"
	else
		printf "\033[1;31mErreur :\033[0m\n"
		printf "Ce script prend en argument l’installeur téléchargé depuis gog.com. (${GAME_ARCHIVE1} ou ${GAME_ARCHIVE2})\n"
		exit 1
	fi
fi
printf "Utilisation de ${GAME_ARCHIVE}\n"
if ! [ -f "${GAME_ARCHIVE}" ]; then
	printf "\033[1;31mErreur :\033[0m\n"
	printf "${GAME_ARCHIVE}: fichier introuvable\n"
	exit 1
fi
printf "\n"

# Vérification de l’intégrité de l’archive
if [ "${GAME_CHECKSUM}" = "md5sum" ]; then
	archive_checksum "${GAME_ARCHIVE}","${GAME_ARCHIVE1_MD5}","${GAME_ARCHIVE2_MD5}"
	printf "\n"
fi

# Préparation de l’arborescence du paquet
if [ -e "${PKG1_NAME}" ]; then
	pkg_backup="${PKG1_NAME}.backup-$(date +%s)"
	printf "\033[1;33mAvertissement :\033[0m\n"
	printf "$(realpath "${PKG1_NAME}") existe déjà.\n"
	mv "${PKG1_NAME}" "${pkg_backup}"
	printf "Il a été renommé en ${pkg_backup} pour permettre le bon fonctionnement de ce script.\n\n"
fi
printf "Construction de l’arborescence du paquet…\n"
mkdir -p "${PKG1_NAME}${PATH_GAME}" "${PKG1_NAME}${PATH_DOC}" "${PKG1_NAME}${PATH_BIN}" "${PKG1_NAME}${PATH_DESK}" "${PKG1_NAME}/DEBIAN"
printf "\n"

# Extraction des données de l’archive
mkdir "${PKG_TMPDIR}"
extract_gamedata "${GAME_ARCHIVE}"
rm -r "${PKG_TMPDIR}/opt/GOG Games"/*/docs/scummvm
mv "${PKG_TMPDIR}/opt/GOG Games"/*/docs/* "${PKG1_NAME}${PATH_DOC}"
mv "${PKG_TMPDIR}/opt/GOG Games"/*/data/* "${PKG1_NAME}${PATH_GAME}"
printf "\033[0;32mFait.\033[0m\n"
printf "\n"

# Écriture des scripts de lancement
write_bin ${APP1_ID},${APP1_NAME}
printf "\n"

# Écriture des entrées de menu
write_desktop ${APP1_ID},${APP1_NAME},${APP1_CAT}
printf "\n"

# Écriture des méta-données du paquet
printf "Écriture des méta-données des paquets…\n"
write_pkg_debian ${PKG1_NAME}^${PKG1_ID}^${PKG_FULLVERSION}^${PKG_ARCH}^${PKG1_DEPS}^${PKG1_DESC}
printf "\n"

# Construction du paquet
rm -rf "${PKG_TMPDIR}"
export TMPDIR="${PKG_TMPDIR}"
mkdir "${TMPDIR}"
build_package ${PKG1_NAME}
rm -rf ${TMPDIR}
printf "\n"
printf "Installez ${PKG1_DESC} en lançant la série de commandes suivante (en root) :\n"
printf "dpkg -i ${PWD}/${PKG1_NAME}.deb\n"
printf "apt-get install -f\n"
printf "\n"

exit 0
