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
  func testSimpleProgresSpinner() async {
    let byteStream = BufferedOutputByteStream()
    let outStream = ThreadSafeOutputByteStream(byteStream)
    let spinner = Spinner(kind: Spinner.Kind.allCases.randomElement()!)
    let header = "test"
    let progressSpinner = ProgressSpinnerKit.progressSpinner(
      for: outStream,
      header: header,
      spinner: spinner
    )
    XCTAssertTrue(progressSpinner is SimpleProgressSpinner)

    let frameCount = Int.random(in: 1..<10)
    let seconds = Double(frameCount) * 1 / 60

    await run(with: progressSpinner, in: .seconds(seconds))

    var _spinner = spinner
    let expectations = (0..<frameCount - 1)
      .reduce(into: "\(header)\n") { result, _ in
        result += "\(_spinner.frame)\n"
      }

    XCTAssertEqual(byteStream.bytes.validDescription, expectations)
  }

  /// Test progress bar when writing a tty stream.
  func testProgresSpinner() async {
    guard let pty = PseudoTerminal() else {
      XCTFail("Couldn't create pseudo terminal.")
      return
    }
    let outStream = ThreadSafeOutputByteStream(pty.outStream)
    let spinner = Spinner(kind: Spinner.Kind.allCases.randomElement()!)
    let header = "TestHeader"
    let progressSpinner = ProgressSpinnerKit.progressSpinner(
      for: outStream,
      header: header,
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

    let frameCount = Int.random(in: 1..<10)
    let seconds = Double(frameCount) * 1 / 60

    await run(with: progressSpinner, in: .seconds(seconds))

    pty.closeSlave()
    // Make sure to read the complete output before checking it.
    thread.join()
    pty.closeMaster()

    let chuzzledOutput = output.spm_chuzzle()!
    let prefix = "\u{1B}[2K"
    XCTAssertTrue(chuzzledOutput.hasPrefix(prefix))

    let outputs = String(chuzzledOutput.dropFirst(prefix.utf8.count))
      .components(separatedBy: .newlines)
      .filter { !$0.isEmpty && $0 != "\u{1B}[2K" && $0 != "\u{1b}[1A" && $0 != "\u{1b}[1A\u{1b}[2K" }

    var _spinner = spinner
    let expectations = (0..<outputs.count)
      .map { _ in "\u{1B}[32m\u{1B}[1m\(header)\u{1B}[0m\u{1B}[32m\(_spinner.frame)\u{1B}[0m" }

    XCTAssertEqual(outputs, expectations)
  }
}

extension ProgressSpinnerTests {
  private var fps: Double {
    1 / 60
  }

  private func run(with spinner: any ProgressSpinnable, in duration: Duration) async {
    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        await spinner.start()
      }
      group.addTask {
        try? await Task.sleep(for: duration)
      }
      defer { group.cancelAll() }
      await group.next()
    }
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
