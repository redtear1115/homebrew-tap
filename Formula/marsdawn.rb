class Marsdawn < Formula
  desc "Render Markdown to PDF, and open documents in MarsDawn"
  homepage "https://marsdawn.southern-light.dev"
  url "https://github.com/redtear1115/mars-dawn-kit/archive/refs/tags/0.3.0.tar.gz"
  sha256 "2c6155611a21304cd994e5bb3b7c0d4c34e201d99f647296e7a61412751bef10"
  license "Apache-2.0"
  head "https://github.com/redtear1115/mars-dawn-kit.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "marsdawn"
    # SwiftPM finds the renderer's resources (preview page, KaTeX, Mermaid) in bundles next to
    # the executable, so they are installed together and bin gets a symlink.
    libexec.install ".build/release/marsdawn", *Dir[".build/release/*.bundle"]
    bin.install_symlink libexec/"marsdawn"
    generate_completions_from_executable(bin/"marsdawn", "--generate-completion-script")
  end

  def caveats
    <<~EOS
      `marsdawn export` renders on its own and needs nothing else installed.
      `marsdawn open` hands documents to the MarsDawn app, which ships through
      the Mac App Store and needs macOS 26.
    EOS
  end

  test do
    (testpath/"doc.md").write <<~MARKDOWN
      # Title

      Text with `code`, a list:

      - one
      - two
    MARKDOWN

    # The renderer keeps its compiled content-blocking rules under ~/Library/WebKit. The test
    # sandbox denies reads of the real home folder, so point the store at the test folder.
    ENV["CFFIXED_USER_HOME"] = testpath
    output = shell_output("#{bin}/marsdawn export doc.md -o out.pdf --json")
    result = JSON.parse(output)
    assert_equal true, result["ok"]
    assert_operator result["pages"].to_i, :>=, 1

    assert_path_exists testpath/"out.pdf"
    assert_operator (testpath/"out.pdf").size, :>, 1_000
    assert_equal "%PDF-", (testpath/"out.pdf").read(5)

    assert_equal version.to_s, shell_output("#{bin}/marsdawn --version").strip
  end
end
