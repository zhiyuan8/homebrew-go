class Nexa < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/zhiyuan8/homebrew-go-release"
  license "MIT"
  version "0.1.0"

  option "with-mlx", "Install with the MLX backend instead of the default llama-cpp-metal backend"

  on_macos do
    if MacOS.version == :ventura
      if Hardware::CPU.intel?
        url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/#{version}/nexa-cli_macos-13_llama-cpp-metal.tar.gz"
        sha256 "initial_sha256_hash_here" #<--sha256_macos-13_llama-cpp-metal#
      else
        odie "Nexa-CLI only supports Intel on macOS 13 (Ventura)"
      end
    end

    if MacOS.version == :sonoma
      if Hardware::CPU.arm?
        if build.with?("mlx")
          url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/#{version}/nexa-cli_macos-14_mlx.tar.gz"
          sha256 "initial_sha256_hash_here" #<--sha256_macos-14_mlx#
        else
          url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/#{version}/nexa-cli_macos-14_llama-cpp-metal.tar.gz"
          sha256 "initial_sha256_hash_here" #<--sha256_macos-14_llama-cpp-metal#
        end
      elsif system("sysctl -n sysctl.proc_translated 2>/dev/null").to_i == 1
        odie "Nexa-CLI does not support running under Rosetta on macOS 14 (Sonoma)."
      else
        odie "Nexa-CLI only supports Apple Silicon on macOS 14 (Sonoma)"
      end
    end

    if MacOS.version >= :sequoia
      if Hardware::CPU.arm?
        if build.with?("mlx")
          url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/#{version}/nexa-cli_macos-15_mlx.tar.gz"
          sha256 "initial_sha256_hash_here" #<--sha256_macos-15_mlx#
        else
          url "https://github.com/zhiyuan8/homebrew-go-release/releases/download/#{version}/nexa-cli_macos-15_llama-cpp-metal.tar.gz"
          sha256 "initial_sha256_hash_here" #<--sha256_macos-15_llama-cpp-metal#
        end
      elsif system("sysctl -n sysctl.proc_translated 2>/dev/null").to_i == 1
        odie "Nexa-CLI does not support running under Rosetta on macOS 15 (Sequoia) and later."
      else
        odie "Nexa-CLI only supports Apple Silicon on macOS 15 (Sequoia) and later."
      end
    end
  end

  def install
    bin.install "nexa"
    bin.install "nexa-cli"
    libexec.install "lib"

    chmod "+x", bin/"nexa"
    chmod "+x", bin/"nexa-cli"
    (libexec/"lib/python_runtime/bin").glob("**/*").each { |f| f.chmod(0755) if f.file? }

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
