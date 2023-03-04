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
        let url = URL(fileURLWithPath: #file)
        let directory = url.deletingLastPathComponent()
        let res = directory.appendingPathComponent("Resources")
        let resourceURL = res.appendingPathComponent("test.csv")
        print(resourceURL.absoluteString)

        let sut = CSVParser(url: resourceURL, lineBreaker: "\r\n")

        let contacts = try sut.decode(type: Contact.self)

        XCTAssertEqual(contacts.count, 2)

        let firstContact = contacts[0]
        XCTAssertEqual(firstContact.name, "John")
        XCTAssertEqual(firstContact.address, "Some Street,Somewhere,Some Country")
        XCTAssertEqual(firstContact.company, "The Company")
        XCTAssertEqual(firstContact.phone, "213-133-218")

        let secondContact = contacts[1]
        XCTAssertEqual(secondContact.name, "Mary App")
        XCTAssertEqual(secondContact.address, "")
        XCTAssertEqual(secondContact.company, "Opsy")
        XCTAssertEqual(secondContact.phone, "504-845-1427")
    }

    func testValueForLineReturnsNilWhenNoDataIsPresent() throws {
        let propertiesLine = CSVLine(lineNumber: 0, data: ["phone", "name"])
        let lineWithNil = CSVLine(lineNumber: 1, data: ["230-232-1231", nil])

        let sut = CSVContainer(propertiesList: propertiesLine)

        XCTAssertNil(sut.value(line: lineWithNil, forKey: "name"))
        XCTAssertEqual(sut.value(line: lineWithNil, forKey: "phone"), "230-232-1231")
    }

    func testValueForPropertyNotOnLineWillReturnNil() throws {
        let propertiesLine = CSVLine(lineNumber: 0, data: ["phone", "name", "country"])
        let lineWithNil = CSVLine(lineNumber: 1, data: ["230-232-1231", nil])

        let sut = CSVContainer(propertiesList: propertiesLine)
        XCTAssertNil(sut.value(line: lineWithNil, forKey: "country"))
    }
}
