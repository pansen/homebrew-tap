cask "macos-wireguard-daemon" do
  version "0.0.18"
  sha256 "f6827ea59c84b6d6c1ccd022c4f63a863e3ec07886a7be49b8862950c5b6b288"

  url "https://github.com/pansen/macos-wireguard-daemon/releases/download/v#{version}/wgd-#{version}-aarch64-apple-darwin.dmg"
  name "macOS WireGuard Daemon"
  desc "Daemon for running WireGuard VPN tunnels"
  homepage "https://github.com/pansen/macos-wireguard-daemon"

  depends_on arch: :arm64

  installer script: {
    executable: "wgd",
    args:       ["launchd", "install"],
    sudo:       true,
  }
  binary "wgd", target: "wgd"

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
        "/Library/Application Support/wgd",
        "/usr/local/bin/wgd",
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
