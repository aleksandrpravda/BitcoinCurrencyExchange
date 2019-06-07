//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class ErrorCellTest: XCTestCase {
    
    func test_outlets_isSet() {
        let sut = ErrorCellTest.getErrorCell()
        XCTAssertNotNil(sut.errorMessageLabel)
    }
    
    func test_errorMessageLabel_lissenTo_viewModels_errorMessage() {
        let sut = ErrorCellTest.getErrorCell("M")
        XCTAssertEqual(sut.errorMessageLabel.text, "M")
    }
    
    static func getErrorCell(_ message: String = "") -> ErrorCell {
        let controller = CurrencySelectionViewControllerTest.getViewController()
        let sut = controller.tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.errorCell, for: IndexPath(row: 0, section: 0)) as! ErrorCell
        sut.bind(viewModel: ErrorCellViewModelTest.getviewModel(message))
        return sut
    }
}
