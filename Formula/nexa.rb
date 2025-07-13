# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.11"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.11/nexa-cli-macos-13-llama-cpp-metal-v0.2.11.tar.gz"
      sha256 "5366f6089f448c37c85a816c72bd2672442ed9a891de704d46f0fe6b5b7928d8"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.11/nexa-cli-macos-14-mlx-v0.2.11.tar.gz"
        sha256 "1a401b580657962f6f30a58555ddb0b00e0cacf7dae88ff614db5f2607c4c41f"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.11/nexa-cli-macos-14-llama-cpp-metal-v0.2.11.tar.gz"
        sha256 "9b5d1564cf0f9d55f1ef501c0c43d510529db99cd55a8d9f094e9ed4197338ad"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.11/nexa-cli-macos-15-mlx-v0.2.11.tar.gz"
        sha256 "4c57e34c2cc2952ac548c7e486744e8af896e7f418d0dc10b84aa127828decb6"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.11/nexa-cli-macos-15-llama-cpp-metal-v0.2.11.tar.gz"
        sha256 "346fa88677c1a79611f6f2b0663929b22934bfa29683f0cca80025dad1bb56e3"
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
