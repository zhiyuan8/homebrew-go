# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.1.2"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.2/nexa-cli-macos-13-llama-cpp-metal-v0.1.2.tar.gz"
      sha256 "49248e22c0353954dc935b822cfb192940448a304d0d5b239db661216d290cad"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.2/nexa-cli-macos-14-mlx-v0.1.2.tar.gz"
        sha256 "22395bd080c4ed4e353f9fa24d311ccdb0882fec6353e0320cf9ef5f80fda964"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.2/nexa-cli-macos-14-llama-cpp-metal-v0.1.2.tar.gz"
        sha256 "187625901ae264b5666cc154eeba7aa7ab49d0fbf3eb570921b41a67f4eb2aee"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.2/nexa-cli-macos-15-mlx-v0.1.2.tar.gz"
        sha256 "6e2531ef48404a50bcf82623ec6128b5e7e38351846705ec0dec72be142a94a0"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.2/nexa-cli-macos-15-llama-cpp-metal-v0.1.2.tar.gz"
        sha256 "5a9cf402d149cecdf63da414bef7e0278c1a4938b1307bb0c5d192f7558b541e"
      end
    end
  end

def install
    libexec.install "nexa"
    libexec.install "nexa-cli"
    libexec.install "lib"

    chmod "+x", libexec/"nexa"
    chmod "+x", libexec/"nexa-cli"

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
