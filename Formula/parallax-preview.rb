# source-sha: b18e1cfccc304d2e333b2b22ae25317216b12879
class ParallaxPreview < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  version "0.1.0-preview.726+b18e1cf"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-apple-darwin.tar.gz"
      sha256 "a8ca3be5c94ece8ec4ea0a4163129b63cd732c99fa1d8c460e56726c0fa0aa58"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-apple-darwin.tar.gz"
      sha256 "593b0a620409cf9de07dd58e4a8c4003938030166d89f95b8230fff30f099dfc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "05c29f67137dbcd80a8bef5fd897fdfd3708515d7659e06026ee8408068648f0"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0859e1e819a0acfaca11b1311e5b4737011115ba372dd881c9ba0f3084847c7f"
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
