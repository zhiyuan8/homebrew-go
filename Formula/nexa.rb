# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/NexaAI/nexasdk-go"
  version "0.1.0"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos-13-llama-cpp-metal-v0.1.0.tar.gz"
      sha256 "42042e00488001a4863044cd816763abd5be12b4ddba93a72857f1fc59915f8a"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos-14-mlx-v0.1.0.tar.gz"
        sha256 "fa481f3b607090e80f15ebaa22e43e1287666712c11d334d6d78b72ba2b145ee"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos-14-llama-cpp-metal-v0.1.0.tar.gz"
        sha256 "90846c4c07519cd083b42708303705fb59982dc725a7a149056cb46d0f41c39f"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos-15-mlx-v0.1.0.tar.gz"
        sha256 "0b2f76573b25bfeaa8bc6442cafe7dda9327866945e096b26f119749fa2bc248"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos-15-llama-cpp-metal-v0.1.0.tar.gz"
        sha256 "83ca13e9d64180aeb9c23e9ef4c909997ee03f08d8bdf6be58637e7b84b9eb21"
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
