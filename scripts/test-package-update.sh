#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cp -R "$root/." "$tmp/repo"
verified="$tmp/verified"
mkdir "$verified"

version=1.2.3
commit=0123456789abcdef0123456789abcdef01234567
targets=(
  aarch64-apple-darwin
  x86_64-apple-darwin
  aarch64-unknown-linux-gnu
  x86_64-unknown-linux-gnu
)
: > "$tmp/assets.jsonl"
for target in "${targets[@]}"; do
  name="parallax-${version}-${target}.tar.gz"
  printf 'fixture-%s\n' "$target" > "$verified/$name"
  digest=$(shasum -a 256 "$verified/$name" | awk '{print $1}')
  jq -cn --arg name "$name" --arg sha256 "$digest" '{name:$name,sha256:$sha256}' >> "$tmp/assets.jsonl"
done
jq -Sn \
  --arg source_repository tailrocks/parallax \
  --arg source_ref refs/tags/v$version \
  --arg source_commit "$commit" \
  --arg version "$version" \
  --slurpfile assets "$tmp/assets.jsonl" \
  '{schema:"velnor.package-release.v1",source_repository:$source_repository,source_ref:$source_ref,source_commit:$source_commit,version:$version,assets:$assets}' \
  > "$verified/release-manifest.json"
jq -Sn \
  --arg source_repository tailrocks/parallax \
  --arg source_ref refs/tags/v$version \
  --arg source_digest "$commit" \
  --slurpfile manifest "$verified/release-manifest.json" \
  '{source_repository:$source_repository,source_ref:$source_ref,source_digest:$source_digest,manifest:$manifest[0]}' \
  > "$verified/identity.json"

(
  cd "$tmp/repo"
  VELNOR_VERIFIED_PACKAGE_DIR="$verified" ./scripts/package-update.sh
  shasum -a 256 Formula/parallax.rb > "$tmp/first.sha"
  VELNOR_VERIFIED_PACKAGE_DIR="$verified" ./scripts/package-update.sh
  shasum -a 256 -c "$tmp/first.sha"
  grep -F 'version "1.2.3"' Formula/parallax.rb
  grep -F "# source-sha: $commit" Formula/parallax.rb
  test "$(grep -c 'sha256 "[0-9a-f]\{64\}"' Formula/parallax.rb)" -eq 4
)

jq '.source_repository = "attacker/example"' "$verified/identity.json" > "$tmp/bad-identity.json"
mv "$tmp/bad-identity.json" "$verified/identity.json"
if (cd "$tmp/repo" && VELNOR_VERIFIED_PACKAGE_DIR="$verified" ./scripts/package-update.sh); then
  echo "spoofed source identity was accepted" >&2
  exit 1
fi
