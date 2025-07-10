# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.3"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.3/nexa-cli-macos-13-llama-cpp-metal-v0.2.3.tar.gz"
      sha256 "593639e231ba14062793c784526ceb62c74b862e3e1cd1e2d599e929b1117c5e"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.3/nexa-cli-macos-14-mlx-v0.2.3.tar.gz"
        sha256 "936a747ab10ef8f54c4a867f5ebdf53f6b30e203c76cbc2ccbd18d05e115f1e5"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.3/nexa-cli-macos-14-llama-cpp-metal-v0.2.3.tar.gz"
        sha256 "a887f0c0cce4cd3a7e5ce41072c6e8509a550d698beda1159d8c44b74409b844"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.3/nexa-cli-macos-15-mlx-v0.2.3.tar.gz"
        sha256 "d8c536909112dc027cc0f8acfa8180222aa359d3a3dc11174de8249c970e1837"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.3/nexa-cli-macos-15-llama-cpp-metal-v0.2.3.tar.gz"
        sha256 "80013fcfc020399f4fa9507bf4443b8b900e4f6872f94fed07fd4ddc7ecf8c9c"
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
