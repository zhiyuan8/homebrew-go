# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.0"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.0/nexa-cli-macos-13-llama-cpp-metal-v0.2.0.tar.gz"
      sha256 "c870e2fa0c675105083cbe2113df81a496550f1a518b3368bea48eb74625aec0"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.0/nexa-cli-macos-14-mlx-v0.2.0.tar.gz"
        sha256 "b3ec255d86e928f5d23a96080ba82d09b135c4ca9641e1cd38bd206ed326197d"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.0/nexa-cli-macos-14-llama-cpp-metal-v0.2.0.tar.gz"
        sha256 "59e3c72773bb9fa558a63a355badcfc47b89968ce502cb634193fadf6d43d9f1"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.0/nexa-cli-macos-15-mlx-v0.2.0.tar.gz"
        sha256 "e7a7af04d12d7c134ea22f8341422db2e6880a2a5d94a4c87c4d71e3a8fb4f17"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.0/nexa-cli-macos-15-llama-cpp-metal-v0.2.0.tar.gz"
        sha256 "3161cb6c950c9c8ee53bc5487d8d4138d85f705a58dc28622fd1c7e7893595a3"
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
