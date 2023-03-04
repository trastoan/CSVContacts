//
//  CSVContainer.swift
//  
//
//  Created by Yuri on 04/03/23.
//

import Foundation

public protocol CSVDecodable: Codable {
    init(from line: CSVLine, container: CSVContainer)
}

public struct CSVContainer {
    public var propertiesList: CSVLine
    public var propertiesMap: [String?: Int] = [:]

    public init(propertiesList: CSVLine) {
        self.propertiesList = propertiesList
        propertiesList
            .data
            .enumerated()
            .forEach {
                propertiesMap[$1] = $0
            }
    }

    public func value(line: CSVLine, forKey key: String) -> String? {
        if let index = propertiesMap[key], index < line.data.count {
            return line.data[index]
        } else {
            return nil
        }
    }
}
