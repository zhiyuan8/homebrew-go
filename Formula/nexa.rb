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
      sha256 "860c38cd389c66ab77098a3edf124512e3fa2ff55a813077f2c1e8ed62816096"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-14-mlx-v0.1.1.tar.gz"
        sha256 "47a3388eeb3d7299f0321c4ddcf7d7c35e80358661515221da1d3a594862b93c"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-14-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "276485f0341ea82e4d3589a19bec02ec1d90f1e79596c1eec904b49a19e3ad08"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-15-mlx-v0.1.1.tar.gz"
        sha256 "61f28c9ad776f3124340d18213d0112fcd676af9f735bee58d14f163090858fb"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-15-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "fda807b1024a88684fc0da9ad89f14b195fabda534b45178c82bf880f978ed4d"
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
