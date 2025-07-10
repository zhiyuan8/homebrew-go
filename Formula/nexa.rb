# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.4"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.4/nexa-cli-macos-13-llama-cpp-metal-v0.2.4.tar.gz"
      sha256 "ffeb0387a10b50739d7ce67fc389a8e9cd9a4c17715975da37a418e6ace29853"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.4/nexa-cli-macos-14-mlx-v0.2.4.tar.gz"
        sha256 "e014585dbc0a37ef99a746f239ed6978b4e10ec0b5a93994c924c687ef08f77c"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.4/nexa-cli-macos-14-llama-cpp-metal-v0.2.4.tar.gz"
        sha256 "5f08d9e02aa2936aa409f056a8362d1c3deef0dda6474097afdb5cf74dc2a9c3"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.4/nexa-cli-macos-15-mlx-v0.2.4.tar.gz"
        sha256 "7ea28d10e19a0d91f4d714d4f7e14114398ef9ef96ac00966df51e788a89a686"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.4/nexa-cli-macos-15-llama-cpp-metal-v0.2.4.tar.gz"
        sha256 "c458382a63813406430a697ad0fc26e2cd4057fc8f6a6483bc74ee4395ab2477"
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
