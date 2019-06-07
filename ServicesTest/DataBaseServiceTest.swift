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
        let expectation = XCTestExpectation(description: "UpdateData")
        let sut = DataBaseServiceTest.getDatabaseServiceWithIdentifire(id: "test_realm_database_service")
        sut.clearDataBase()
        
        let mocA = self.createCurrencyWithName("A")
        mocA.buy = 100
        sut.update(currencies: [mocA]).observeNext {_ in}
        let mocB = self.createCurrencyWithName("A")
        mocB.buy = 200
        sut.update(currencies: [mocB]).observeNext {_ in}
        
        sut.fetchCurrenciesSignal()
            .observeNext { result in
                XCTAssertNotNil(result)
                XCTAssertEqual(result.count, 1)
                XCTAssertEqual("A", result.last!.name)
                XCTAssertEqual(200, result.last!.buy)
                expectation.fulfill()
            }.dispose(in: disposeBag)

        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_update_WillRemove_And_AddData() {
        let expectation = XCTestExpectation(description: "UpdateData")
        let sut = DataBaseServiceTest.getDatabaseServiceWithIdentifire(id: "test_realm_database_service")
        sut.clearDataBase()
        
        let mocA = self.createCurrencyWithName("A")
        sut.update(currencies: [mocA]).observeNext {_ in}
        let mocB = self.createCurrencyWithName("B")
        sut.update(currencies: [mocB]).observeNext {_ in}
        
        sut.fetchCurrenciesSignal()
            .observeNext { result in
                XCTAssertEqual(result.count, 1)
                XCTAssertFalse(result.contains{$0.name == "A"})
                XCTAssertTrue(result.contains{$0.name == "B"})
                expectation.fulfill()
            }.dispose(in: disposeBag)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func createCurrencyWithName(_ name: String) -> Currency {
        let currency = Currency()
        currency.name = name
        currency.symbol = ""
        return currency
    }
    let disposeBag = DisposeBag()
    
    static func getDatabaseServiceWithIdentifire(id: String) -> DataBaseService {
        return DataBaseService(with: id)
    }
}

extension DataBaseService {
    func clearDataBase() {
        let configuration = Realm.Configuration(inMemoryIdentifier: self.inmemoryIdentifire, deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configuration)
        let data = realm.objects(Currency.self)
        try! realm.write {
            realm.delete(data)
        }
    }
}
