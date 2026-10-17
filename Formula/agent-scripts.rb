class AgentScripts < Formula
  desc "Wrappers that run AI coding agents inside the nono sandbox"
  homepage "https://github.com/pansen/agent-scripts"
  url "https://github.com/pansen/agent-scripts/archive/refs/tags/v2026.10.17.1414.tar.gz"
  sha256 "bf262235b3ba97f69ead6822140ae0aea0e3fd1ef1159afa6de96957f0b3b5a3"
  license "MIT"
  head "https://github.com/pansen/agent-scripts.git", branch: "main"

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
