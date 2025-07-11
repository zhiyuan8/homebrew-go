# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.0.6"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.6/nexa-cli-macos-13-llama-cpp-metal-v0.0.6.tar.gz"
      sha256 "461795146dac491502041ebf2bef377c11eeecc75c62648109a3922f0151dc14"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.6/nexa-cli-macos-14-mlx-v0.0.6.tar.gz"
        sha256 "62d7d63b45c4e53b0cb0448b87457107b3a9a688d6e424e575c9f2c70793fc7e"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.6/nexa-cli-macos-14-llama-cpp-metal-v0.0.6.tar.gz"
        sha256 "9644ed48a9c091a56f83eb736ff1bcb7721d6fe7dcdaf8c99c9869aea7e431e8"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.6/nexa-cli-macos-15-mlx-v0.0.6.tar.gz"
        sha256 "7ea90acbd236c01500556f8fd32a11e995041b5b202ed90db60b288c08956827"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.6/nexa-cli-macos-15-llama-cpp-metal-v0.0.6.tar.gz"
        sha256 "e50795e08dbf5bf9e7e477c6411d3a5880b3fca507f3cb5a44647f2c5d7b4e7c"
      end
    end
  end

def install
    libexec.install "nexa"
    libexec.install "nexa-cli"
    libexec.install "lib"

    chmod "+x", libexec/"nexa"
    chmod "+x", libexec/"nexa-cli"
    chmod_R "+x", libexec/"lib"

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
