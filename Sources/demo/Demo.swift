import Foundation
import ProgressSpinnerKit
import TSCBasic

@main
struct Demo {
  static func main() {
    let duration = useconds_t(Double(2.0) * pow(1000, 2))

    do {
      let defaultSpinner = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " default:"
      )
      defaultSpinner.start()
      usleep(duration)
      defaultSpinner.stop()
    }

    do {
      let box1 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box1:",
        spinner: Spinner(kind: .box1)
      )
      box1.start()
      usleep(duration)
      box1.stop()
    }

    do {
      let box2 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box2:",
        spinner: Spinner(kind: .box2)
      )
      box2.start()
      usleep(duration)
      box2.stop()
    }

    do {
      let box3 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box3:",
        spinner: Spinner(kind: .box3)
      )
      box3.start()
      usleep(duration)
      box3.stop()
    }

    do {
      let box4 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box4:",
        spinner: Spinner(kind: .box4)
      )
      box4.start()
      usleep(duration)
      box4.stop()
    }

    do {
      let box5 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box5:",
        spinner: Spinner(kind: .box5)
      )
      box5.start()
      usleep(duration)
      box5.stop()
    }

    do {
      let box6 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box6:",
        spinner: Spinner(kind: .box6)
      )
      box6.start()
      usleep(duration)
      box6.stop()
    }

    do {
      let box7 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " box7:",
        spinner: Spinner(kind: .box7)
      )
      box7.start()
      usleep(duration)
      box7.stop()
    }

    do {
      let bar1 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar1:",
        spinner: Spinner(kind: .bar1)
      )
      bar1.start()
      usleep(duration)
      bar1.stop()
    }

    do {
      let bar2 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar2:",
        spinner: Spinner(kind: .bar2)
      )
      bar2.start()
      usleep(duration)
      bar2.stop()
    }

    do {
      let bar3 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar3:",
        spinner: Spinner(kind: .bar3)
      )
      bar3.start()
      usleep(duration)
      bar3.stop()
    }

    do {
      let bar4 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar4:",
        spinner: Spinner(kind: .bar4)
      )
      bar4.start()
      usleep(duration)
      bar4.stop()
    }

    do {
      let bar5 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar5:",
        spinner: Spinner(kind: .bar5)
      )
      bar5.start()
      usleep(duration)
      bar5.stop()
    }

    do {
      let bar6 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " bar6:",
        spinner: Spinner(kind: .bar6)
      )
      bar6.start()
      usleep(duration)
      bar6.stop()
    }

    do {
      let spin1 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin1:",
        spinner: Spinner(kind: .spin1)
      )
      spin1.start()
      usleep(duration)
      spin1.stop()
    }

    do {
      let spin2 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin2:",
        spinner: Spinner(kind: .spin2)
      )
      spin2.start()
      usleep(duration)
      spin2.stop()
    }

    do {
      let spin3 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin3:",
        spinner: Spinner(kind: .spin3)
      )
      spin3.start()
      usleep(duration)
      spin3.stop()
    }

    do {
      let spin4 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin4:",
        spinner: Spinner(kind: .spin4)
      )
      spin4.start()
      usleep(duration)
      spin4.stop()
    }

    do {
      let spin5 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin5:",
        spinner: Spinner(kind: .spin5)
      )
      spin5.start()
      usleep(duration)
      spin5.stop()
    }

    do {
      let spin6 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin6:",
        spinner: Spinner(kind: .spin6)
      )
      spin6.start()
      usleep(duration)
      spin6.stop()
    }

    do {
      let spin7 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin7:",
        spinner: Spinner(kind: .spin7)
      )
      spin7.start()
      usleep(duration)
      spin7.stop()
    }

    do {
      let spin8 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin8:",
        spinner: Spinner(kind: .spin8)
      )
      spin8.start()
      usleep(duration)
      spin8.stop()
    }

    do {
      let spin9 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin9:",
        spinner: Spinner(kind: .spin9)
      )
      spin9.start()
      usleep(duration)
      spin9.stop()
    }

    do {
      let spin10 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin10:",
        spinner: Spinner(kind: .spin10)
      )
      spin10.start()
      usleep(duration)
      spin10.stop()
    }

    do {
      let spin11 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin11:",
        spinner: Spinner(kind: .spin11)
      )
      spin11.start()
      usleep(duration)
      spin11.stop()
    }

    do {
      let spin12 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin12:",
        spinner: Spinner(kind: .spin12)
      )
      spin12.start()
      usleep(duration)
      spin12.stop()
    }

    do {
      let spin13 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin13:",
        spinner: Spinner(kind: .spin13)
      )
      spin13.start()
      usleep(duration)
      spin13.stop()
    }

    do {
      let spin14 = ProgressSpinnerKit.progressSpinner(
        for: TSCBasic.stderrStream,
        header: " spin14:",
        spinner: Spinner(kind: .spin14)
      )
      spin14.start()
      usleep(duration)
      spin14.stop()
    }
  }
}
