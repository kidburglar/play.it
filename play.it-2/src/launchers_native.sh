# write launcher script - run the native game
# USAGE: write_bin_run_native
# CALLED BY: write_bin_run
write_bin_run_native() {
	cat >> "$file" <<- 'EOF'
	# Copy the game binary into the user prefix

	if [ -e "$PATH_DATA/$APP_EXE" ]; then
	  source_dir="$PATH_DATA"
	else
	  source_dir="$PATH_GAME"
	fi

	(
	  cd "$source_dir"
	  cp --parents --remove-destination "$APP_EXE" "$PATH_PREFIX"
	)

	# Run the game

	cd "$PATH_PREFIX"
	EOF

	if [ "$app_prerun" ]; then
		cat >> "$file" <<- EOF
		$app_prerun
		EOF
	fi

	cat >> "$file" <<- 'EOF'
	"./$APP_EXE" $APP_OPTIONS $@

	EOF
}

