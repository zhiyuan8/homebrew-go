# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.0.3"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.3/nexa-cli-macos-13-llama-cpp-metal-v0.0.3.tar.gz"
      sha256 "327f2610cc36ad933df869e5b63381d88e139a4b073279953437b1a4dcf3bcba"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.3/nexa-cli-macos-14-mlx-v0.0.3.tar.gz"
        sha256 "f805b659fa6e3af79aa18f83e49976dfcd263d604c723d6aebdf352aed73cb2e"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.3/nexa-cli-macos-14-llama-cpp-metal-v0.0.3.tar.gz"
        sha256 "f696d5dca5c24d2b5eadef9f1db40c94457ba503bbc1722644ed029bf91ec926"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.3/nexa-cli-macos-15-mlx-v0.0.3.tar.gz"
        sha256 "b76c9a798fe8d64816292b8ed71c5dca32561e4d024c7d23ee1c1e78893091f0"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.3/nexa-cli-macos-15-llama-cpp-metal-v0.0.3.tar.gz"
        sha256 "fdc766b6360822e4068537724c7d394a69075c187997920ba34aa1610e19aacf"
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
