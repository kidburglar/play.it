# set package distribution-specific architecture
# USAGE: set_architecture $pkg
# CALLS: liberror set_architecture_arch set_architecture_deb
# NEEDED VARS: (ARCHIVE) (PACKAGE_TYPE) (PKG_ARCH)
# CALLED BY: set_workdir_pkg write_metadata
set_architecture() {
	local architecture
	if [ "$ARCHIVE" ] && [ -n "$(eval echo \$${1}_ARCH_${ARCHIVE#ARCHIVE_})" ]; then
		architecture="$(eval echo \$${1}_ARCH_${ARCHIVE#ARCHIVE_})"
		export ${1}_ARCH="$architecture"
	else
		architecture="$(eval echo \$${1}_ARCH)"
	fi
	case $PACKAGE_TYPE in
		('arch')
			set_architecture_arch "$architecture"
		;;
		('deb')
			set_architecture_deb "$architecture"
		;;
		(*)
			liberror 'PACKAGE_TYPE' 'set_architecture'
		;;
	esac
}

# test the validity of the argument given to parent function
# USAGE: testvar $var_name $pattern
testvar() {
	if [ -z "$(echo "$1" | grep ^${2})" ]; then
		return 1
	fi
}

# set defaults rights on files (755 for dirs & 644 for regular files)
# USAGE: set_standard_permissions $dir[…]
set_standard_permissions() {
	for dir in "$@"; do
		if [ ! -d "$dir" ]; then
			return 1
		fi
		find "$dir" -type d -exec chmod 755 '{}' +
		find "$dir" -type f -exec chmod 644 '{}' +
	done
}

# print a localized error message
# USAGE: print_error
print_error() {
	case ${LANG%_*} in
		('fr')
			printf '\n\033[1;31mErreur :\033[0m\n'
		;;
		('en'|*)
			printf '\n\033[1;31mError:\033[0m\n'
		;;
	esac
}

# convert files name to lower case
# USAGE: tolower $dir[…]
tolower() {
	for dir in "$@"; do
		if [ ! -d "$dir" ]; then
			return 1
		fi
		find "$dir" -depth | while read file; do
			newfile="${file%/*}/$(echo "${file##*/}" | tr [:upper:] [:lower:])"
			if [ ! -e "$newfile" ] && [ "$file" != "$dir" ]; then
				mv "$file" "$newfile"
			fi
		done
	done
}

# display an error if a function has been called with invalid arguments
# USAGE: liberror $var_name $calling_function
liberror() {
	local var="$1"
	local value="$(eval echo \$$var)"
	local func="$2"
	print_error
	case ${LANG%_*} in
		('fr')
			printf 'valeur incorrecte pour %s appelée par %s : %s\n' "$var" "$func" "$value"
		;;
		('en'|*)
			printf 'invalid value for %s called by %s: %s\n' "$var" "$func" "$value"
		;;
	esac
	return 1
}

