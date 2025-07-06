# typed: false
# frozen_string_literal: true

class NexaCli < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/NexaAI/nexasdk-go"
  version "0.1.3"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.3/nexa-cli-macos-13-llama-cpp-metal-v0.1.3.tar.gz"
      sha256 "79882a689238ab95fe9ca049d60785f9d20a0b6e39a17a87f963c070edf9e233"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.3/nexa-cli-macos-14-mlx-v0.1.3.tar.gz"
        sha256 "a58dcf1c763ba7e0039a79181d6db94e611ae5f55e09e39727f07e086e0915bb"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.3/nexa-cli-macos-14-llama-cpp-metal-v0.1.3.tar.gz"
        sha256 "c9b1bb889ccda6cae1d19aa9430876f5f799840d5c68e227a5d02f18b840909e"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.3/nexa-cli-macos-15-mlx-v0.1.3.tar.gz"
        sha256 "145cdc5e7567edb95f5870666d88f8ca82be3d087b0a08b4c26268bcef5a6f2f"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.3/nexa-cli-macos-15-llama-cpp-metal-v0.1.3.tar.gz"
        sha256 "9f481e1a8cac30543d99d26a7a2dab423ab0a500831afecd4d5b4e8f5992209e"
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
