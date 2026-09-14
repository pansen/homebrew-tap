class MacosWireguardDaemon < Formula
  desc "macOS WireGuard daemon"
  homepage "https://github.com/pansen/macos-wireguard-daemon"
  url "https://github.com/pansen/macos-wireguard-daemon/releases/download/0.0.7/wgd-0.0.7-aarch64-apple-darwin.tar.gz"
  sha256 "78f9799c4eef4ffed37ef9bb4be60239eec46c9345bf4120fbcdf10a23abb192"
  version "0.0.7"
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
