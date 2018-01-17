# put files from archive in the right package directories
# USAGE: organize_data $id $path
# NEEDED VARS: (LANG) PLAYIT_WORKDIR (PKG) (PKG_PATH)
organize_data() {
	if [ -z "$PKG" ]; then
		organize_data_error_missing_pkg
	fi
	use_archive_specific_value "ARCHIVE_${1}_PATH"
	use_archive_specific_value "ARCHIVE_${1}_FILES"
	local archive_path="$(eval printf -- '%b' \"\$ARCHIVE_${1}_PATH\")"
	local archive_files="$(eval printf -- '%b' \"\$ARCHIVE_${1}_FILES\")"

	if [ "$archive_path" ] && [ "$archive_files" ] && [ -d "$PLAYIT_WORKDIR/gamedata/$archive_path" ]; then
		local pkg_path="$(eval printf -- '%b' \"\$${PKG}_PATH\")"
		[ -n "$pkg_path" ] || missing_pkg_error 'organize_data' "$PKG"
		pkg_path="${pkg_path}$2"
		mkdir --parents "$pkg_path"
		(
			cd "$PLAYIT_WORKDIR/gamedata/$archive_path"
			for file in $archive_files; do
				if [ -e "$file" ]; then
					cp --recursive --force --link --parents --no-dereference --preserve=links "$file" "$pkg_path"
					rm --recursive "$file"
				fi
			done
		)
	fi
}

# display an error when calling organize_data() with $PKG unset or empty
# USAGE: organize_data_error_missing_pkg
# NEEDED VARS: (LANG)
organize_data_error_missing_pkg() {
	print_error
	case "${LANG%_*}" in
		('fr')
			string='organize_data ne peut pas être appelé si $PKG n’est pas défini.\n'
		;;
		('en'|*)
			string='organize_data can not be called if $PKG is not set.\n'
		;;
	esac
	printf "$string"
	return 1
}

