#!/usr/bin/env sh
set -o errexit

shellcheck --shell=sh --exclude=SC2016,SC2034,SC2039,SC2046,SC2059,SC2086,SC1112,SC2154,SC2163,SC2162 'play.it-2/lib/libplayit2.sh'

exit 0
