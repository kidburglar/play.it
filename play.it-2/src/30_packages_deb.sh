# write .deb package meta-data
# USAGE: pkg_write_deb
# NEEDED VARS: GAME_NAME PKG_DEPS_DEB
# CALLED BY: write_metadata
pkg_write_deb() {
	local pkg_deps
	if [ "$(eval printf -- '%b' \"\$${pkg}_DEPS\")" ]; then
		pkg_set_deps_deb $(eval printf -- '%b' \"\$${pkg}_DEPS\")
	fi
	if [ "$(eval printf -- '%b' \"\$${pkg}_DEPS_DEB_${ARCHIVE#ARCHIVE_}\")" ]; then
		if [ -n "$pkg_deps" ]; then
			pkg_deps="$pkg_deps, $(eval printf -- '%b' \"\$${pkg}_DEPS_DEB_${ARCHIVE#ARCHIVE_}\")"
		else
			pkg_deps="$(eval printf -- '%b' \"\$${pkg}_DEPS_DEB_${ARCHIVE#ARCHIVE_}\")"
		fi
	elif [ "$(eval printf -- '%b' \"\$${pkg}_DEPS_DEB\")" ]; then
		if [ -n "$pkg_deps" ]; then
			pkg_deps="$pkg_deps, $(eval printf -- '%b' \"\$${pkg}_DEPS_DEB\")"
		else
			pkg_deps="$(eval printf -- '%b' \"\$${pkg}_DEPS_DEB\")"
		fi
	fi
	local pkg_size=$(du --total --block-size=1K --summarize "$pkg_path" | tail --lines=1 | cut --fields=1)
	local target="$pkg_path/DEBIAN/control"

	mkdir --parents "${target%/*}"

	cat > "$target" <<- EOF
	Package: $pkg_id
	Version: $pkg_version
	Architecture: $pkg_architecture
	Maintainer: $pkg_maint
	Installed-Size: $pkg_size
	Section: non-free/games
	EOF

	if [ "$pkg_provide" ]; then
		cat >> "$target" <<- EOF
		Conflicts: $pkg_provide
		Provides: $pkg_provide
		Replaces: $pkg_provide
		EOF
	fi

	if [ "$pkg_deps" ]; then
		cat >> "$target" <<- EOF
		Depends: $pkg_deps
		EOF
	fi

	if [ "$pkg_description" ]; then
		cat >> "$target" <<- EOF
		Description: $GAME_NAME - $pkg_description
		 ./play.it script version $script_version
		EOF
	else
		cat >> "$target" <<- EOF
		Description: $GAME_NAME
		 ./play.it script version $script_version
		EOF
	fi

	if [ "$pkg_architecture" = 'all' ]; then
		sed -i 's/Architecture: all/&\nMulti-Arch: foreign/' "$target"
	fi

	if [ -e "$postinst" ]; then
		target="$pkg_path/DEBIAN/postinst"
		cat > "$target" <<- EOF
		#!/bin/sh -e

		$(cat "$postinst")

		exit 0
		EOF
		chmod 755 "$target"
	fi

	if [ -e "$prerm" ]; then
		target="$pkg_path/DEBIAN/prerm"
		cat > "$target" <<- EOF
		#!/bin/sh -e

		$(cat "$prerm")

		exit 0
		EOF
		chmod 755 "$target"
	fi
}

# set list of Debian dependencies from generic names
# USAGE: pkg_set_deps_deb $dep[…]
# CALLED BY: pkg_write_deb
pkg_set_deps_deb() {
	for dep in $@; do
		case $dep in
			('alsa')
				pkg_dep='libasound2-plugins'
			;;
			('bzip2')
				pkg_dep='libbz2-1.0'
			;;
			('dosbox')
				pkg_dep='dosbox'
			;;
			('freetype')
				pkg_dep='libfreetype6'
			;;
			('gcc32')
				pkg_dep='gcc-multilib:amd64 | gcc'
			;;
			('gconf')
				pkg_dep='libgconf-2-4'
			;;
			('glibc')
				pkg_dep='libc6'
			;;
			('glu')
				pkg_dep='libglu1-mesa | libglu1'
			;;
			('glx')
				pkg_dep='libgl1-mesa-glx | libgl1'
			;;
			('gtk2')
				pkg_dep='libgtk2.0-0'
			;;
			('json')
				pkg_dep='libjson-c3 | libjson-c2 | libjson0'
			;;
			('libcurl-gnutls')
				pkg_dep='libcurl3-gnutls'
			;;
			('libstdc++')
				pkg_dep='libstdc++6'
			;;
			('libxrandr')
				pkg_dep='libxrandr2'
			;;
			('nss')
				pkg_dep='libnss3'
			;;
			('openal')
				pkg_dep='libopenal1'
			;;
			('pulseaudio')
				pkg_dep='pulseaudio:amd64 | pulseaudio'
			;;
			('sdl1.2')
				pkg_dep='libsdl1.2debian'
			;;
			('sdl2')
				pkg_dep='libsdl2-2.0-0'
			;;
			('sdl2_image')
				pkg_dep='libsdl2-image-2.0-0'
			;;
			('sdl2_mixer')
				pkg_dep='libsdl2-mixer-2.0-0'
			;;
			('vorbis')
				pkg_dep='libvorbisfile3'
			;;
			('wine')
				pkg_dep='wine32-development | wine32 | wine-bin | wine-i386 | wine-staging-i386, wine:amd64 | wine'
			;;
			('winetricks')
				pkg_dep='winetricks'
			;;
			('xcursor')
				pkg_dep='libxcursor1'
			;;
			('xft')
				pkg_dep='libxft2'
			;;
			(*)
				pkg_dep="$dep"
			;;
		esac
		if [ -n "$pkg_deps" ]; then
			pkg_deps="$pkg_deps, $pkg_dep"
		else
			pkg_deps="$pkg_dep"
		fi
	done
}

# build .deb package
# USAGE: pkg_build_deb $pkg_path
# NEEDED VARS: (OPTION_COMPRESSION) (LANG) PLAYIT_WORKDIR
# CALLS: pkg_print
# CALLED BY: build_pkg
pkg_build_deb() {
	local pkg_filename="$PWD/${1##*/}.deb"
	if [ -e "$pkg_filename" ]; then
		pkg_build_print_already_exists "${pkg_filename##*/}"
		export ${pkg}_PKG="$pkg_filename"
		return 0
	fi

	local dpkg_options
	case $OPTION_COMPRESSION in
		('gzip'|'none'|'xz')
			dpkg_options="-Z$OPTION_COMPRESSION"
		;;
		(*)
			liberror 'OPTION_COMPRESSION' 'pkg_build_deb'
		;;
	esac

	pkg_print "${pkg_filename##*/}"
	TMPDIR="$PLAYIT_WORKDIR" fakeroot -- dpkg-deb $dpkg_options --build "$1" "$pkg_filename" 1>/dev/null
	export ${pkg}_PKG="$pkg_filename"

	print_ok
}
