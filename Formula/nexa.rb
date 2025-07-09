# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.1.1"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-13-llama-cpp-metal-v0.1.1.tar.gz"
      sha256 "9d3142cc249c03e62462f666257673f71e66fabb76efbecaad1d0b9dad96f6c2"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-14-mlx-v0.1.1.tar.gz"
        sha256 "8d99de2ddd45b837affd15c7b3692e6a5ab7f26211e9b97372ed00fb6c4ac333"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-14-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "51d21f83e7eaf5a0826cd051f6b8355ce4174829b5d1c97053c6d9977818058d"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-15-mlx-v0.1.1.tar.gz"
        sha256 "94ea684753e371c2da8b0912b486d382d158c619567e3ef5bacaf9d53773b8d0"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-15-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "c5eeb01044398d11a047828ceeecfc87d9a29c972ecfb4aac4203de962fc458a"
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
