# extract .png or .ico files from given file
# USAGE: extract_icon_from $file[…]
# NEEDED VARS: PLAYIT_WORKDIR (WRESTOOL_NAME)
# CALLS: liberror
extract_icon_from() {
	[ "$DRY_RUN" = '1' ] && return 0
	for file in "$@"; do
		local destination
		destination="$PLAYIT_WORKDIR/icons"
		mkdir --parents "$destination"
		case "${file##*.}" in
			('exe')
				if [ "$WRESTOOL_NAME" ]; then
					local wrestool_options
					wrestool_options="--name=$WRESTOOL_NAME"
				fi
				wrestool --extract --type=14 $wrestool_options --output="$destination" "$file"
				unset wrestool_options
			;;
			('ico')
				icotool --extract --output="$destination" "$file" 2>/dev/null
			;;
			('bmp')
				local filename
				filename="${file##*/}"
				convert "$file" "$destination/${filename%.bmp}.png"
			;;
			(*)
				liberror '{file##*.}' 'extract_icon_from'
			;;
		esac
	done
}

# create icons layout
# USAGE: sort_icons $app[…]
# NEEDED VARS: APP_ICON_RES (APP_ID) GAME_ID PKG (PKG_PATH)
sort_icons() {
	local app
	local app_id
	local icon_res
	local path_icon
	local pkg_path
	for app in "$@"; do
		testvar "$app" 'APP' || liberror 'app' 'sort_icons'

		if [ -n "$(eval printf -- '%b' \"\$${app}_ID\")" ]; then
			app_id="$(eval printf -- '%b' \"\$${app}_ID\")"
		else
			app_id="$GAME_ID"
		fi

		icon_res="$(eval printf -- '%b' \"\$${app}_ICON_RES\")"
		pkg_path="$(eval printf -- '%b' \"\$${PKG}_PATH\")"
		[ -n "$pkg_path" ] || missing_pkg_error 'sort_icons' "$PKG"
		[ "$DRY_RUN" = '1' ] && continue
		if [ -n "${icon_res##* *}" ]; then
			path_icon="$PATH_ICON_BASE/${icon_res}x${icon_res}/apps"
			mkdir --parents "${pkg_path}${path_icon}"
			mv "$file" "${pkg_path}${path_icon}/${app_id}.png"
		else
			for res in $icon_res; do
				path_icon="$PATH_ICON_BASE/${res}x${res}/apps"
				mkdir --parents "${pkg_path}${path_icon}"
				for file in "$PLAYIT_WORKDIR"/icons/*${res}x${res}x*.png; do
					mv "$file" "${pkg_path}${path_icon}/${app_id}.png"
				done
			done
		fi
	done
}

# extract and sort icons from given .ico or .exe file
# USAGE: extract_and_sort_icons_from $app[…]
# NEEDED VARS: APP_ICON APP_ICON_RES (APP_ID) GAME_ID PKG (PKG_PATH) PLAYIT_WORKDIR
# CALLS: extract_icon_from liberror sort_icons
extract_and_sort_icons_from() {
	local app_icon
	local pkg_path
	pkg_path="$(eval printf -- '%b' \"\$${PKG}_PATH\")"
	[ -n "$pkg_path" ] || missing_pkg_error 'extract_and_sort_icons_from' "$PKG"
	[ "$DRY_RUN" = '1' ] && return 0
	for app in "$@"; do
		testvar "$app" 'APP' || liberror 'app' 'sort_icons'
		use_archive_specific_value "${app}_ICON"
		local app_icon
		app_icon="$(eval printf -- '%b' \"\$${app}_ICON\")"

		if [ ! "$WRESTOOL_NAME" ] && [ -n "$(eval printf -- '%b' \"\$${app}_ICON_ID\")" ]; then
			WRESTOOL_NAME="$(eval printf -- '%b' \"\$${app}_ICON_ID\")"
		fi

		extract_icon_from "${pkg_path}${PATH_GAME}/$app_icon"
		unset WRESTOOL_NAME

		if [ "${app_icon##*.}" = 'exe' ]; then
			extract_icon_from "$PLAYIT_WORKDIR/icons"/*.ico
		fi

		sort_icons "$app"
		rm --recursive "$PLAYIT_WORKDIR/icons"
	done
}

# move icons to the target package
# USAGE: move_icons_to $pkg
# NEEDED VARS: PATH_ICON_BASE PKG (PKG_PATH)
move_icons_to() {
	local source_path
	source_path="$(eval printf -- '%b' \"\$${PKG}_PATH\")"
	[ -n "$source_path" ] || missing_pkg_error 'move_icons_to' "$PKG"
	local destination_path
	destination_path="$(eval printf -- '%b' \"\$${1}_PATH\")"
	[ -n "$destination_path" ] || missing_pkg_error 'move_icons_to' "$1"
	[ "$DRY_RUN" = '1' ] && return 0
	(
		cd "$source_path"
		cp --link --parents --recursive --no-dereference --preserve=links "./$PATH_ICON_BASE" "$destination_path"
		rm --recursive "./$PATH_ICON_BASE"
		rmdir --ignore-fail-on-non-empty --parents "./${PATH_ICON_BASE%/*}"
	)
}

# write post-installation and pre-removal scripts for icons linking
# USAGE: postinst_icons_linking $app[…]
# NEEDED VARS: APP_ICONS_LIST APP_ID|GAME_ID APP_ICON APP_ICON_RES PATH_GAME
postinst_icons_linking() {
	[ "$DRY_RUN" = '1' ] && return 0
	local app
	local app_icons_list
	local app_id
	local icon_file
	local icon_res
	for app in "$@"; do
		app_icons_list="$(eval printf -- '%b' \"\$${app}_ICONS_LIST\")"
		app_id="$(eval printf -- '%b' \"\$${app}_ID\")"
		[ -n "$app_id" ] || app_id="$GAME_ID"
		for icon in $app_icons_list; do
			icon_file="$(eval printf -- '%b' \"\$$icon\")"
			icon_res="$(eval printf -- '%b' \"\$${icon}_RES\")"
			PATH_ICON="$PATH_ICON_BASE/${icon_res}x${icon_res}/apps"

			cat >> "$postinst" <<- EOF
			if [ ! -e "$PATH_ICON/$app_id.png" ]; then
			  mkdir --parents "$PATH_ICON"
			  ln --symbolic "$PATH_GAME"/$icon_file "$PATH_ICON/$app_id.png"
			fi
			EOF

			cat >> "$prerm" <<- EOF
			if [ -e "$PATH_ICON/$app_id.png" ]; then
			  rm "$PATH_ICON/$app_id.png"
			  rmdir --parents --ignore-fail-on-non-empty "$PATH_ICON"
			fi
			EOF
		done
	done
}

# get .png icon from temporary work directory
# USAGE: get_icon_from_temp_dir $app[…]
# NEEDED VARS: PKG (PKG_PATH) PATH_ICON_BASE APP_ID|GAME_ID PLAYIT_WORKDIR
# CALLS: liberror
get_icon_from_temp_dir() {
	local app_icon
	local app_icon_name
	local app_icon_res
	local app_id
	local icon_path
	local pkg_path
	pkg_path="$(eval printf -- '%b' \"\$${PKG}_PATH\")"
	[ -n "$pkg_path" ] || missing_pkg_error 'get_icon_from_temp_dir' "$PKG"
	[ "$DRY_RUN" = '1' ] && return 0
	for app in "$@"; do
		testvar "$app" 'APP' || liberror 'app' 'get_icon_from_temp_dir'
		unset app_icon_name
		if [ "$ARCHIVE" ]; then
			app_icon_name="${app}_ICON_${ARCHIVE#ARCHIVE_}"
			while [ "${app_icon_name#${app}_ICON}" != "$app_icon_name" ]; do
				[ "$(eval printf -- '%b' \"\$$app_icon_name\")" ] && break
				app_icon_name="${app_icon_name%_*}"
			done
		fi
		[ "$app_icon_name" ] || app_icon_name="${app}_ICON"
		app_icon="$(eval printf -- '%b' \"\$$app_icon_name\")"
		app_icon_res="$(eval printf -- '%b' \"\$${app_icon_name}_RES\")"
		if [ "$app_icon" ]; then
			app_id="$(eval printf -- '%b' \"\$${app}_ID\")"
			[ "$app_id" ] || app_id="$GAME_ID"
			icon_path="$PATH_ICON_BASE/${app_icon_res}x${app_icon_res}/apps"
			mkdir --parents "${pkg_path}${icon_path}"
			mv "$PLAYIT_WORKDIR/gamedata/$app_icon" "${pkg_path}${icon_path}/$app_id.png"
		fi
	done
}

