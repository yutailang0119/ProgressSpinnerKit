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
  private var isProgressing: Bool
  private var isClear: Bool  // true if haven't drawn anything yet.
  private var displayed: Set<Int> = []

  private let queue: DispatchQueue
  private let sleepInterval: useconds_t

  init(stream: OutputByteStream, header: String, spinner: Spinner) {
    self.stream = stream
    self.header = header
    self.spinner = spinner
    self.isProgressing = false
    self.isClear = true
    self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
    self.sleepInterval = fps * 100
  }

  func start() {
    isProgressing = true

    if isClear {
      stream.send(header)
      stream.send("\n")
      stream.flush()
      isClear = false
    }

    queue.async { [weak self] in
      guard let self = self else {
        return
      }
      while self.isProgressing {
        self.stream.send(self.spinner.frame)
        self.stream.send("\n")
        self.stream.flush()

        usleep(self.sleepInterval)
      }
    }
  }

  func stop() {
    isProgressing = false
  }
}

final class SimpleProgressSpinner: ProgressSpinnable {
  private let stream: OutputByteStream
  private let header: String
  private var spinner: Spinner
  private var isProgressing: Bool
  private var isClear: Bool  // true if haven't drawn anything yet.

  private let queue: DispatchQueue
  private let sleepInterval: useconds_t

  init(stream: OutputByteStream, header: String, spinner: Spinner) {
    self.stream = stream
    self.header = header
    self.spinner = spinner
    self.isProgressing = false
    self.isClear = true
    self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
    self.sleepInterval = fps * 100
  }

  func start() {
    isProgressing = true

    if isClear {
      stream.send(header)
      stream.send("\n")
      stream.flush()
      isClear = false
    }

    queue.async { [weak self] in
      guard let self = self else {
        return
      }
      while self.isProgressing {
        self.stream.send(self.spinner.frame)
        self.stream.send("\n")
        self.stream.flush()

        usleep(self.sleepInterval)
      }
    }

  }

  func stop() {
    isProgressing = false
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
