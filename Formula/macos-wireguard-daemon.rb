class MacosWireguardDaemon < Formula
  desc "macOS WireGuard daemon"
  homepage "https://github.com/pansen/macos-wireguard-daemon"
  url "https://github.com/pansen/macos-wireguard-daemon/releases/download/0.0.7/wgd-0.0.7-aarch64-apple-darwin.tar.gz"
  sha256 "a24e4d98d2022cd62f5b43a76adb7475d9760901cd4ae23a899d9a74673494b8"
  version "__VERSION__"
  license "MIT"

  depends_on arch: :arm64

  def install
    bin.install "wgd"
  end

  def caveats
    <<~EOS
      wgd's privileged launchd daemon refuses to run from #{HOMEBREW_PREFIX},
      since that directory isn't root-owned. To install the daemon:

        sudo install -o root -g wheel -m 755 #{opt_bin}/wgd /usr/local/bin/wgd
        sudo /usr/local/bin/wgd launchd install

      See https://github.com/pansen/macos-wireguard-daemon for details.
    EOS
  end

  test do
    system "#{bin}/wgd", "--version"
  end
end
