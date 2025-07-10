# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.2"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.2/nexa-cli-macos-13-llama-cpp-metal-v0.2.2.tar.gz"
      sha256 "8d17a57ecd2af59c3b020dfc572c39d948e926e2eac98f1dc54f3e07badf14ee"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.2/nexa-cli-macos-14-mlx-v0.2.2.tar.gz"
        sha256 "b70c367805763463e1b813fb65fd6f7ab4a46359e71b4f74bb0dde6f37065b76"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.2/nexa-cli-macos-14-llama-cpp-metal-v0.2.2.tar.gz"
        sha256 "39662c3b0a34041d5693b8861c81dccff0a632f8370a0a2614b2a9340bdb6e86"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.2/nexa-cli-macos-15-mlx-v0.2.2.tar.gz"
        sha256 "03964c4bb6e42c4d31852bedfe30c491b294000692aaa9c83ae6f4c675b21ac2"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.2/nexa-cli-macos-15-llama-cpp-metal-v0.2.2.tar.gz"
        sha256 "aa6789106870889dbb8d81e4fb637e6040ac45e41df32231b9d8933515cbd109"
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
