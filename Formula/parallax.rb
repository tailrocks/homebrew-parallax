# source-sha: da3ce716ecbe50f6d5e00ce89948a7f376636f12
class Parallax < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/v0.1.0/parallax-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "20d395938376c46eeef6fe4b95aa0abf3066fd37398fe934c45042a8f6a51ba2"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/v0.1.0/parallax-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "02a1923f402914f752c811ee2c31d5f80134d7766e7c122f2217912812b5f34f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/v0.1.0/parallax-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97c7bfd2dce7bd601eb036d885f308776e3017ea23f590bc250ec4e43a5449f4"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/v0.1.0/parallax-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "32cdb80b9ef6fd12355cab71447dc2f7468cdc1516ed79983d4a72504bf4f465"
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
