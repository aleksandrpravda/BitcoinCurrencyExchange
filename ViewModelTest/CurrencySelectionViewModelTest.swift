//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import ReactiveKit
@testable import IdeasWorldCurrencyTestTask
@testable import RealmSwift

class CurrencySelectionViewModelTest: XCTestCase {
    
    func test_selectedIndex_willPush_currencyViewController() {
        let navigationController = UINavigationController()
        let sut = CurrencySelectionViewModelTest.getviewModel(navigationController)
        let cellSelectionViewModel = CurrencySelectionCellViewModelTest.getviewModel()
        sut.currencyData.insert(cellSelectionViewModel, at: 0)
        SafeSignal(just: IndexPath(row: 0, section: 0)).bind(to: sut.selectedIndex)
        
        XCTAssertNotNil(navigationController.viewControllers.last as? CurrencyViewController)
    }
    
    func test_reloadData_will_failOn_ReloadData() {
        let expectationFailed = XCTestExpectation(description: "Failed")
        let navigationController = UINavigationController()
        let sut = CurrencySelectionViewModelTest.getviewModel(navigationController, "", db: "testDB")
        sut.currencyData
            .filter {value in
                return value.collection.count > 0
            }
            .observeNext { _ in
            XCTAssertNotNil(navigationController.presentationController?.presentedViewController)
            XCTAssertNotNil(sut.currencyData.value.collection.first as? ErrorCellViewModel)
            expectationFailed.fulfill()
        }
//        sut.loadingIndicator
//            .filter{ !$0 }
//            .observeNext { loading in
//                XCTAssertFalse(loading)
//                XCTAssertNotNil(navigationController.presentationController?.presentedViewController)
//                XCTAssertNotNil(sut.currencyData.value.collection.first as? ErrorCellViewModel)
//                expectationFailed.fulfill()
//        }
        sut.reloadData()
        wait(for: [expectationFailed], timeout: 10.0)
    }
    
//    func test_reloadData_will_sucessOn_ReloadData() {
//        let expectationSuccess = XCTestExpectation(description: "Success")
//        let sut = CurrencySelectionViewModelTest.getviewModel()
//        sut.reloadData()
//        
//        sut.onLoadingSucceededCallback = { (result: [Currency]) -> () in
//            XCTAssertNotNil(sut.services.getDataBaseService())
//            XCTAssertEqual(sut.currencyData.value.collection.count, 22)
//            XCTAssertNotNil(result)
//            expectationSuccess.fulfill()
//        }
//        
//        wait(for: [expectationSuccess], timeout: 10.0)
//    }
    
    static func getviewModel(_ navigationController: UINavigationController = UINavigationController(), _ dataURL: String = "MockCurrenciesResponse", db identifire: String = Constants.Realm.kINMemoryIdentifier) -> CurrencySelectionViewModel {
        let configuration = Realm.Configuration(inMemoryIdentifier: identifire)
        let dbService = DataBaseServiceTest.getDatabaseServiceWithConfiguration(configuration)
        dbService.clearDataBase()
        let services = ViewModelServicesImpl(NetworkServiceTest.getNetworkService(dataURL), dbService, navigationController)
        return CurrencySelectionViewModel(with: services)
    }
}

extension ViewModelServicesImpl {
    convenience init(_ networkService: NetworkService, _ databaseService: DataBaseService, _ navigationController: UINavigationController) {
        self.init(with: navigationController)
        self.networkService = networkService
        self.databaseService = databaseService
    }
}

//class TestCurrencySelectionViewModel: CurrencySelectionViewModel {
//    var onLoadingFailedCallback: ((Error) -> ()?)? = nil
//    var onLoadingSucceededCallback: (([String: [String: Any]]) -> ()?)? = nil
//    override init(with services: ViewModelServices) {
//        super.init(with: services)
//    }
////    override internal func onLoadingFailed(_ error: Error) {
////        super.onLoadingFailed(error)
////        self.onLoadingFailedCallback?(error)
////    }
////
//    override func onLoadingSucceeded(_ currencies: [String: [String: Any]]) {
////        super.onLoadingSucceeded(currencies)
////        self.onLoadingSucceededCallback?(currencies)
////    }
//}
