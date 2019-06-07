//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import ReactiveKit
@testable import IdeasWorldCurrencyTestTask

class CurrencySelectionCellViewModelTest: XCTestCase {
    func test_currencyValue_ShoulNotBeNil() {
        let sut = CurrencySelectionCellViewModelTest.getviewModel(Currency())
        XCTAssertNotNil(sut.currencyViewModel)
    }
    
    func test_currencyName_perform_signal_on_valueSet() {
        let sut = CurrencySelectionCellViewModelTest.getviewModel(Currency())
        let expectation = XCTestExpectation(description: "CurrencyViewModelbind")
        SafeSignal<String> (just: "M").bind(to: sut.currencyName)
        sut.currencyName.observeNext { result in
            XCTAssertNotNil(result)
            XCTAssertEqual("M", result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    static func getviewModel(_ currency: Currency, _ navigationController: UINavigationController = UINavigationController()) ->CurrencySelectionCellViewModel {
        let services = ViewModelServicesImpl(with: navigationController)
        return CurrencySelectionCellViewModel(with: services, currency: currency)
    }
}
