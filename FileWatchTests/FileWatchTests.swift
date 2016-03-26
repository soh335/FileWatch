import XCTest
import FileWatch

class FileWatchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitCreateFlag() {
        do {
            let _ = try FileWatch(paths: [""], createFlag: [], runLoop: NSRunLoop.currentRunLoop(), latency: 1, eventHandler: { _ in })
        } catch let e as FileWatch.Error {
            XCTAssertEqual(e, FileWatch.Error.NotContainUseCFTypes)
        } catch {
            XCTFail()
        }
    }
    
    func testFileCreate() {
        let ex = self.expectationWithDescription("")
        let filename = String(format: "%@_%@", NSProcessInfo.processInfo().globallyUniqueString, "file.txt")
        let tmpfile = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(filename)
        debugPrint(tmpfile)
        
        defer {
            try! NSFileManager.defaultManager().removeItemAtURL(tmpfile)
        }
        
        let filewatch = try! FileWatch(paths: [(tmpfile.path! as NSString).stringByDeletingLastPathComponent], createFlag: [.UseCFTypes, .FileEvents], runLoop: NSRunLoop.currentRunLoop(), latency: 3.0, eventHandler: { event in
            if (event.path as NSString).lastPathComponent == (tmpfile.path! as NSString).lastPathComponent {
                XCTAssertEqual(
                    try! NSString(contentsOfFile: event.path, encoding: NSUTF8StringEncoding),
                    try! NSString(contentsOfFile: tmpfile.path!, encoding: NSUTF8StringEncoding)
                )
                XCTAssert(event.flag.contains(.ItemIsFile))
                XCTAssert(!event.flag.contains(.ItemIsDir))
                XCTAssert(event.flag.contains(.ItemCreated))
                ex.fulfill()
            }
        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), {
            try! "aaa".writeToFile(tmpfile.path!, atomically: false, encoding: NSUTF8StringEncoding)
        })
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}
