#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/WhatsApp/erlang-language-platform"
GH_REPO_API="https://api.github.com/repos/WhatsApp/erlang-language-platform/releases"
TOOL_NAME="elp"
TOOL_TEST="elp version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

## Already sorted, just split by new lines
sort_versions() {
	sort | tr ' ' '\n'
}

list_github_releases() {
	curl -s "${GH_REPO_API}" | jq -r '. | map({
		date: .name,
		assets: (.assets
					| map(select(.name | endswith(".tar.gz"))
					| {
						name,
						digest,
						otp: (.name | capture("(?<otp>otp-.*).tar.gz") | .otp )
					})
				)
		}) | map(.date as $date | .assets | map({
			name,
			otp,
			date: $date,
			version: "\(.otp)-\($date)"
		}))
		| flatten
		| group_by(.version)
		| map({
			version: .[0].version,
			date: .[0].date,
			otp: .[0].otp,
			assets: .
		})
		| sort_by(.date)
		'
}

list_all_versions() {
	list_github_releases | jq -r '. | map(.version) | join(" ")'
}

download_release() {
	local version filename url os arch platform otp_ver date_ver
	version="$1"
	filename="$2"

	os="$(detect_os)"
	arch="$(detect_architecture)"
	platform="$(detect_platform)"

	if echo "$version" | grep '^otp-[^-]\+-\d\d\d\d-\d\d-\d\d'; then
		echo "* Installing $TOOL_NAME version $version..."
		otp_ver="$(echo "$version" | cut -d'-' -f1-2)"
		date_ver="$(echo "$version" | cut -d'-' -f3-)"
	elif echo "$version" | grep '^otp-[^.-][^.-]\(\.[^.-]\+\)\?$'; then
		echo "* Detecting latest $TOOL_NAME release for OTP version $version..."
		local selected=""
		selected=$(list_github_releases | jq -r --arg otp "$version" --arg os "$os" --arg arch "$arch" --arg platform "$platform" '
			.
			| map(select(.otp | startswith($otp)))
			| .[-1].assets[]
			| select(.name | startswith("elp-\($os)-\($arch)-\($platform)"))
		')
		date_ver=$(echo "$selected" | jq -r '.date')
		otp_ver=$(echo "$selected" | jq -r '.otp')
	fi

	if [ -z "$date_ver" ] || [ -z "$otp_ver" ]; then
		fail "Could not find release for version: $version"
	fi

	# Adapt the release URL convention for elp
	local archive_name
	archive_name="elp-${os}-${arch}-${platform}-${otp_ver}.tar.gz"
	url="$GH_REPO/releases/download/${date_ver}/${archive_name}"

	echo "* Downloading $TOOL_NAME release $version..."
	echo "* Matching OTP version: $otp_ver, archive: $archive_name"
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert elp executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

detect_os() {
	local os=""

	case "$OSTYPE" in
	darwin*) os="macos" ;;
	linux*) os="linux" ;;
	msys*) os="windows" ;;
	*) fail "Unsupported OS" ;;
	esac

	echo "$os"
}

detect_platform() {
	local platform=""

	case "$OSTYPE" in
	darwin*) platform="apple-darwin" ;;
	linux*) platform="unknown-linux-gnu" ;;
	msys*) platform="pc-windows-msvc" ;;
	*) fail "Unsupported platform" ;;
	esac

	echo "$platform"
}

detect_architecture() {
	local architecture=""

	case "$(uname -m)" in
	x86_64) architecture="x86_64" ;;
	aarch64 | arm64) architecture="aarch64" ;;
	*) fail "Unsupported architecture" ;;
	esac

	echo "$architecture"
}
