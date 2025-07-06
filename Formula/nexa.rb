class NexaCli < Formula
  desc "A powerful CLI for the NexaAI ecosystem"
  homepage "https://github.com/NexaAI/nexasdk-go"
  version "0.1.0"

  option "with-mlx", "Install with the MLX backend instead of the default Llama-cpp-metal backend"

  on_sequoia do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos_15-arm64-mlx-v0.1.0.tar.gz"
        sha256 "checksum_for_macos15_arm64_mlx"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos_15-arm64-llama-cpp-metal-v0.1.0.tar.gz"
        sha256 "checksum_for_macos15_arm64_metal"
      end
    end
  end

  on_sonoma do
    on_arm do
      if build.with? "mlx"
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos_14-arm64-mlx-v0.1.0.tar.gz"
        sha256 "checksum_for_macos14_arm64_mlx"
      else
        url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos_14-arm64-llama-cpp-metal-v0.1.0.tar.gz"
        sha256 "checksum_for_macos14_arm64_metal"
      end
    end
  end

  on_ventura do
    on_intel do
      url "https://github.com/NexaAI/nexasdk-go/releases/download/v0.1.0/nexa-cli-macos_13-x86_64-llama-cpp-metal-v0.1.0.tar.gz"
      sha256 "checksum_for_macos13_x86_64_metal"
    end
  end

  def install
    bin.install "nexa"
    bin.install "nexa-cli"
    libexec.install "lib"
  end


  def post_install
    (bin/"nexa_wrapper").write <<~EOS
      #!/bin/bash
      export DYLD_LIBRARY_PATH="#{libexec}/lib"
      exec "#{bin}/nexa.original" "$@"
    EOS
    (bin/"nexa-cli_wrapper").write <<~EOS
      #!/bin/bash
      export DYLD_LIBRARY_PATH="#{libexec}/lib"
      exec "#{bin}/nexa-cli.original" "$@"
    EOS

    mv bin/"nexa", bin/"nexa.original" if File.exist?(bin/"nexa") && !File.symlink?(bin/"nexa")
    mv bin/"nexa_wrapper", bin/"nexa" if File.exist?(bin/"nexa_wrapper")

    mv bin/"nexa-cli", bin/"nexa-cli.original" if File.exist?(bin/"nexa-cli") && !File.symlink?(bin/"nexa-cli")
    mv bin/"nexa-cli_wrapper", bin/"nexa-cli" if File.exist?(bin/"nexa-cli_wrapper")
  end

  test do
    assert_match "NexaAI CLI version", shell_output("#{bin}/nexa-cli --version")
  end
end