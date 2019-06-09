//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class CurrencySelectionCellTest: XCTestCase {
    func test_outlets_isSet() {
        let viewModel = CurrencySelectionCellViewModelTest.getviewModel(nil)
        let sut = CurrencySelectionCellTest.getCurrencySelectionCell(viewModel)
        XCTAssertNotNil(sut.currencyLabel)
    }
    
    func test_errorMessageLabel_lissenTo_viewModels_errorMessage() {
        let viewModel = CurrencySelectionCellViewModelTest.getviewModel(nil)
        let sut = CurrencySelectionCellTest.getCurrencySelectionCell(viewModel)
        viewModel.currencyName.value = "N"
        XCTAssertEqual(sut.currencyLabel.text, "N")
    }
    
    static func getCurrencySelectionCell(_ viewModel: CurrencySelectionCellViewModel) -> CurrencySelectionCell {
        let controller = CurrencySelectionViewControllerTest.getViewController()
        let sut = controller.tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.currencySelectionCell, for: IndexPath(row: 0, section: 0)) as! CurrencySelectionCell
        sut.bind(viewModel: viewModel)
        return sut
    }
}

