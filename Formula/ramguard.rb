class Ramguard < Formula
  desc "Sovereign macOS memory pressure daemon — native Swift"
  homepage "https://github.com/borjamoskv/cortex-ram-guard"
  url "https://github.com/borjamoskv/cortex-ram-guard.git", tag: "v3.0.0"
  head "https://github.com/borjamoskv/cortex-ram-guard.git", branch: "master"
  license "MIT"
  version "3.0.0"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/ramguard"
  end

  def post_install
    ohai "Run 'ramguard install' to start the background daemon"
    ohai "Run 'ramguard status' to check memory pressure"
  end

  service do
    run [opt_bin/"ramguard", "run"]
    keep_alive true
    log_path var/"log/ramguard.log"
    error_log_path var/"log/ramguard-error.log"
    process_type :background
  end

  test do
    assert_match "3.0.0", shell_output("#{bin}/ramguard --version")
  end
end
