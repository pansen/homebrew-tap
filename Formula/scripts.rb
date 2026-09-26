class Scripts < Formula
  desc "Wrappers that run AI coding agents inside the nono sandbox"
  homepage "https://github.com/pansen/scripts"
  url "https://github.com/pansen/scripts/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "607fad69db48b78cee8afe1cce8b20e8489142710745821026baadc499aaa831"
  license "MIT"
  head "https://github.com/pansen/scripts.git", branch: "main"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "nono"

  # bin/nono-agy-acp execs this bridge from ../libexec.
  resource "agy-acp" do
    url "https://github.com/shubzkothekar/antigravity-acp/releases/download/v1.1.0/agy-acp-darwin-arm64"
    sha256 "9ef7afa432341c05d6c049d143349ea71fbb48989813ba625054a7224e2804fc"
  end

  def install
    prefix.install "bin", "libexec"
    resource("agy-acp").stage { libexec.install "agy-acp-darwin-arm64" }
    chmod 0755, libexec/"agy-acp-darwin-arm64"
  end

  def caveats
    <<~EOS
      The wrappers expect the agent CLIs (claude, codex, codex-acp, opencode,
      agy) to be installed separately and on PATH.
    EOS
  end

  test do
    assert_match "is a library", shell_output("bash #{libexec}/nono-sandbox.bash 2>&1", 1)
    assert_predicate libexec/"agy-acp-darwin-arm64", :executable?
  end
end
