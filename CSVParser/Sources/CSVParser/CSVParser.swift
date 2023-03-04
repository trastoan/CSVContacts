//
//  CSVParser.swift
//
//
//  Created by Yuri on 04/03/23.
//
import Foundation

public enum CSVParserErrors: Error {
    case propertyLineNotFound
}

public struct CSVParser {
    let url: URL
    let separator: Character
    let lineBreaker: String
    let quoteCharacter: Character = "\""

    public init(url: URL, separator: Character = ",", lineBreaker: String = "\n") {
        self.url = url
        self.separator = separator
        self.lineBreaker = lineBreaker
    }

    public func decode<T: CSVDecodable>(type: T.Type) throws -> [T]  {
        let contents = try String(contentsOf: url)
        var values = [T]()
        var lines = CSVToLines(csv: contents)
        guard let propertiesLine = lines.first else { throw CSVParserErrors.propertyLineNotFound }

        lines.remove(at: 0)

        lines.forEach {
            values.append(T(from: $0, container: CSVContainer(propertiesList: propertiesLine)))
        }

        return values
    }

    func encode() throws -> Data {
        return Data()
    }

    func CSVToLines(csv: String) -> [CSVLine] {
        var lines = [CSVLine]()

        csv
            .components(separatedBy: lineBreaker)
            .enumerated()
            .forEach { index, line in
                if !line.isEmpty {
                    let info = split(line: line)
                    lines.append(CSVLine(lineNumber: index, data: info))
                }
            }

        return lines
    }

    func split(line: String) -> [String?] {
        var data = [String?]()
        var betweenQuotes = false
        var currentString = ""

        for char in line {
            switch char {
            case quoteCharacter:
                betweenQuotes = !betweenQuotes
                continue
            case separator:
                if !betweenQuotes {
                    data.append(currentString.isEmpty ? nil : currentString)
                    currentString = ""
                    continue
                }
            default:
                break
            }

            currentString.append(char)
        }

        return data
    }
}
