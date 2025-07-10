# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.2.5"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.5/nexa-cli-macos-13-llama-cpp-metal-v0.2.5.tar.gz"
      sha256 "46df5fb0bf69dbc7e84aedd0f89354afdcd7874877dd0e75cc19f1d272070031"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.5/nexa-cli-macos-14-mlx-v0.2.5.tar.gz"
        sha256 "3d37a74ddc1911fa967a3fa617906d8b4ea012a97820172b5771511d91852670"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.5/nexa-cli-macos-14-llama-cpp-metal-v0.2.5.tar.gz"
        sha256 "7af5225291330a06664f12d8d055ae8e5d16a3933fd2977ecb8c9854850600cb"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.5/nexa-cli-macos-15-mlx-v0.2.5.tar.gz"
        sha256 "ffb583183f9745d351c0324450855b4089c0255d5d7b93df22d40f09dc0db7c5"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.2.5/nexa-cli-macos-15-llama-cpp-metal-v0.2.5.tar.gz"
        sha256 "2423bab2327659afa72a43653e4272f3be6b4d854de20c3ae58b6e418129ab8b"
      end
    end
  end

def install
    libexec.install "nexa"
    libexec.install "nexa-cli"
    libexec.install "lib"

    chmod "+x", libexec/"nexa"
    chmod "+x", libexec/"nexa-cli"
    chmod -R "+x", libexec/"lib"

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
