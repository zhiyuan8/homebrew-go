# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/NexaAI/nexasdk-go"
  version "0.1.1"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.1/nexa-cli-macos-13-llama-cpp-metal-v0.1.1.tar.gz"
      sha256 "453085bacf9d1e0c3e9ba117517d9f22ca1c544a55b73467c9dfd3c7aee0312c"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.1/nexa-cli-macos-14-mlx-v0.1.1.tar.gz"
        sha256 "f1b3c8defd8053811b334e3b0d96f34a37eef4e14eac82a6342839fad7e84f2c"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.1/nexa-cli-macos-14-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "a686915fc70f1ad933c71ab13cebc743148a7851c0eaf991a1f496687a060cfb"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.1/nexa-cli-macos-15-mlx-v0.1.1.tar.gz"
        sha256 "0c0be7585b943fc023e3ee4f6dee4aed96e7181c9937119ff0df1f8fa70963b8"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.1/nexa-cli-macos-15-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "0a67f5036155b172674bf329dad9f4659a5dfd81b5a8cf08e1e96f8983225638"
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
