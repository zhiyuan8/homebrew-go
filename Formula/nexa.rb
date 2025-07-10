# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.7"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.7/nexa-cli-macos-13-llama-cpp-metal-v0.2.7.tar.gz"
      sha256 "db558e6e4fc4e7291598c5a17fdc23cfd24e1fb6da2165a41368ab154fe929f3"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.7/nexa-cli-macos-14-mlx-v0.2.7.tar.gz"
        sha256 "92036300ebcd4094735d0d4440b2574e80b0f81962ec62581ddf957c6c37b0a6"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.7/nexa-cli-macos-14-llama-cpp-metal-v0.2.7.tar.gz"
        sha256 "b9ed3ff8428c08de743a1472c67cc2c52d8da02eba3115ae1d611d27642241a3"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.7/nexa-cli-macos-15-mlx-v0.2.7.tar.gz"
        sha256 "55dfdb8cca51cc36168bead1b5f9b560db16500403145d4980c545902cee4f5e"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.7/nexa-cli-macos-15-llama-cpp-metal-v0.2.7.tar.gz"
        sha256 "4f58d093fec0534be2f3f21c3fd8ae49f11540803e2a7341fd49d73a40d8ed6d"
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
