//
//  ProgressSpinner.swift
//  ProgressSpinnerKit
//
//  Created by Yutaro Muta on 2018/08/25.
//

import Foundation
import TSCBasic
import TSCUtility

private var fps: Double {
  1 / 60
}

public protocol ProgressSpinnable {
  func start() async
}

/// A single line progress bar.
final class SingleLineProgressSpinner: ProgressSpinnable {
  private let stream: OutputByteStream
  private let header: String
  private var spinner: Spinner

  init(stream: OutputByteStream, header: String, spinner: Spinner) {
    self.stream = stream
    self.header = header
    self.spinner = spinner
  }

  func start() async {
    stream.send(header)
    stream.send("\n")
    stream.flush()

    let timer = AsyncStream {
      try? await Task.sleep(for: .seconds(fps))
    }

    for await _ in timer {
      if !Task.isCancelled {
        stream.send(spinner.frame)
        stream.send("\n")
        stream.flush()
      }
    }
  }
}

final class SimpleProgressSpinner: ProgressSpinnable {
  private let stream: OutputByteStream
  private let header: String
  private var spinner: Spinner

  init(stream: OutputByteStream, header: String, spinner: Spinner) {
    self.stream = stream
    self.header = header
    self.spinner = spinner
  }

  func start() async {
    stream.send(header)
    stream.send("\n")
    stream.flush()

    let timer = AsyncStream {
      try? await Task.sleep(for: .seconds(fps))
    }

    for await _ in timer {
      if !Task.isCancelled {
        stream.send(spinner.frame)
        stream.send("\n")
        stream.flush()
      }
    }
  }
}

final class ProgressSpinner: ProgressSpinnable {
  private let term: TerminalController
  private let header: String
  private var spinner: Spinner
  private var isProgressing: Bool

  private let queue: DispatchQueue
  private let sleepInterval: useconds_t

  init(term: TerminalController, header: String, spinner: Spinner) {
    self.term = term
    self.header = header
    self.spinner = spinner
    self.isProgressing = false
    self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
    self.sleepInterval = fps
  }

  func start() {
    isProgressing = true

    queue.async { [weak self] in
      guard let self = self else {
        return
      }
      while self.isProgressing {
        self.term.clearLine()
        self.term.write(self.header, inColor: .green, bold: true)
        self.term.write(self.spinner.frame, inColor: .green)
        self.term.endLine()

        self.term.moveCursor(up: 1)

        usleep(self.sleepInterval)
      }
    }

  }

  func stop() {
    isProgressing = false
    term.clearLine()
    term.endLine()
  }

}

/// Creates colored or simple progress spinner based on the provided output stream.
public func progressSpinner(
  for stderrStream: ThreadSafeOutputByteStream,
  header: String,
  spinner: Spinner = Spinner(kind: .box1)
) -> ProgressSpinnable {

  guard let stdStream = stderrStream.stream as? LocalFileOutputByteStream else {
    return SimpleProgressSpinner(
      stream: stderrStream.stream,
      header: header,
      spinner: spinner
    )
  }

  // If we have a terminal, use animated progress spinener.
  if let term = TerminalController(stream: stdStream) {
    return ProgressSpinner(term: term, header: header, spinner: spinner)
  }

  // If the terminal is dumb, use single line progress spinner.
  if TerminalController.terminalType(stdStream) == .dumb {
    return SingleLineProgressSpinner(
      stream: stderrStream.stream,
      header: header,
      spinner: spinner
    )
  }

  // Use simple progress spinner by default.
  return SimpleProgressSpinner(
    stream: stderrStream.stream,
    header: header,
    spinner: spinner
  )
}
