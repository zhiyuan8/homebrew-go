# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.6"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.6/nexa-cli-macos-13-llama-cpp-metal-v0.2.6.tar.gz"
      sha256 "5e8d437fd761c88485786f8900b9f2a7e097a94e43301f744f0146a7a4cae104"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.6/nexa-cli-macos-14-mlx-v0.2.6.tar.gz"
        sha256 "79d4d6dc6f2367b02ec65115bd867b366f6b2d3e0f1a4b63b52bbd55345ceb6c"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.6/nexa-cli-macos-14-llama-cpp-metal-v0.2.6.tar.gz"
        sha256 "259efa8d92ac36fa361c43cc6dfe7333e2c431242d2614c9bd87fd91f4ef9364"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.6/nexa-cli-macos-15-mlx-v0.2.6.tar.gz"
        sha256 "51e13326cbc1a59c454b2e738f1e3de8d40031e7ac98847a160468529bcc375c"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.6/nexa-cli-macos-15-llama-cpp-metal-v0.2.6.tar.gz"
        sha256 "e39785ef27e81c13f434c73cca7ac91f5dd06663956b1ec3aa0503ad1b097537"
      end
    end
  end

def install
    libexec.install "nexa"
    libexec.install "nexa-cli"
    libexec.install "lib"

    chmod "+x", libexec/"nexa"
    chmod "+x", libexec/"nexa-cli"
    chmod "-R", "+x", libexec/"lib"

    (bin/"nexa").write <<~EOS
      #!/bin/bash
      export DYLD_LIBRARY_PATH="#{libexec}/lib"
      exec "#{libexec}/nexa" "$@"
    EOS

    (bin/"nexa-cli").write <<~EOS
      #!/bin/bash
      export DYLD_LIBRARY_PATH="#{libexec}/lib"
      exec "#{libexec}/nexa-cli" "$@"
    EOS
  end

  test do
    assert_match "version", shell_output("#{bin}/nexa --version")
  end
end
