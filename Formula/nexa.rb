# typed: false
# frozen_string_literal: true

class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  version "0.1.1"
  license "MIT"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_ventura do
    on_intel do
      # This OS/Arch only supports the Llama-cpp-metal backend
      url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-13-llama-cpp-metal-v0.1.1.tar.gz"
      sha256 "7ac28bce37223a1dcd5e2aa4478f280c588a26a493c159fcb14e7c4494be02b1"
    end
  end
  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-14-mlx-v0.1.1.tar.gz"
        sha256 "6968587cd41212d426d84121f1340c217370350b84103d5357bb0b49aa603625"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-14-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "9c9f2bd94cc69874b1979838eed26842161d412baf2460a903c1fccc164aabbe"
      end
    end
  end
  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-15-mlx-v0.1.1.tar.gz"
        sha256 "1b515c5fbdb9d01aed7d453b1fa948a8f82bca7c8c69bdcf5d60a3fe22980a36"
      else
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/v0.1.1/nexa-cli-macos-15-llama-cpp-metal-v0.1.1.tar.gz"
        sha256 "8d047aeae8589978e2b7867ef208aa32b7d9e0baeccfc78418dde83baa992559"
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
