# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.0.2"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.2/nexa-cli-macos-13-llama-cpp-metal-v0.0.2.tar.gz"
      sha256 "817527c24f8bec50ce109efd30e48fedcfc367a56a99f5d8688c312852fc28be"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.2/nexa-cli-macos-14-mlx-v0.0.2.tar.gz"
        sha256 "7c2ed346645100d71d7fc8b86ea6d758217b289b7dced2deb99b15362fa5b493"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.2/nexa-cli-macos-14-llama-cpp-metal-v0.0.2.tar.gz"
        sha256 "1332b70b49742de0c73fbf0bbd47d81777b154a374b024c768575a99b21c58bd"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.2/nexa-cli-macos-15-mlx-v0.0.2.tar.gz"
        sha256 "2f48c9a5b794c46d19a6a42185c9a2fce75b6ca3eb238d8696c454bd55ef7a60"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.0.2/nexa-cli-macos-15-llama-cpp-metal-v0.0.2.tar.gz"
        sha256 "852cb7c50b27f96152b8c789e06692a27db8abc590cff05f3acea3c45916ba8c"
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
