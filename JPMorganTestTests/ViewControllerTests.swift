//
//  ViewControllerTests.swift
//  JPMorganTest
//
//  Created by Praveen Kumar on 27/04/23.
//

import XCTest
@testable import Test

class ViewControllerTests: XCTestCase {
    
    var vc: ViewController!
    var cells: [UITableViewCell.Type] {
        return [
            PlanetTableViewCell.self
        ]
    }
    
    override func setUpWithError() throws {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateInitialViewController() as? ViewController
    }
    
    func testRegisteredCells() throws {
        UIWindow().addSubview(vc.view)
        cells.forEach { type in
            let cell = vc.tableView.dequeueReusableCell(withIdentifier: String(describing: type),
                                                        for: IndexPath(row: 0, section: 0))
            XCTAssertNotNil(cell)
        }
    }
    
    func testSearchBar() throws {
        
        UIWindow().addSubview(vc.view)
        let searchBar = try XCTUnwrap(vc.searchBar)
        searchBar.text = "x"
        vc.searchBarTextDidEndEditing(searchBar)
        vc.searchBarSearchButtonClicked(searchBar)
        XCTAssertEqual(vc.dataSource.count, 0)
        XCTAssertEqual(vc.planetsList.count, 10)
    }
    
}
