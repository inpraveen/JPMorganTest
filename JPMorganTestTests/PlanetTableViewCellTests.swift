//
//  PlanetTableViewCellTests.swift
//  JPMorganTest
//
//  Created by Praveen Kumar on 27/04/23.
//

import XCTest
@testable import Test

class PlanetTableViewCellTests: XCTestCase {

    func testconfigureLabelText() throws {
        let cell = PlanetTableViewCell()
        let text = "Earth"
        cell.configureLabelText(text: text)
        XCTAssertNotNil(cell.label)
        XCTAssertEqual(cell.label.text, text)
    }

}
