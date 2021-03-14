<p align="left">
  <a href="https://developer.apple.com/swift"><img alt="Swift 5.1" src="https://img.shields.io/badge/Swift-5.1-orange.svg?style=flat"/></a>
  <a href="https://swift.org/package-manager/"><img alt="Swift Package Manager" src="https://img.shields.io/badge/Swift_Package_Manager-compatible-green.svg?style=flat"/></a>
  <a href="https://github.com/yutailang0119/ProgressSpinnerKit/blob/master/LICENSE"><img alt="Lincense" src="https://img.shields.io/badge/license-MIT-black.svg?style=flat"/></a>
</p>

<p align="center"> 
<img src="./Documentation/ProgressSpinnerKit.gif">
</p>

A library to display an ActivityIndicator for CLI.  
Motivated by  

* [Swift Package Manager/Utility/ProgressBar](https://github.com/apple/swift-package-manager/blob/master/Sources/Utility/ProgressBar.swift)
* [briandowns/spinner](https://github.com/briandowns/spinner)

## A Work In Progress

ProgressSpinnerKit is still in active development.  

## Dome

![](./Documentation/Demo.gif)

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "test",
    dependencies: [
        .package(url: "https://github.com/yutailang0119/ProgressSpinnerKit", from: "0.3.0"),
    ],
    targets: [
        .target(name: "targetName", dependencies: ["ProgressSpinnerKit"]),
    ]
)

```

https://github.com/apple/swift-package-manager  

## Usege

```swift
import Basic
import ProgressSpinnerKit

let spinner = createProgressSpinner(forStream: Basic.stdoutStream, header: " Loading:")
spinner.start()
// Something on the main thread.
spinner.stop()
```

## Author

[Yutaro Muta](https://github.com/yutailang0119)
- muta.yutaro@gmail.com
- [@yutailang0119](https://twitter.com/yutailang0119)

## License

ProgressSpinnerKit is available under the MIT license. See [the LICENSE file](./LICENSE) for more info.  
This software includes the work that is distributed in the Apache License 2.0.  
