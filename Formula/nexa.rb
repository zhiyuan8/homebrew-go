# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.1.0"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.0/nexa-cli-macos-13-llama-cpp-metal-v0.1.0.tar.gz"
      sha256 "f15015ffc9974afdb973d7548d9332d79472b64d4f693b61f529f5a2229162f2"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.0/nexa-cli-macos-14-mlx-v0.1.0.tar.gz"
        sha256 "75f5274a2c77283ea311b5892617f2cf05c05a176097958690e8910e4a5b566e"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.0/nexa-cli-macos-14-llama-cpp-metal-v0.1.0.tar.gz"
        sha256 "b3b59ba17f6de3f4d9a915d2b324206ecf2e7ce21249eeebfb3d9625d4ecdf50"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.0/nexa-cli-macos-15-mlx-v0.1.0.tar.gz"
        sha256 "0b9b36dfb26f7f9c0fe8bbad8ec865b69ecbdbd03cdac26eafa8deca29630291"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.0/nexa-cli-macos-15-llama-cpp-metal-v0.1.0.tar.gz"
        sha256 "e5161be7c2981fac6cc5f368cafb8ab977d66da7857792ddd387c0d49e70e5f1"
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
