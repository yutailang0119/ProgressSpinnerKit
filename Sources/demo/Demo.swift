import Foundation
import ProgressSpinnerKit
import TSCBasic

@main
struct Demo {
  static func main() async {
    func run(with spinner: any ProgressSpinnable) async {
      await withTaskGroup(of: Void.self) { group in
        group.addTask {
          await spinner.start()
        }
        group.addTask {
          try? await Task.sleep(for: .seconds(2.0))
        }
        defer { group.cancelAll() }
        await group.next()
      }
    }

    let duration = useconds_t(Double(2.0) * pow(1000, 2))

    do {
      let defaultSpinner = ProgressSpinnerKit.progressSpinner(for: TSCBasic.stderrStream, header: " default:")
      await run(with: defaultSpinner)
    }

    do {
      let box1 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box1:",
        spinner: Spinner(kind: .box1)
      )
      await run(with: box1)
    }

    do {
      let box2 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box2:",
        spinner: Spinner(kind: .box2)
      )
      await run(with: box2)
    }

    do {
      let box3 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box3:",
        spinner: Spinner(kind: .box3)
      )
      await run(with: box3)
    }

    do {
      let box4 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box4:",
        spinner: Spinner(kind: .box4)
      )
      await run(with: box4)
    }

    do {
      let box5 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box5:",
        spinner: Spinner(kind: .box5)
      )
      await run(with: box5)
    }

    do {
      let box6 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box6:",
        spinner: Spinner(kind: .box6)
      )
      await run(with: box6)
    }

    do {
      let box7 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box7:",
        spinner: Spinner(kind: .box7)
      )
      await run(with: box7)
    }

    do {
      let bar1 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar1:",
        spinner: Spinner(kind: .bar1)
      )
      await run(with: bar1)
    }

    do {
      let bar2 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar2:",
        spinner: Spinner(kind: .bar2)
      )
      await run(with: bar2)
    }

    do {
      let bar3 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar3:",
        spinner: Spinner(kind: .bar3)
      )
      await run(with: bar3)
    }

    do {
      let bar4 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar4:",
        spinner: Spinner(kind: .bar4)
      )
      await run(with: bar4)
    }

    do {
      let bar5 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar5:",
        spinner: Spinner(kind: .bar5)
      )
      await run(with: bar5)
    }

    do {
      let bar6 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar6:",
        spinner: Spinner(kind: .bar6)
      )
      await run(with: bar6)
    }

    do {
      let spin1 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin1:",
        spinner: Spinner(kind: .spin1)
      )
      await run(with: spin1)
    }

    do {
      let spin2 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin2:",
        spinner: Spinner(kind: .spin2)
      )
      await run(with: spin2)
    }

    do {
      let spin3 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin3:",
        spinner: Spinner(kind: .spin3)
      )
      await run(with: spin3)
    }

    do {
      let spin4 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin4:",
        spinner: Spinner(kind: .spin4)
      )
      await run(with: spin4)
    }

    do {
      let spin5 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin5:",
        spinner: Spinner(kind: .spin5)
      )
      await run(with: spin5)
    }

    do {
      let spin6 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin6:",
        spinner: Spinner(kind: .spin6)
      )
      await run(with: spin6)
    }

    do {
      let spin7 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin7:",
        spinner: Spinner(kind: .spin7)
      )
      await run(with: spin7)
    }

    do {
      let spin8 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin8:",
        spinner: Spinner(kind: .spin8)
      )
      await run(with: spin8)
    }

    do {
      let spin9 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin9:",
        spinner: Spinner(kind: .spin9)
      )
      await run(with: spin9)
    }

    do {
      let spin10 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin10:",
        spinner: Spinner(kind: .spin10)
      )
      await run(with: spin10)
    }

    do {
      let spin11 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin11:",
        spinner: Spinner(kind: .spin11)
      )
      await run(with: spin11)
    }

    do {
      let spin12 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin12:",
        spinner: Spinner(kind: .spin12)
      )
      await run(with: spin12)
    }

    do {
      let spin13 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin13:",
        spinner: Spinner(kind: .spin13)
      )
      await run(with: spin13)
    }

    do {
      let spin14 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin14:",
        spinner: Spinner(kind: .spin14)
      )
      await run(with: spin14)
    }
  }
}
