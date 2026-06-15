class Parallax < Formula
  desc "Local-first observability for agent-assisted development"
  homepage "https://github.com/tailrocks/parallax"
  license "Apache-2.0"
  head "https://github.com/tailrocks/parallax.git", branch: "main"

  disable! date: "2026-06-15", because: "parallax has not reached a stable release yet; use the rolling preview channel"

  depends_on "rust" => :build

  conflicts_with "tailrocks/parallax/parallax-preview", because: "stable and preview install the same binary"

  def install
    odie "Stable binary releases are not available yet; install parallax@preview"
  end

  def caveats
    <<~EOS
      Stable binary releases are not available yet.
      Install the rolling preview channel instead:
        brew install parallax@preview
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parallax --version")
  end
end
