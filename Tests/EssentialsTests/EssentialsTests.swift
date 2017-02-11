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

    static var allTests : [(String, (EssentialsTests) -> () throws -> Void)] {
        return []
    }
}
