# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.0.8"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.8/nexa-cli-macos-13-llama-cpp-metal-v0.0.8.tar.gz"
      sha256 "c8436d4923373ec2c20dfa2c8963d10b7576ab86942ea20012df4c422c8c7b9b"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.8/nexa-cli-macos-14-mlx-v0.0.8.tar.gz"
        sha256 "7f7ba2e73aac0ffb79833a1dc4cc2692f8eaeccbd18d6631e67d553abd555e75"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.8/nexa-cli-macos-14-llama-cpp-metal-v0.0.8.tar.gz"
        sha256 "e6ccacafefc59b923b970f1d43e8f7ba7b283939d519ac67db024fd37868896a"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.8/nexa-cli-macos-15-mlx-v0.0.8.tar.gz"
        sha256 "5885faa038b3c113db9483af9f09698fd3126617d2998d89fb185b0a54ce7da0"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.8/nexa-cli-macos-15-llama-cpp-metal-v0.0.8.tar.gz"
        sha256 "bcf26a7bc154834b05d25c09d632ada343e190600fa295911dc1b1e0066e53c9"
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
