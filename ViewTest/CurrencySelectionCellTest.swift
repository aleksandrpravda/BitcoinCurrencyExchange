//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class CurrencySelectionCellTest: XCTestCase {
    func test_outlets_isSet() {
        let sut = CurrencySelectionCellTest.getCurrencySelectionCell()
        XCTAssertNotNil(sut.currencyLabel)
    }
    
    func test_errorMessageLabel_lissenTo_viewModels_errorMessage() {
        let currency = Currency()
        currency.name = "N"
        let sut = CurrencySelectionCellTest.getCurrencySelectionCell(currency)
        XCTAssertEqual(sut.currencyLabel.text, "N")
    }
    
    static func getCurrencySelectionCell(_ currency: Currency = Currency()) -> CurrencySelectionCell {
        let controller = CurrencySelectionViewControllerTest.getViewController()
        let sut = controller.tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.currencySelectionCell, for: IndexPath(row: 0, section: 0)) as! CurrencySelectionCell
        sut.bind(viewModel: CurrencySelectionCellViewModelTest.getviewModel(currency))
        return sut
    }
}

