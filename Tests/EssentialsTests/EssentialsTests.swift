import XCTest
@testable import Essentials

class EssentialsTests: XCTestCase {
    func testLogger() {
        let debugLevel = Logger.Level.debug
        let warnLevel = Logger.Level.warn
        let errorLevel = Logger.Level.error
        let noneLevel = Logger.Level.none
        XCTAssertTrue(debugLevel < warnLevel)
        XCTAssertTrue(warnLevel < errorLevel)
        XCTAssertTrue(errorLevel < noneLevel)
        XCTAssertTrue(debugLevel <= warnLevel)
        XCTAssertTrue(warnLevel <= errorLevel)
        XCTAssertTrue(errorLevel <= noneLevel)
        XCTAssertTrue(warnLevel > debugLevel)
        XCTAssertTrue(errorLevel > warnLevel)
        XCTAssertTrue(noneLevel > errorLevel)
        XCTAssertTrue(warnLevel >= debugLevel)
        XCTAssertTrue(errorLevel >= warnLevel)
        XCTAssertTrue(noneLevel >= errorLevel)
    }
    
    func testRounder() {
        let test = round(14.678367, to: 3)
        XCTAssert(test == 14.678)
    }
    
    func testFileManager() {
        let fm = FileManager.default
        let desktopDirectoryUrl = fm.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let testFileUrl = desktopDirectoryUrl.appendingPathComponent("test copy.test")
        let successTestFileUrl = desktopDirectoryUrl.appendingPathComponent("test copy copy.test")
        fm.createFile(atPath: testFileUrl.path, contents: nil, attributes: nil)
        let fileUrl = try! fm.save(filename: "test copy", fileExtension: "test", to: desktopDirectoryUrl)
        XCTAssertTrue(fileUrl == successTestFileUrl)
        try! fm.removeItem(at: testFileUrl)
    }

    static var allTests : [(String, (EssentialsTests) -> () throws -> Void)] {
        return []
    }
}
