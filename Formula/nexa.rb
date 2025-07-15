# typed: false
# frozen_string_literal: true

require "json"

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  license "MIT"

  MANIFEST_PATH = Pathname.new(__dir__)/"../manifest.json"
  odie "Manifest file not found at #{MANIFEST_PATH}" unless MANIFEST_PATH.exist?
  MANIFEST = JSON.parse(MANIFEST_PATH.read)

  version MANIFEST["version"]

  os_key = if MacOS.version >= :sequoia
             "sequoia_and_later"
           else
             MacOS.version.to_s
           end

  cpu_key = Hardware::CPU.arch_64_bit.to_s

  if OS.mac? && MacOS.version >= :sonoma
    # is_rosetta = `sysctl -n sysctl.proc_translated 2>/dev/null`.strip.to_i == 1
    is_rosetta = Hardware::CPU.in_rosetta2?
    odie "Nexa-CLI does not support running under Rosetta on macOS #{MacOS.version} and later." if is_rosetta
  end

  platform_info = MANIFEST["platforms"].dig(os_key, cpu_key)

  if platform_info
    url_template = MANIFEST["url_template"]
    artifact_name = platform_info["artifact_name"]

    url url_template.gsub("{version}", version.to_s).gsub("{artifact_name}", artifact_name)
    sha256 platform_info["sha256"]
  else
    odie <<~EOS
      Your system configuration is not supported by this version of Nexa-CLI.
      OS: #{os_key}
      CPU: #{cpu_key}
      Please check the formula for supported combinations or open an issue.
    EOS
  end

  def install
    bin.install "nexa"
    bin.install "nexa-cli"

    lib.install "lib/mlx"
    lib.install "lib/llama-cpp-metal"

    # Set permissions
    # chmod "+x", bin/"nexa"
    # chmod "+x", bin/"nexa-cli"
    (lib/"mlx/python_runtime/bin").glob("**/*").each { |f| f.chmod(0755) if f.file? }

    # (bin/"nexa").write <<~EOS
    #   #!/bin/bash
    #   export DYLD_LIBRARY_PATH="#{libexec}/lib"
    #   exec "#{libexec}/nexa" "$@"
    # EOS

    # (bin/"nexa-cli").write <<~EOS
    #   #!/bin/bash
    #   export DYLD_LIBRARY_PATH="#{libexec}/lib"
    #   exec "#{libexec}/nexa-cli" "$@"
    # EOS
  end

  test do
    assert_match "version", shell_output("#{bin}/nexa --version")
  end
end
