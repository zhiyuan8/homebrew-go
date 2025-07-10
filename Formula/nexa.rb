# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.1"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.1/nexa-cli-macos-13-llama-cpp-metal-v0.2.1.tar.gz"
      sha256 "34776b68e4a2c91cc19eb7edeb90e17701e3b45dddf0efb7c12be90b479e9027"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.1/nexa-cli-macos-14-mlx-v0.2.1.tar.gz"
        sha256 "6df2b087abcd2fc3142bec5ab5dd9ad3ff00c338134d5dee1c94d68d66cb913a"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.1/nexa-cli-macos-14-llama-cpp-metal-v0.2.1.tar.gz"
        sha256 "bf467bc6a8fa7fe15453e5a504309f56162a0614f59aca2194502010d11f5506"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.1/nexa-cli-macos-15-mlx-v0.2.1.tar.gz"
        sha256 "e273a7bcce367ea46ccfb03b298f194a423354b7ad19ed779dcfc3dedd9cbec8"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.1/nexa-cli-macos-15-llama-cpp-metal-v0.2.1.tar.gz"
        sha256 "d672e63564cedaaaae5376683fe2093a55bb2682aaa238f9c5a9e4d5ce23683a"
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
