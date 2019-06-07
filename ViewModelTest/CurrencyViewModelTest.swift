//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask
@testable import ReactiveKit

class CurrencyViewModelTest: XCTestCase {
    func test_currencyValue_SouldObserve_BitcoinChanges() {
        let expectation = XCTestExpectation(description: "CurrencyViewModelbind")
        let sut = self.getviewModel()
        SafeSignal<String> (just: "M").bind(to: sut.bitcoinValue)
        sut.currencyValue.observeNext { result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_currencyValueShoulPassNumbersOnly() {
        let expectation = XCTestExpectation(description: "CurrencyViewModelbind")
        let sut1 = self.getviewModel()
        SafeSignal<String> (just: "M").bind(to: sut1.bitcoinValue)
        sut1.currencyValue.observeNext { result in
            XCTAssertEqual("0.00", result)
            expectation.fulfill()
        }
        
        let sut2 = self.getviewModel()
        SafeSignal<String> (just: "1").bind(to: sut2.bitcoinValue)
        sut2.currencyValue.observeNext { result in
            XCTAssertNotEqual("0.00", result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_currncySouldExchenge_withBuyCourse_roundTwoSliceDigits() {
        let expectation = XCTestExpectation(description: "CurrencyViewModelbind")
        let sut = self.getviewModel(12345.64)
        SafeSignal<String> (just: "23.4").bind(to: sut.bitcoinValue)
        sut.currencyValue.observeNext { result in
            XCTAssertEqual("288887.98", result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_filterInputTextSignal_shouldNotPass_nil() {
        let expectation = XCTestExpectation(description: "CurrencyViewModelbind")
        let sut = self.getviewModel()
        sut.filterInputTextSignal(nil).observeNext { result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_filterInputTextSignal_shouldNotPass_charactersNumber_greaterThenConstValue() {
        let expectation = XCTestExpectation(description: "CurrencyViewModelbind")
        let sut = self.getviewModel()
        sut.filterInputTextSignal("qwerty").observeNext { result in
            XCTAssertLessThanOrEqual(result.count, Constants.kMaxKeysInBitcontTextField)
            XCTAssertEqual(result, "qwert")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func getviewModel(_ buyValue: Double = 543.189) ->CurrencyViewModel {
        let navigationController = UINavigationController()
        let services = ViewModelServicesImpl(with: navigationController)
        let currency = Currency()
        currency.buy = buyValue
        return CurrencyViewModel(with: services, currency: currency)
    }
}
