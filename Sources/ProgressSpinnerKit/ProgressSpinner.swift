//
//  ProgressSpinner.swift
//  ProgressSpinnerKit
//
//  Created by Yutaro Muta on 2018/08/25.
//

import Foundation
import TSCBasic
import TSCUtility

private var fps: useconds_t {
    let fps: Double = 1 / 60
    return useconds_t(fps * pow(1000, 2))
}

public protocol ProgressSpinnable {
    func start()
    func stop()
}

/// A single line progress bar.
final class SingleLineProgressSpinnar: ProgressSpinnable {
    private let stream: OutputByteStream
    private let header: String
    private let isShowStopped: Bool
    private var spinner: Spinner
    private var isProgressing: Bool
    private var isClear: Bool // true if haven't drawn anything yet.
    private var displayed: Set<Int> = []

    private let queue: DispatchQueue
    private let sleepInterval: useconds_t

    init(stream: OutputByteStream, header: String, isShowStopped: Bool, spinner: Spinner) {
        self.stream = stream
        self.header = header
        self.isShowStopped = isShowStopped
        self.spinner = spinner
        self.isProgressing = false
        self.isClear = true
        self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
        self.sleepInterval = fps * 100
    }

    func start() {
        isProgressing = true

        if isClear {
            stream <<< header
            stream <<< "\n"
            stream.flush()
            isClear = false
        }

        self.stream <<< "Start..."
        self.stream <<< "\n"

        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            while self.isProgressing {
                self.stream <<< self.spinner.frame
                self.stream <<< "\n"
                self.stream.flush()

                usleep(self.sleepInterval)
            }
        }
    }

    func stop() {
        isProgressing = false
        if isShowStopped {
            stream <<< "Stop"
            stream.flush()
        }
    }
}

final class SimpleProgressSpinner: ProgressSpinnable {
    private let stream: OutputByteStream
    private let header: String
    private let isShowStopped: Bool
    private var spinner: Spinner
    private var isProgressing: Bool
    private var isClear: Bool // true if haven't drawn anything yet.

    private let queue: DispatchQueue
    private let sleepInterval: useconds_t

    init(stream: OutputByteStream, header: String, isShowStopped: Bool, spinner: Spinner) {
        self.stream = stream
        self.header = header
        self.isShowStopped = isShowStopped
        self.spinner = spinner
        self.isProgressing = false
        self.isClear = true
        self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
        self.sleepInterval = fps * 100
    }

    func start() {
        isProgressing = true

        if isClear {
            stream <<< header
            stream <<< "\n"
            stream.flush()
            isClear = false
        }

        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            while self.isProgressing {
                self.stream <<< self.spinner.frame
                self.stream <<< "\n"
                self.stream.flush()

                usleep(self.sleepInterval)
            }
        }

    }

    func stop() {
        isProgressing = false
        if isShowStopped {
            self.stream <<< "Stop"
            self.stream <<< "\n"
            self.stream.flush()
        }
    }

}

final class ProgressSpinner: ProgressSpinnable {
    private let term: TerminalController
    private let header: String
    private let isShowStopped: Bool
    private var spinner: Spinner
    private var isProgressing: Bool

    private let queue: DispatchQueue
    private let sleepInterval: useconds_t

    init(term: TerminalController, header: String, isShowStopped: Bool, spinner: Spinner) {
        self.term = term
        self.header = header
        self.isShowStopped = isShowStopped
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
        if isShowStopped {
            term.write("Stop", inColor: .green, bold: true)
        }
        term.endLine()
    }

}

/// Creates colored or simple progress spinner based on the provided output stream.
public func createProgressSpinner(forStream stderrStream: ThreadSafeOutputByteStream, header: String, isShowStopped: Bool = true, spinner: Spinner = Spinner(kind: .box1)) -> ProgressSpinnable {

    guard let stdStream = stderrStream.stream as? LocalFileOutputByteStream else {
        return SimpleProgressSpinner(stream: stderrStream.stream, header: header, isShowStopped: isShowStopped, spinner: spinner)
    }

    // If we have a terminal, use animated progress spinener.
    if let term = TerminalController(stream: stdStream) {
        return ProgressSpinner(term: term, header: header, isShowStopped: isShowStopped, spinner: spinner)
    }

    // If the terminal is dumb, use single line progress spinner.
    if TerminalController.terminalType(stdStream) == .dumb {
        return SingleLineProgressSpinnar(stream: stderrStream.stream, header: header, isShowStopped: isShowStopped, spinner: spinner)
    }

    // Use simple progress spinner by default.
    return SimpleProgressSpinner(stream: stderrStream.stream, header: header, isShowStopped: isShowStopped, spinner: spinner)
}
