//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class ErrorCellViewModelTest: XCTestCase {
    
    func test_errorMessageShouldSendMessage() {
        let expectation = XCTestExpectation(description: "ErrorCell")
        let sut = ErrorCellViewModelTest.getviewModel("A")
        sut.errorMessage.observeNext { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result, "A")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    static func getviewModel(_ message: String) -> ErrorCellViewModel {
        let navigationController = UINavigationController()
        let services = ViewModelServicesImpl(with: navigationController)
        return ErrorCellViewModel(with: services, error: message)
    }
}
