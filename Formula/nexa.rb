# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/NexaAI/nexasdk-go"
  version "0.1.4"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.4/nexa-cli-macos-13-llama-cpp-metal-v0.1.4.tar.gz"
      sha256 "24f0b1bd2c702c4d653e12e791a5f541afca84528c1ef4292d3be044889e5bd5"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.4/nexa-cli-macos-14-mlx-v0.1.4.tar.gz"
        sha256 "ed60928547364d2f8ead361665299a8b2e615f4095b1913a751f5dd2cf0cfcb8"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.4/nexa-cli-macos-14-llama-cpp-metal-v0.1.4.tar.gz"
        sha256 "4720ed7d052ea9d7f47dec1f8c8b48a82539a5756532b4d63a02db4972144a30"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.4/nexa-cli-macos-15-mlx-v0.1.4.tar.gz"
        sha256 "5fa1819731bcc4dda7d133e3e3acb906cd6f712d0a5443b72b139cbf9ab8e8ec"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.4/nexa-cli-macos-15-llama-cpp-metal-v0.1.4.tar.gz"
        sha256 "c3d24c3e257d2082e4e475e4b19d13c42662e51f745ea7c33e59941a61aa4582"
      end
    end
  end

  def install
    # The tarball was created with `-C`, so all files are at the root.
    bin.install "nexa"
    bin.install "nexa-cli"
    libexec.install "lib"
  end

  def post_install
    # This block creates wrapper scripts to set DYLD_LIBRARY_PATH
    # It moves the original executables and replaces them with the wrappers

    # For nexa executable
    if (bin/"nexa").exist? && !(bin/"nexa").symlink?
      (bin/"nexa.original").unlink if (bin/"nexa.original").exist?
      mv bin/"nexa", bin/"nexa.original"
      (bin/"nexa").write <<~EOS
        #!/bin/bash
        export DYLD_LIBRARY_PATH="#{libexec}/lib"
        exec "#{bin}/nexa.original" "$@"
      EOS
    end

    # For nexa-cli executable
    if (bin/"nexa-cli").exist? && !(bin/"nexa-cli").symlink?
      (bin/"nexa-cli.original").unlink if (bin/"nexa-cli.original").exist?
      mv bin/"nexa-cli", bin/"nexa-cli.original"
      (bin/"nexa-cli").write <<~EOS
        #!/bin/bash
        export DYLD_LIBRARY_PATH="#{libexec}/lib"
        exec "#{bin}/nexa-cli.original" "$@"
      EOS
    end
  end

  test do
    assert_match "version", shell_output("#{bin}/nexa-cli --version")
  end
end
