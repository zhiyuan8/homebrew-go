# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.9"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.9/nexa-cli-macos-13-llama-cpp-metal-v0.2.9.tar.gz"
      sha256 "3f142a1c69e942889593380c59219995d24e8c9269e1e61a483e031722104aa4"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.9/nexa-cli-macos-14-mlx-v0.2.9.tar.gz"
        sha256 "8e29887f4cedb0450f85e9723f7fbfc840ecb4eb303e4fa4acad3502870f539c"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.9/nexa-cli-macos-14-llama-cpp-metal-v0.2.9.tar.gz"
        sha256 "9919c6e3f49f7c7b64f349ff5ae2067af7ed5610ea6f52668f095034abab7428"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.9/nexa-cli-macos-15-mlx-v0.2.9.tar.gz"
        sha256 "50afeb1077e3e878caa154adcf45fb424cfb8a87bd373cfaea7ba70ae2147f95"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.9/nexa-cli-macos-15-llama-cpp-metal-v0.2.9.tar.gz"
        sha256 "613a82a4327c992480ffc0390f880e863a187c091dc6c29c0e33459fd2b56e8d"
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
