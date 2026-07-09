# source-sha: d04426afdb215ec7a410c5ce2036cc8a91bcffeb
class ParallaxPreview < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  version "0.1.0-preview.765+d04426a"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-apple-darwin.tar.gz"
      sha256 "9fda3d6fa67c6b6d10454cd1284c99da470aeaccd519424debff8af5a24a769c"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-apple-darwin.tar.gz"
      sha256 "0c540b43fdc2e4aa1cf02b828603864db071106853d1940f36972c075b63a2f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d10f5c6bfec5794be86283379bc84349e51b0fb25cb302910667826c680c1079"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "803c4db83e34acf7bc3a321797b493b54ae48ee7fd169aa1fb305174a3e83dde"
    end
  end

  conflicts_with "tailrocks/parallax/parallax", because: "preview and stable install the same binary"

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
