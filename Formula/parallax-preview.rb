# source-sha: 7fe3f1360e097a61279f8a5554e6af4d3247650c
class ParallaxPreview < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  version "0.1.0-preview.2443+7fe3f13"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-apple-darwin.tar.gz"
      sha256 "43d5a49ebf2da2d8f1fbad607021af069ee04c278386d2b8549ad520cef15ad4"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-apple-darwin.tar.gz"
      sha256 "b2fe0d55356c52b7a10701db450b80edecabffede48106067b533b528ee75b94"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6e4a311cd8a8c33422fd14f7b279f53567d065560b842effe06555d70f48231d"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8ec17959efcba17d9713e0222b00a2c18eca34a470e224db7b0ecb3010301f38"
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
