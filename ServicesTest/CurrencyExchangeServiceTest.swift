//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class CurrencyExchangeServiceTest: XCTestCase {
    func test_currencyExchange() {
        let expectation = XCTestExpectation(description: "CurrencyExchange")
        let sut = CurrencyExchangeService()
        let expected = 15509.95
        sut.exchange(count: 12.56, by: 1234.8689)
            .observeNext { result in
                XCTAssertEqual(expected, result)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 10.0)
    }
}
