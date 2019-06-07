//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class CurrencyViewControllerTest: XCTestCase {
    
    func test_outlets_isSet() {
        let sut = self.getViewController()
        XCTAssertNotNil(sut.currencyValueLabel)
        XCTAssertNotNil(sut.bitCoinTextField)
    }

    func test_currencyValueLaabel_lissenTo_viewModels_CurrencyValue() {
        let expectation = XCTestExpectation(description: "CurrencyViewController")
        let sut = self.getViewController()
        sut.viewModel?.currencyValue.value = "100"
        XCTAssertEqual(sut.currencyValueLabel.text, "100")
    }
    
    func test_bitcoinTextFielt_lissenTo_himself_withFilter() {
        let sut = self.getViewController()
        sut.bitCoinTextField.text = "10"
        XCTAssertEqual(sut.bitCoinTextField.text, "10")
    }
    
    func getViewController() -> CurrencyViewController {
        let storyBoard = UIStoryboard.init(name: Constants.Storyboard.kStoryboardName, bundle: nil)
        let sut = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.kCurrencyViewControllerIdentifire) as! CurrencyViewController
        sut.viewModel = getviewModel(Currency())
        _ = sut.view
        return sut
    }

    func getviewModel(_ currency: Currency, _ navigationController: UINavigationController = UINavigationController()) ->CurrencyViewModel {
        let services = ViewModelServicesImpl(with: navigationController)
        return CurrencyViewModel(with: services, currency: currency)
    }
}
