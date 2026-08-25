# source-sha: dd9339891f379723e6fa52c4daad798c57517401
class ParallaxPreview < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  version "0.1.0-preview.2497+dd93398"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-apple-darwin.tar.gz"
      sha256 "a4d6274c59d7890c597b91d1c3a40c1df3270a7b6979a0d7b4c3e0f2c223fe46"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-apple-darwin.tar.gz"
      sha256 "86af12bce3db0e299d8d3379d9bcdd1c5d797be86b05f671ca5cafba99cd43ba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a6bc151a5990d0df94ac0bfa57167b84a5f253a421acd5d4c0160eaaa344db6f"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8768def07cae16de8fe977ed8daa714d4105f151312bb06d45fe0add334636e4"
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
