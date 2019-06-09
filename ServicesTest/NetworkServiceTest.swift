//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask
@testable import Alamofire
@testable import ReactiveKit

class NetworkServiceTest: XCTestCase {
    let disposeBag = DisposeBag()
    
    func test_LoadCurrenciesSignal_PerformeFailOn_InternetConnectionNotReachable() {
        let expectation = XCTestExpectation(description: "Load Currencies")
        let errorDescription = NSLocalizedString("Internet Connection Not Reachable", comment: "")
        let sut = NetworkServiceTest.getNetworkService("MockCurrenciesResponse")
        sut.isReachable = false
        _ = sut.loadCurrencies().observeNext { result in
                switch result {
                case .loading:
                    XCTAssert(true)
                case .failed(let error):
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error.localizedDescription, errorDescription)
                    expectation.fulfill()
                case .loaded(let value):
                    XCTAssertNil(value)
                    expectation.fulfill()
                }
            }
            .dispose(in: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_LoadCurrecies_Signal_PerformeFail_onConnectionError() {
        let expectation = XCTestExpectation(description: "Load Currencies")
        let sut = NetworkServiceTest.getNetworkService("")
        _ = sut.loadCurrencies().observeNext { result in
                switch result {
                case .loading:
                    XCTAssert(true)
                case .failed(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                case .loaded(let value):
                    XCTAssertNil(value)
                    expectation.fulfill()
                }
            }
            .dispose(in: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_LoadCurrencies_WithInvalidJSONFormat_WillFail() {
        let expectation = XCTestExpectation(description: "Load Currencies")
        let dataResponseError = NSLocalizedString("Data Response error", comment: "")
        let sut = NetworkServiceTest.getNetworkService("InvalidResponse")
        _ = sut.loadCurrencies().observeNext { result in
                switch result {
                case .loading:
                    XCTAssert(true)
                case .failed(let error):
                    XCTAssertNotNil(error)
                    XCTAssertEqual(dataResponseError, error.localizedDescription)
                    expectation.fulfill()
                case .loaded(let value):
                    XCTAssertNil(value)
                    expectation.fulfill()
                }
            }
            .dispose(in: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_LoadCurrencies_WithErrorDomain_WillFail() {
        let expectation = XCTestExpectation(description: "Load Currencies")
        let errorDomain = NSLocalizedString("URL is not valid: ", comment: "")
        let sut = NetworkServiceTest.getNetworkService(nil)
        _ = sut.loadCurrencies().observeNext { result in
                switch result {
                case .loading:
                    XCTAssert(true)
                case .failed(let error):
                    XCTAssertNotNil(error)
                    XCTAssertEqual(errorDomain, error.localizedDescription)
                    expectation.fulfill()
                case .loaded(let value):
                    XCTAssertNil(value)
                    expectation.fulfill()
                }
            }
            .dispose(in: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }
    
//    func test_LoadCurrencies_WithWrongPropertiesType_WillGetDefaultValues() {
//        let expectation = XCTestExpectation(description: "Load Currencies")
//        let sut = NetworkServiceTest.getNetworkService("WrongPropertiesTypeResponse")
//        _ = sut.loadCurrencies().observeNext { result in
//                switch result {
//                case .loading:
//                    XCTAssert(true)
//                case .failed(let error):
//                    XCTAssertNil(error)
//                    expectation.fulfill()
//                case .loaded(let value):
//                    XCTAssertNotNil(value)
//                    XCTAssertEqual(value.first!.value[Constants.NetworkKeys.kBuy] as! Double
//                        , 0.0)
//                    XCTAssertEqual(value.first!.value[Constants.NetworkKeys.kFifteenM] as! Double
//                        , 0.0)
//                    XCTAssertEqual(value.first!.value[Constants.NetworkKeys.kLast] as! Double
//                        , 0.0)
//                    XCTAssertEqual(value.first!.value[Constants.NetworkKeys.kSymbol] as! String
//                        , "")
//                    XCTAssertEqual(value.first!.value[Constants.NetworkKeys.kSell] as! Double
//                        , 0.0)
//                    expectation.fulfill()
//                }
//            }
//            .dispose(in: disposeBag)
//        wait(for: [expectation], timeout: 10.0)
//    }

    func createMockCurrency(name: String, symbol: String, buy: Double, fifteenM: Double, last: Double, sell: Double) -> Currency {
        let currency = Currency()
        currency.buy = buy
        currency.last = last
        currency.fifteenM = fifteenM
        currency.name = name
        currency.sell = sell
        currency.symbol = symbol
        return currency
    }
    
    func loadJsonFrom(fileName: String) -> [String: [String: Any]] {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let jsonResult: [String: [String: Any]] = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String: [String: Any]]
        return jsonResult
    }
    
    static func getNetworkService(_ mocResponseName: String?) -> NetworkService {
        guard let mocResponseName = mocResponseName else {
            return NetworkService(with: "")
        }
        let urlString = Bundle.main.url(forResource: mocResponseName, withExtension: "json")?.absoluteString
        return NetworkService(with: urlString!)
    }
}
