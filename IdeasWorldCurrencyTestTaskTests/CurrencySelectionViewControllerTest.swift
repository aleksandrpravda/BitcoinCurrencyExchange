//
//  CurrencySelectionViewControllerTest.swift
//  IdeasWorldCurrencyTestTaskTests
//
//  Created by Nick on 30/05/2019.
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import ReactiveKit
@testable import IdeasWorldCurrencyTestTask

class CurrencySelectionViewControllerTest: XCTestCase {
    
    func test_outlets_isSet() {
        let sut = CurrencySelectionViewControllerTest.getViewController()
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.tableView.refreshControl)
    }
    
    func test_tableView_shouldReloadData_on_ValueChanged() {
        let sut = CurrencySelectionViewControllerTest.getViewController()
        
        let currency = Currency()
        let cellSelectionViewModel = CurrencySelectionCellViewModelTest.getviewModel(currency)
        sut.viewModel?.currencyData.insert(cellSelectionViewModel, at: 0)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        
        let errorViewModel = ErrorCellViewModelTest.getviewModel("M")
        sut.viewModel?.currencyData.insert(errorViewModel, at: 1)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
        
        XCTAssertNotNil(sut.tableView.refreshControl)
    }
    
//    func test_tableViewCellSelection_willChange_viewModelsSelectedIndex_if_NotRefreshing() {
//        let expectation = XCTestExpectation(description: "tableViewCellSelection")
//        let sut = CurrencySelectionViewControllerTest.getViewController()
//        let currency = Currency()
//        let cellSelectionViewModel = CurrencySelectionCellViewModelTest.getviewModel(currency)
//        sut.tableView.allowsSelection = true
//        sut.viewModel?.currencyData.insert(cellSelectionViewModel, at: 0)
//        sut.viewModel?.selectedIndex.observeNext{ value in
//            XCTAssertEqual(value.row, 0)
//            XCTAssertEqual(value.section, 0)
//            expectation.fulfill()
//        }
//        sut.tableView.delegate!.tableView!(sut.tableView, willSelectRowAt: IndexPath(row: 0, section: 0))
//        sut.tableView.delegate!.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
//        
//        wait(for: [expectation], timeout: 10.0)
//    }
    
    static func getViewController() -> CurrencySelectionViewController {
        let storyBoard = UIStoryboard.init(name: Constants.Storyboard.kStoryboardName, bundle: nil)
        let sut = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.kCurrencySelectionViewControllerIdentifire) as! CurrencySelectionViewController
        sut.viewModel = CurrencySelectionViewModelTest.getviewModel()
        _ = sut.view
        return sut
    }
}
