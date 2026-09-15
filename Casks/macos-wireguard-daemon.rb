cask "macos-wireguard-daemon" do
  version "0.0.8"
  sha256 "c2017eb3ca1cee1b291167ec18df686e4b129ee9cb006cc24ad0b6c0b47e66e8"

  url "https://github.com/pansen/macos-wireguard-daemon/releases/download/0.0.8/wgd-0.0.8-aarch64-apple-darwin.tar.gz"
  name "macOS WireGuard Daemon"
  desc "Daemon for running WireGuard VPN tunnels on macOS"
  homepage "https://github.com/pansen/macos-wireguard-daemon"

  depends_on arch: :arm64

  binary "wgd-0.0.8-aarch64-apple-darwin/wgd", target: "wgd"

  installer script: {
    executable: "wgd-0.0.8-aarch64-apple-darwin/wgd",
    args:       ["launchd", "install"],
    sudo:       true,
  }

  uninstall script: {
    executable:   "/usr/local/bin/wgd",
    args:         ["launchd", "uninstall"],
    sudo:         true,
    must_succeed: false,
  }

  zap script: {
        executable:   "/usr/sbin/dseditgroup",
        args:         ["-o", "delete", "wgd"],
        must_succeed: false,
        sudo:         true,
      },
      delete: [
        "/usr/local/bin/wgd",
        "/Library/Application Support/wgd",
        "/var/log/wgd",
      ]

  caveats <<~EOS
    wgd's privileged launchd daemon is installed and started automatically.
    `brew upgrade` will prompt for your password each time a new version
    ships, to reinstall the daemon from the new binary.

    Check status with `wgd status` (no sudo needed). Restarting or
    uninstalling the daemon needs root, and must go through the trusted
    copy at /usr/local/bin/wgd rather than the `wgd` on your PATH (which
    points into Homebrew's prefix, a location launchd daemons refuse to
    run from):
      sudo /usr/local/bin/wgd launchd restart
      sudo /usr/local/bin/wgd launchd uninstall

    Remove everything, including the wgd group and logs, with:
      brew uninstall --zap macos-wireguard-daemon
  EOS
end
