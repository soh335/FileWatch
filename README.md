# FileWatch

Simple FSEvent wrapper for Swift

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
      debugPrint(event)
    }
})
```

## LICENSE

* MIT
