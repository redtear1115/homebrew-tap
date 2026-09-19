class Marsdawn < Formula
  desc "Render Markdown to PDF from the command line"
  homepage "https://marsdawn.southern-light.dev"
  url "https://github.com/redtear1115/mars-dawn-kit/archive/refs/tags/0.4.1.tar.gz"
  sha256 "e237502e0d4871d588b92ea91949079f75f29fbb71cfc5459ab1f6153a975fb3"
  license "Apache-2.0"
  head "https://github.com/redtear1115/mars-dawn-kit.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "marsdawn"
    # SwiftPM finds the renderer's resources (preview page, KaTeX, Mermaid) in bundles next to
    # the executable. Some Swift versions look beside a symlink rather than its target, so bin
    # gets a script that execs the real binary in libexec, where the bundles are.
    libexec.install ".build/release/marsdawn", *Dir[".build/release/*.bundle"]
    bin.write_exec_script libexec/"marsdawn"
    # The exec script only becomes executable once the install finishes, so ask the binary itself.
    generate_completions_from_executable(libexec/"marsdawn", "--generate-completion-script")
  end

  def caveats
    <<~EOS
      `marsdawn export` renders on its own and needs nothing else installed.
      `marsdawn open` hands documents to the MarsDawn app, which isn't on the
      Mac App Store yet. When it is, it will need macOS 26.
    EOS
  end

  test do
    # `brew test` runs in a sandbox that denies the Mach lookups WebKit needs to start its helper
    # processes, so exporting a PDF cannot work here, though it does outside the sandbox. This test
    # covers what can run in it: the version, argument checks and the JSON error contract.
    assert_equal version.to_s, shell_output("#{bin}/marsdawn --version").strip

    output = shell_output("#{bin}/marsdawn export missing.md --json", 2)
    assert_equal "input_not_found", JSON.parse(output)["error"]

    (testpath/"doc.md").write "# Title\n"
    (testpath/"out.pdf").write "keep"
    output = shell_output("#{bin}/marsdawn export doc.md -o out.pdf --json", 4)
    assert_equal "output_exists", JSON.parse(output)["error"]
    assert_equal "keep", (testpath/"out.pdf").read

    ENV["MARSDAWN_APP_PATH"] = testpath/"Nonexistent.app"
    output = shell_output("#{bin}/marsdawn open doc.md --json", 3)
    assert_equal "app_not_installed", JSON.parse(output)["error"]
  end
end
