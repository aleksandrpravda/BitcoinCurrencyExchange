//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask

class ViewModelServicesImplTest: XCTestCase {
    func test_Getters_IsSet() {
        let navigationController = UINavigationController()
        let sut = ViewModelServicesImpl(with: navigationController)
        XCTAssertNotNil(sut.getAlertService())
        XCTAssertNotNil(sut.getCurrencyExchangeService())
        XCTAssertNotNil(sut.getNetworkService())
        XCTAssertNotNil(sut.getDataBaseService())
    }
    
    func test_push_viewmodel_WillPush_CurrencyViewController_For_CurrencyViewModel() {
        let navigationController = UINavigationController()
        let sut = ViewModelServicesImpl(with: navigationController)
        sut.push(viewModel: CurrencyViewModel(with: sut, currency: nil))
        XCTAssertNotNil(navigationController.viewControllers.last as? CurrencyViewController)
    }
    
    func test_push_viewmodel_WontPush_CurrencyViewController_For_OtherViewModels() {
        let navigationController = UINavigationController()
        let sut = ViewModelServicesImpl(with: navigationController)
        sut.push(viewModel: CurrencySelectionViewModel(with: sut))
        XCTAssertNil(navigationController.viewControllers.last)
    }
}
