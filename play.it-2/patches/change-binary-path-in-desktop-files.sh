#!/bin/sh
set -e

SRC_PATH="$(dirname $0)/../src"

if [ -n "$1" ]; then
	full_path="$1"
else
	case "${LANG%_*}" in
		('fr')
			string='Les fichiers .desktop doivent-ils inclure le chemin complet vers le binaire ? o/n'
		;;
		('en'|*)
			string='Should .dektop files include the full path to the binary? y/n'
		;;
	esac
	printf '%s\n' "$string"
	read full_path
fi

case "$full_path" in
	('O'|'o'|'Y'|'y')
		binary='$PATH_BIN/$app_id'
	;;
	('N'|'n')
		binary='$app_id'
	;;
	(*)
		case "${LANG%_*}" in
			('fr')
				string='Erreur : valeur invalide'
			;;
			('en'|*)
				string='Error: unsupported value'
			;;
		esac
		printf '%s\n' "$string"
		exit 1
	;;
esac

sed --in-place "s#\(Exec\)=.\+#\1=$binary#" "$SRC_PATH/30_launchers.sh"

case "$full_path" in
	('O'|'o'|'Y'|'y')
		case "${LANG%_*}" in
			('fr')
				string='Les fichiers .desktop incluent le chemin complet vers le binaire.'
			;;
			('en'|*)
				string='.desktop files include the full path to the binary.'
			;;
		esac
	;;
	('N'|'n')
		case "${LANG%_*}" in
			('fr')
				string='Les fichiers .desktop incluent seulement le nom du binaire.'
			;;
			('en'|*)
				string='.desktop files include only the binary name.'
			;;
		esac
	;;
esac
printf '%s\n' "$string"

exit 0
