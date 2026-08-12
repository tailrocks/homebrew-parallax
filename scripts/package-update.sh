#!/usr/bin/env bash
set -euo pipefail

verified=${VELNOR_VERIFIED_PACKAGE_DIR:?missing VELNOR_VERIFIED_PACKAGE_DIR}
manifest="$verified/release-manifest.json"
identity="$verified/identity.json"

jq -e '
  keys == ["manifest","source_digest","source_ref","source_repository"] and
  .source_repository == "tailrocks/parallax" and
  (.source_ref | test("^refs/tags/v[0-9]+[.][0-9]+[.][0-9]+$")) and
  (.source_digest | test("^[0-9a-f]{40}$"))
' "$identity" >/dev/null

version=$(jq -er '.version | select(test("^[0-9]+[.][0-9]+[.][0-9]+$"))' "$manifest")
tag="v$version"
jq -e --arg tag "refs/tags/$tag" '
  keys == ["assets","schema","source_commit","source_ref","source_repository","version"] and
  .schema == "velnor.package-release.v1" and
  .source_repository == "tailrocks/parallax" and
  .source_ref == $tag and
  (.source_commit | test("^[0-9a-f]{40}$")) and
  ([.assets[].name] | length) == 4 and
  ([.assets[].name] | unique | length) == 4
' "$manifest" >/dev/null

asset() {
  local target=$1
  local name="parallax-${version}-${target}.tar.gz"
  test -f "$verified/$name"
  jq -er --arg name "$name" '
    [.assets[] | select(.name == $name)]
    | select(length == 1)
    | .[0].sha256
    | select(test("^[0-9a-f]{64}$"))
  ' "$manifest"
}

mac_arm=$(asset aarch64-apple-darwin)
mac_intel=$(asset x86_64-apple-darwin)
linux_arm=$(asset aarch64-unknown-linux-gnu)
linux_intel=$(asset x86_64-unknown-linux-gnu)
source_commit=$(jq -er '.source_commit' "$manifest")
test "$(jq -r '.source_digest' "$identity")" = "$source_commit"

cat > Formula/parallax.rb <<EOF
# source-sha: $source_commit
class Parallax < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  version "$version"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/$tag/parallax-$version-aarch64-apple-darwin.tar.gz"
      sha256 "$mac_arm"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/$tag/parallax-$version-x86_64-apple-darwin.tar.gz"
      sha256 "$mac_intel"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/$tag/parallax-$version-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "$linux_arm"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/$tag/parallax-$version-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "$linux_intel"
    end
  end

  conflicts_with "tailrocks/parallax/parallax-preview", because: "stable and preview install the same binary"

  def install
    bin.install "parallax"
  end

  def caveats
    <<~EOS
      Start the local server (downloads a pinned GreptimeDB on first run):
        parallax serve
      Then open http://127.0.0.1:4000 - quickstart:
        https://github.com/tailrocks/parallax/blob/main/docs/guide/quickstart.md
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parallax --version")
  end
end
EOF
