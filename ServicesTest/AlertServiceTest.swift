//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class AlertServiceTest: XCTestCase {
    func test_presentAlertError() {
        let expectation = XCTestExpectation(description: "CurrencyExchange")
        let navigationController = UINavigationController()
        let sut = AlertService(navigationController)
        let error = NSError(domain: "", code: 0, userInfo: ["": ""])
        
        sut.presentAlertError(error, ())
            .observeNext { _ in
            XCTAssertNotNil(navigationController.presentationController?.presentedViewController)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
