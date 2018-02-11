#!/bin/sh
set -e

SRC_PATH="$(dirname "$0")/../src"

if [ -n "$1" ]; then
	compression_method="$1"
else
	case "${LANG%_*}" in
		('fr')
			string='Choisissez la méthode de compression par défaut parmi none, gzip et xz.'
		;;
		('en'|*)
			string='Chose the default compression method from none, gzip or xz.'
		;;
	esac
	printf '%s\n' "$string"
	read compression_method
fi

case "$compression_method" in
	('none'|'gzip'|'xz');;
	(*)
		case "${LANG%_*}" in
			('fr')
				string='Erreur : valeur invalide\n'
			;;
			('en'|*)
				string='Error: unsupported value\n'
			;;
		esac
		printf '%s' "$string"
		exit 1
	;;
esac

pattern="s/\\(DEFAULT_OPTION_COMPRESSION\)='.\\+'/\\1='$compression_method'/"
file="$SRC_PATH/99_init.sh"
sed --in-place "$pattern" "$file"

case "${LANG%_*}" in
	('fr')
		string='Méthode de compression modifiée avec succès pour :'
	;;
	('en'|*)
		string='Successfuly set default compression method to:'
	;;
esac
printf '%s %s\n' "$string" "$compression_method"

exit 0
