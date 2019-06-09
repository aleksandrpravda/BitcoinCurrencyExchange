//
//  DataBaseServiceTest.swift
//  IdeasWorldCurrencyTestTaskTests
//
//  Created by Nick on 04/06/2019.
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import XCTest
@testable import IdeasWorldCurrencyTestTask
@testable import RealmSwift
@testable import ReactiveKit

class DataBaseServiceTest: XCTestCase {
    
    func test_update_Will_UpdateData_With_Same_Name() {
//        let expectation = XCTestExpectation(description: "UpdateData")
//        let sut = DataBaseServiceTest.getDatabaseServiceWithConfiguration()
//        sut.clearDataBase()
//        
//        let mocA = ["A": ["buy": 100]]
//        sut.update(dictionary: mocA).observeNext {_ in}
//        let mocB = ["B": ["buy": 200]]
//        sut.update(dictionary: mocB).observeNext {_ in}
        
//        sut.fetchCurrenciesSignal()
//            .observeNext { result in
//                XCTAssertNotNil(result)
//                XCTAssertEqual(result.count, 1)
//                XCTAssertEqual("A", result.last!.name)
//                XCTAssertEqual(200, result.last!.buy)
//                expectation.fulfill()
//            }.dispose(in: disposeBag)

//        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_update_WillRemove_And_AddData() {
//        let expectation = XCTestExpectation(description: "UpdateData")
//        let configuration = Realm.Configuration(inMemoryIdentifier: Constants.Realm.kINMemoryIdentifier)
//        let sut = DataBaseServiceTest.getDatabaseServiceWithConfiguration(configuration)
//        sut.clearDataBase()
//
//        let mocA = ["A": ["": ""]]
//        sut.update(dictionary: mocA).observeNext {_ in}
//        let mocB = ["B": ["": ""]]
//        sut.update(dictionary: mocB).observeNext {_ in}
        
//        sut.fetchCurrenciesSignal()
//            .observeNext { result in
//                XCTAssertEqual(result.count, 1)
//                XCTAssertFalse(result.contains{$0.name == "A"})
//                XCTAssertTrue(result.contains{$0.name == "B"})
//                expectation.fulfill()
//            }.dispose(in: disposeBag)
//
//        wait(for: [expectation], timeout: 10.0)
    }
    
    let disposeBag = DisposeBag()
    
    static func getDatabaseServiceWithConfiguration(_ configuration: Realm.Configuration = Realm.Configuration(inMemoryIdentifier: Constants.Realm.kINMemoryIdentifier)) -> DataBaseService {
        
        return DataBaseService(with: configuration)
    }
}

extension DataBaseService {
    func clearDataBase() {
        let configuration = Realm.Configuration(inMemoryIdentifier: Constants.Realm.kINMemoryIdentifier)
        let realm = try! Realm(configuration: configuration)
        let data = realm.objects(Currency.self)
        try! realm.write {
            realm.delete(data)
        }
    }
}
