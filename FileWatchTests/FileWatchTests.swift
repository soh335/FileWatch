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
            let _ = try FileWatch(paths: [""], createFlag: [], runLoop: RunLoop.current, latency: 1, eventHandler: { _ in })
        } catch let e as FileWatch.Error {
            XCTAssertEqual(e, FileWatch.Error.notContainUseCFTypes)
        } catch {
            XCTFail()
        }
    }
    
    func testFileCreate() {
        let ex = self.expectation(description: "")
        let filename = String(format: "%@_%@", ProcessInfo.processInfo.globallyUniqueString, "file.txt")
        let tmpfile = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        debugPrint(tmpfile)
        
        defer {
            try! FileManager.default.removeItem(at: tmpfile)
        }
        
        let filewatch = try! FileWatch(paths: [(tmpfile.path as NSString).deletingLastPathComponent], createFlag: [.UseCFTypes, .FileEvents], runLoop: RunLoop.current, latency: 3.0, eventHandler: { event in
            if (event.path as NSString).lastPathComponent == (tmpfile.path as NSString).lastPathComponent {
                XCTAssertEqual(
                    try! String(contentsOfFile: event.path, encoding: String.Encoding.utf8),
                    try! String(contentsOfFile: tmpfile.path, encoding: String.Encoding.utf8)
                )
                XCTAssert(event.flag.contains(.ItemIsFile))
                XCTAssert(!event.flag.contains(.ItemIsDir))
                XCTAssert(event.flag.contains(.ItemCreated))
                ex.fulfill()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            try! "aaa".write(toFile: tmpfile.path, atomically: false, encoding: String.Encoding.utf8)
        })
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
}
