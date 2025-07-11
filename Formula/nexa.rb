# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.0.0"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.0/nexa-cli-macos-13-llama-cpp-metal-v0.0.0.tar.gz"
      sha256 "27dde0060c2fcc509b96debf6f530fc9b87759504b581ffd02910fe0dc1f86da"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.0/nexa-cli-macos-14-mlx-v0.0.0.tar.gz"
        sha256 "180d80787e21b281149f98abad3f1f19177842ada2eae630a3cfd023a10d556a"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.0/nexa-cli-macos-14-llama-cpp-metal-v0.0.0.tar.gz"
        sha256 "4a7abeec1633ee130abf4f1cc29cf7617277bce64ff2f3103812df27d1ce4d75"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.0/nexa-cli-macos-15-mlx-v0.0.0.tar.gz"
        sha256 "cadabcede30364c17f6f6cc878047f89ebf59f5b2510f17082f763b695e24b5d"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.0/nexa-cli-macos-15-llama-cpp-metal-v0.0.0.tar.gz"
        sha256 "7671f75c3c5c0af022d39a880916ee254c2668df2d7ca449cd47472dd9a6b46a"
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
