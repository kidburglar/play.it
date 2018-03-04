# set temporary directories
# USAGE: set_temp_directories $pkg[…]
# NEEDED VARS: (ARCHIVE_SIZE) GAME_ID (LANG) (PWD) (XDG_CACHE_HOME) (XDG_RUNTIME_DIR)
# CALLS: set_temp_directories_error_no_size set_temp_directories_error_not_enough_space set_temp_directories_pkg testvar
set_temp_directories() {

	# If $PLAYIT_WORKDIR is already set, delete it before setting a new one
	[ "$PLAYIT_WORKDIR" ] && rm --force --recursive "$PLAYIT_WORKDIR"

	# If there is only a single package, make it the default one for the current instance
	[ $# = 1 ] && PKG="$1"

	# Generate an unique name for the current instance
	local name
	name="play.it/$(mktemp --dry-run "${GAME_ID}.XXXXX")"

	# Look for a directory with enough free space to work in
	if [ "$ARCHIVE_SIZE" ]; then
		local needed_space
		needed_space=$((ARCHIVE_SIZE * 2))
	else
		set_temp_directories_error_no_size
	fi
	[ "$XDG_RUNTIME_DIR" ] || XDG_RUNTIME_DIR="/run/user/$(id -u)"
	[ "$XDG_CACHE_HOME" ]  || XDG_CACHE_HOME="$HOME/.cache"
	local free_space_run
	free_space_run=$(df --output=avail "$XDG_RUNTIME_DIR" 2>/dev/null | tail --lines=1)
	local free_space_tmp
	free_space_tmp=$(df --output=avail /tmp 2>/dev/null | tail --lines=1)
	local free_space_cache
	free_space_cache=$(df --output=avail "$XDG_CACHE_HOME" 2>/dev/null | tail --lines=1)
	local free_space_pwd
	free_space_pwd=$(df --output=avail "$PWD" 2>/dev/null | tail --lines=1)
	if [ -w "$XDG_RUNTIME_DIR" ] && [ $free_space_run -ge $needed_space ]; then
		PLAYIT_WORKDIR="$XDG_RUNTIME_DIR/$name"
	elif [ -w '/tmp' ] && [ $free_space_tmp -ge $needed_space ]; then
		PLAYIT_WORKDIR="/tmp/$name"
		if [ ! -e "${PLAYIT_WORKDIR%/*}" ]; then
			mkdir --parents "${PLAYIT_WORKDIR%/*}"
			chmod 777 "${PLAYIT_WORKDIR%/*}"
		fi
	elif [ -w "$XDG_CACHE_HOME" ] && [ $free_space_cache -ge $needed_space ]; then
		PLAYIT_WORKDIR="$XDG_CACHE_HOME/$name"
	elif [ -w "$PWD" ] && [ $free_space_pwd -ge $needed_space ]; then
		PLAYIT_WORKDIR="$PWD/$name"
	else
		set_temp_directories_error_not_enough_space
	fi
	export PLAYIT_WORKDIR

	# If $PLAYIT_WORKDIR is an already existing directory, set a new one
	if [ -e "$PLAYIT_WORKDIR" ]; then
		set_temp_directories
		return 0
	fi

	# Set $postinst and $prerm
	mkdir --parents "$PLAYIT_WORKDIR/scripts"
	postinst="$PLAYIT_WORKDIR/scripts/postinst"
	export postinst
	prerm="$PLAYIT_WORKDIR/scripts/prerm"
	export prerm

	# Set temporary directories for each package to build
	for pkg in "$@"; do
		testvar "$pkg" 'PKG'
		set_temp_directories_pkg $pkg
	done
}

# set package-secific temporary directory
# USAGE: set_temp_directories_pkg $pkg
# NEEDED VARS: (ARCHIVE) (OPTION_PACKAGE) PLAYIT_WORKDIR (PKG_ARCH) PKG_ID|GAME_ID
# CALLED BY: set_temp_directories
set_temp_directories_pkg() {
	PKG="$1"

	# Get package ID
	use_archive_specific_value "${PKG}_ID"
	local pkg_id
	pkg_id="$(eval printf -- '%b' \"\$${PKG}_ID\")"
	if [ -z "$pkg_id" ]; then
		eval ${PKG}_ID=\"$GAME_ID\"
		export ${PKG}_ID
		pkg_id="$GAME_ID"
	fi

	# Get package architecture
	local pkg_architecture
	set_architecture "$PKG"

	# Set $PKG_PATH
	if [ "$OPTION_PACKAGE" = 'arch' ] && [ "$(eval printf -- '%b' \"\$${PKG}_ARCH\")" = '32' ]; then
		pkg_id="lib32-$pkg_id"
	fi
	get_package_version
	eval ${PKG}_PATH=\"$PLAYIT_WORKDIR/${pkg_id}_${PKG_VERSION}_${pkg_architecture}\"
	export ${PKG}_PATH
}

# display an error if set_temp_directories() is called before setting $ARCHIVE_SIZE
# USAGE: set_temp_directories_error_no_size
# NEEDED VARS: (LANG)
# CALLS: print_error
# CALLED BY: set_temp_directories
set_temp_directories_error_no_size() {
	print_error
	case "${LANG%_*}" in
		('fr')
			string='$ARCHIVE_SIZE doit être défini avant tout appel à set_temp_directories().\n'
		;;
		('en'|*)
			string='$ARCHIVE_SIZE must be set before any call to set_temp_directories().\n'
		;;
	esac
	printf "$string"
	return 1
}

# display an error if there is not enough free space to work in any of the tested directories
# USAGE: set_temp_directories_error_not_enough_space
# NEEDED VARS: (LANG)
# CALLS: print_error
# CALLED BY: set_temp_directories
set_temp_directories_error_not_enough_space() {
	print_error
	case "${LANG%_*}" in
		('fr')
			string='Il n’y a pas assez d’espace libre dans les différents répertoires testés :\n'
		;;
		('en'|*)
			string='There is not enough free space in the tested directories:\n'
		;;
	esac
	printf "$string"
	for path in "$XDG_RUNTIME_DIR" '/tmp' "$XDG_CACHE_HOME" "$PWD"; do
		printf '%s\n' "$path"
	done
	return 1
}

