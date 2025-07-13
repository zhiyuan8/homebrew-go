# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.10"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.10/nexa-cli-macos-13-llama-cpp-metal-v0.2.10.tar.gz"
      sha256 "1a5cdd436ca5ec1561aeb8ad986a6b5d542e73a138a47196f670f9e29b17f786"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.10/nexa-cli-macos-14-mlx-v0.2.10.tar.gz"
        sha256 "dd154e2f30d79458cbcf0bde03e5e6beb4d38b5370d204dbf760f637cf52efcb"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.10/nexa-cli-macos-14-llama-cpp-metal-v0.2.10.tar.gz"
        sha256 "c9291098ab49a0a1da7792f3993b07e039b52af46a6437957554398b0884b19a"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.10/nexa-cli-macos-15-mlx-v0.2.10.tar.gz"
        sha256 "f73cbf0c2d4170d9c10e3131c9fbb6a4fb1573a82395d27ccb16710addb910c3"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.10/nexa-cli-macos-15-llama-cpp-metal-v0.2.10.tar.gz"
        sha256 "bc4f1ad88a2703ea1f9c4a2fe4aac7f97cb327987850546a5b417170dd2b3d68"
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
