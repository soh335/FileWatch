[![Build Status](https://travis-ci.org/soh335/FileWatch.svg?branch=master)](https://travis-ci.org/soh335/FileWatch)

# FileWatch

Simple FSEvents wrapper for Swift

## INSTALL

### CARTHAGE

* Add ```github "soh335/FileWatch" "master"``` to your Cartfile.
* Run ```carthage update```.
* Add FileWatch.framework to Embedded Binaries.

## USAGE

```swift
import FileWatch

let filewatch = try! FileWatch(paths: ["/path/to/dir"],  createFlag: [.UseCFTypes, .FileEvents], runLoop: NSRunLoop.currentRunLoop(), latency: 3.0, eventHandler: { event in
    if event.flag.contains(.ItemIsFile) {
      debugPrint(event.path)
    }
})
```

## LICENSE

* MIT
