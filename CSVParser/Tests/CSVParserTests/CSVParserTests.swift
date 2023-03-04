import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {
    func testParseThrowsErrorOnFileNotFound() throws {
        guard let wrongPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            XCTFail()
            return
        }
        let sut = CSVParser(url: wrongPath)
    }
}
