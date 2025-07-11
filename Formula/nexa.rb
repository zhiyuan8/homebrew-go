# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.0.7"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.7/nexa-cli-macos-13-llama-cpp-metal-v0.0.7.tar.gz"
      sha256 "583127b03e3b0b8370b2c3ec764e366dfdbaea9b5736b10454d4ea68bb6a73ed"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.7/nexa-cli-macos-14-mlx-v0.0.7.tar.gz"
        sha256 "759372b290e81709c683d029754c2345d0997f9a293c9b0c3936c075c4104f62"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.7/nexa-cli-macos-14-llama-cpp-metal-v0.0.7.tar.gz"
        sha256 "f1652a1f43884d54b173420a19f438069fe3daa183d48cedda7eace348da1ef5"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.7/nexa-cli-macos-15-mlx-v0.0.7.tar.gz"
        sha256 "a0e1c12aa52857a2920889e0590ab418afe1cd7e91eaa5a56fabde74032af22e"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.7/nexa-cli-macos-15-llama-cpp-metal-v0.0.7.tar.gz"
        sha256 "61ad1b36df3856735d99597ce7539c887e90f74697b75f6f7efa5155e8738f0b"
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
