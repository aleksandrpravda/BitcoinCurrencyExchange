//
//  CurrencySelectionViewModelTest.swift
//  IdeasWorldCurrencyTestTaskTests
//
//  Created by Nick on 07/06/2019.
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import ReactiveKit
@testable import IdeasWorldCurrencyTestTask

class CurrencySelectionViewModelTest: XCTestCase {
    
    func test_selectedIndex_willPush_currencyViewController() {
        let navigationController = UINavigationController()
        let sut = CurrencySelectionViewModelTest.getviewModel(navigationController)
        let currency = Currency()
        let cellSelectionViewModel = CurrencySelectionCellViewModelTest.getviewModel(currency)
        sut.currencyData.insert(cellSelectionViewModel, at: 0)
        SafeSignal(just: IndexPath(row: 0, section: 0)).bind(to: sut.selectedIndex)
        
        XCTAssertNotNil(navigationController.viewControllers.last as? CurrencyViewController)
    }
    
    func test_reloadData_will_failOn_ReloadData() {
        let expectationFailed = XCTestExpectation(description: "Failed")
        let navigationController = UINavigationController()
        let sut = CurrencySelectionViewModelTest.getviewModel(navigationController, "", db: "testDB")
        sut.reloadData()
        sut.onLoadingFailedCallback = { (error: Error) -> () in
            XCTAssertNotNil(error)
            XCTAssertNotNil(navigationController.presentationController?.presentedViewController)
            XCTAssertNotNil(sut.currencyData.value.collection.first as? ErrorCellViewModel)
            expectationFailed.fulfill()
        }
        wait(for: [expectationFailed], timeout: 10.0)
    }
    
    func test_reloadData_will_sucessOn_ReloadData() {
        let expectationSuccess = XCTestExpectation(description: "Success")
        let sut = CurrencySelectionViewModelTest.getviewModel()
        sut.reloadData()
        
        sut.onLoadingSucceededCallback = { (result: [Currency]) -> () in
            XCTAssertNotNil(sut.services.getDataBaseService())
            XCTAssertEqual(sut.currencyData.value.collection.count, 22)
            XCTAssertNotNil(result)
            expectationSuccess.fulfill()
        }
        
        wait(for: [expectationSuccess], timeout: 10.0)
    }
    
    static func getviewModel(_ navigationController: UINavigationController = UINavigationController(), _ dataURL: String = "MockCurrenciesResponse", db: String = "test_realm_database_service") -> TestCurrencySelectionViewModel {
        let dbService = DataBaseServiceTest.getDatabaseServiceWithIdentifire(id: db)
        dbService.clearDataBase()
        let services = ViewModelServicesImpl(NetworkServiceTest.getNetworkService(dataURL), dbService, navigationController)
        return TestCurrencySelectionViewModel(with: services)
    }
}

extension ViewModelServicesImpl {
    convenience init(_ networkService: NetworkService, _ databaseService: DataBaseService, _ navigationController: UINavigationController) {
        self.init(with: navigationController)
        self.networkService = networkService
        self.databaseService = databaseService
    }
}

class TestCurrencySelectionViewModel: CurrencySelectionViewModel {
    var onLoadingFailedCallback: ((Error) -> ()?)? = nil
    var onLoadingSucceededCallback: (([Currency]) -> ()?)? = nil
    override init(with services: ViewModelServices) {
        super.init(with: services)
    }
    override internal func onLoadingFailed(_ error: Error) {
        super.onLoadingFailed(error)
        self.onLoadingFailedCallback?(error)
    }
    
    override func onLoadingSucceeded(_ currencies: [Currency]) {
        super.onLoadingSucceeded(currencies)
        self.onLoadingSucceededCallback?(currencies)
    }
}
