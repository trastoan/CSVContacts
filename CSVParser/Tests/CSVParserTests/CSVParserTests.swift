import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {
    func testParserThrowsErrorOnFileNotFound() throws {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            XCTFail("Invalid Path")
            return
        }

        let wrongPath = documentsPath.absoluteString + "wrong.csv"
        guard let wrongURL = URL(string: wrongPath) else {
            XCTFail("Unable to build URL")
            return
        }

        let sut = CSVParser(url: wrongURL)
        
        XCTAssertThrowsError(try sut.decode(type: Contact.self))
    }

    func testParserGivesCorrectValues() throws {
        let bundle = Bundle(for: CSVParserTests.self)
        guard let resourceURL = bundle.url(forResource: "test", withExtension: "csv") else {
            XCTFail("File not found")
            return
        }

        let sut = CSVParser(url: resourceURL)

        let contacts = try sut.decode(type: Contact.self)

        XCTAssertEqual(contacts.count, 2)
    }
}
