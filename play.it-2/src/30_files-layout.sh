# put files from archive in the right package directories
# USAGE: organize_data $id $path
# NEEDED VARS: (LANG) PLAYIT_WORKDIR (PKG) PKG_PATH
organize_data() {
	if [ -z "$PKG" ]; then
		organize_data_error_missing_pkg
	fi
	local archive_path
	local guessed_path="ARCHIVE_${1}_PATH_${ARCHIVE#ARCHIVE_}"
	while [ "${guessed_path#ARCHIVE_*_PATH}" != "$guessed_path" ]; do
		if [ -n "$(eval printf -- '%b' \"\$${guessed_path}\")" ]; then
			archive_path="$(eval printf -- '%b' \"\$${guessed_path}\")"
			break
		fi
		guessed_path="${guessed_path%_*}"
	done

	local archive_files
	local guessed_files="ARCHIVE_${1}_FILES_${ARCHIVE#ARCHIVE_}"
	while [ "${guessed_files#ARCHIVE_*_FILES}" != "$guessed_files" ]; do
		if [ -n "$(eval printf -- '%b' \"\$${guessed_files}\")" ]; then
			archive_files="$(eval printf -- '%b' \"\$${guessed_files}\")"
			break
		fi
		guessed_files="${guessed_files%_*}"
	done

	if [ "$archive_path" ] && [ "$archive_files" ] && [ -d "$PLAYIT_WORKDIR/gamedata/$archive_path" ]; then
		local pkg_path="$(eval printf -- '%b' \"\$${PKG}_PATH\")${2}"
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

