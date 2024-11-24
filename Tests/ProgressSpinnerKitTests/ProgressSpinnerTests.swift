//
//  ProgressSpinnerTests.swift
//  ProgressSpinnerKitTests
//
//  Created by Yutaro Muta on 2018/08/25.
//

import Foundation
import TSCLibc
import XCTest

@testable import ProgressSpinnerKit
@testable import TSCBasic

typealias Thread = TSCBasic.Thread

final class ProgressSpinnerTests: XCTestCase {

  static let allTests = [
    ("testSimpleProgresSpinner", testSimpleProgresSpinner),
    ("testProgresSpinner", testProgresSpinner),
  ]

  /// Test progress bar when writing to a non tty stream.
  func testSimpleProgresSpinner() {
    let byteStream = BufferedOutputByteStream()
    let outStream = ThreadSafeOutputByteStream(byteStream)
    let spinner = Spinner(kind: Spinner.Kind.allCases.randomElement()!)
    let headerText = "test"
    let progressSpinner = ProgressSpinnerKit.progressSpinner(
      for: outStream,
      header: headerText,
      spinner: spinner
    )
    XCTAssertTrue(progressSpinner is SimpleProgressSpinner)

    let second = Int.random(in: 0..<10)
    let duration = useconds_t(Double(second) * pow(1000, 2))
    runProgressSpinner(progressSpinner, withDuration: duration)

    let frameCount = Int(ceil(Double(duration) / Double(fps * 100)))
    var verificationSpinner = spinner
    let verificationFrames = (0..<frameCount)
      .reduce(into: "\(headerText)\n") { result, _ in
        result += "\(verificationSpinner.frame)\n"
      }
    XCTAssertEqual(byteStream.bytes.validDescription, verificationFrames)
  }

  /// Test progress bar when writing a tty stream.
  func testProgresSpinner() {
    guard let pty = PseudoTerminal() else {
      XCTFail("Couldn't create pseudo terminal.")
      return
    }
    let outStream = ThreadSafeOutputByteStream(pty.outStream)
    let spinner = Spinner(kind: Spinner.Kind.allCases.randomElement()!)
    let headerText = "TestHeader"
    let progressSpinner = ProgressSpinnerKit.progressSpinner(
      for: outStream,
      header: headerText,
      spinner: spinner
    )
    XCTAssertTrue(progressSpinner is ProgressSpinner)

    var output = ""
    let thread = Thread {
      while let out = pty.readMaster() {
        output += out
      }
    }
    thread.start()
    let second = Int.random(in: 0..<10)
    let duration: useconds_t = useconds_t(Double(second) * pow(1000, 2))
    runProgressSpinner(progressSpinner, withDuration: duration)
    pty.closeSlave()
    // Make sure to read the complete output before checking it.
    thread.join()
    pty.closeMaster()

    let chuzzledOutput = output.spm_chuzzle()!
    let prefix = "\u{1B}[2K"
    XCTAssertTrue(chuzzledOutput.hasPrefix(prefix))

    let outputFrames = String(chuzzledOutput.dropFirst(prefix.utf8.count))
      .components(separatedBy: .newlines)
      .filter { !$0.isEmpty && $0 != "\u{1B}[2K" && $0 != "\u{1b}[1A\u{1b}[2K" }

    var verificationSpinner = spinner
    let verificationFrames = (0..<outputFrames.count).map { _ in
      return "\u{1B}[32m\u{1B}[1m\(headerText)\u{1B}[0m\u{1B}[32m\(verificationSpinner.frame)\u{1B}[0m"
    }
    XCTAssertEqual(outputFrames, verificationFrames)

  }

  private var fps: useconds_t {
    let fps: Double = 1 / 60
    return useconds_t(fps * pow(1000, 2))
  }

  private func runProgressSpinner(_ spinner: ProgressSpinnable, withDuration duration: useconds_t) {
    spinner.start()
    usleep(duration)
    spinner.stop()
  }

}

private final class PseudoTerminal {
  let master: Int32
  let slave: Int32
  var outStream: LocalFileOutputByteStream

  init?() {
    var master: Int32 = 0
    var slave: Int32 = 0
    if openpty(&master, &slave, nil, nil, nil) != 0 {
      return nil
    }
    guard let outStream = try? LocalFileOutputByteStream(filePointer: fdopen(slave, "w"), closeOnDeinit: false) else {
      return nil
    }
    self.outStream = outStream
    self.master = master
    self.slave = slave
  }

  func readMaster(maxChars n: Int = 1000) -> String? {
    var buf: [CChar] = [CChar](repeating: 0, count: n)
    if read(master, &buf, n) <= 0 {
      return nil
    }
    return String(cString: buf)
  }

  func closeSlave() {
    _ = TSCLibc.close(slave)
  }

  func closeMaster() {
    _ = TSCLibc.close(master)
  }

  func close() {
    closeSlave()
    closeMaster()
  }
}
