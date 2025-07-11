# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.8"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.8/nexa-cli-macos-13-llama-cpp-metal-v0.2.8.tar.gz"
      sha256 "7e2c6b3240e4bbeceddb87df545cfc6f9b381bbdbc1e3a64a9a1ffb4ae74dda2"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.8/nexa-cli-macos-14-mlx-v0.2.8.tar.gz"
        sha256 "9a6a369c23f3d2bfd07f5bd10e10648e4c8cd9a73630eb07f522ff916e61042d"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.8/nexa-cli-macos-14-llama-cpp-metal-v0.2.8.tar.gz"
        sha256 "fd023155fdd44a8d977137febb26bebcac49e93f579a3a9739b3579f23bae5f4"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.8/nexa-cli-macos-15-mlx-v0.2.8.tar.gz"
        sha256 "0985857f2cf35a16f931f4edfa7d57a532a5e70f4075353ca2006ac75f4f3bd4"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.8/nexa-cli-macos-15-llama-cpp-metal-v0.2.8.tar.gz"
        sha256 "4bc04c5ab6e89a2eada9a47a006e732ca3a23eebb8b0be21518dd99e4309c4b4"
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
