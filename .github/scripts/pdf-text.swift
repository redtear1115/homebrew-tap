// Prints the text layer of a PDF, so a check can tell a rendered document from a blank page.
// Run with `swift pdf-text.swift file.pdf`; PDFKit ships with macOS, so nothing to install.
import Foundation
import PDFKit

guard CommandLine.arguments.count == 2,
      let document = PDFDocument(url: URL(fileURLWithPath: CommandLine.arguments[1])) else {
    FileHandle.standardError.write(Data("usage: pdf-text.swift file.pdf (and it must open)\n".utf8))
    exit(1)
}
print(document.string ?? "")
