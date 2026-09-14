# source-sha: e885232147db7a7869fecd201f20fa33de979bb4
class ParallaxPreview < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  version "0.1.0-preview.2515+e885232"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-apple-darwin.tar.gz"
      sha256 "975c2ddb109de0932c8e519930be1ae39525713eaef2b237b73fa64b38c58fdf"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-apple-darwin.tar.gz"
      sha256 "3c178f6d1ec1f8370c453a24835fa9312aaf649676d4eb313bff61fdcfda4818"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "181a82dc91d74250efa72c428b63e85e722dab6d8182d6a90f613cd273fb1897"
    end
    on_intel do
      url "https://github.com/tailrocks/parallax/releases/download/preview/parallax-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "437f4a0bbda89cd4e2bfbb3ab150a5d3e64dbd8c7d08c148c78c2b8a5899ca6a"
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
