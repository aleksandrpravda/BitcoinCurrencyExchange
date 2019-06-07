//  
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import RealmSwift
import ReactiveKit

class DataBaseService {
    internal let inmemoryIdentifire: String
    
    init(with inmemoryIdentifire: String) {
        self.inmemoryIdentifire = inmemoryIdentifire
    }
    
    internal func realm() throws -> Realm {
        let configuration = Realm.Configuration(inMemoryIdentifier: self.inmemoryIdentifire, deleteRealmIfMigrationNeeded: true)
        return try Realm(configuration: configuration)
    }
    
    func fetchCurrenciesSignal() -> Signal<[Currency], Error> {
        return Signal<[Currency], Error> { observer in
            do {
                let realm = try self.realm()
                let currencies = Array(realm.objects(Currency.self).sorted(byKeyPath: Constants.NetworkKeys.kName))
                observer.next(currencies)
                observer.completed()
            }
            catch let error {
                observer.failed(error)
            }
            return NonDisposable.instance
        }
    }
    
    func update(currencies: [Currency]) -> Signal<Void, Error> {
        return Signal<Void, Error> { observer in
            do {
                let realm = try self.realm()
                let inMemoryResults = realm.objects(Currency.self)
                let existingCurrencies = Array(inMemoryResults)
                let currencyToUpdate = self.contain(array: existingCurrencies, in: currencies)
                let currenciesToDelete = self.notContain(array: existingCurrencies, in: currencies)
                let currenciesToAdding = self.notContain(array: currencies, in: existingCurrencies)
                try realm.write {
                    realm.add(currenciesToAdding)
                    realm.delete(currenciesToDelete)
                    _ = currencyToUpdate.map { currency in
                        currencies.map { newCurrency in
                            if (currency.name == newCurrency.name) {
                                self.update(old: currency, with: newCurrency)
                            }
                        }
                    }
                    observer.next()
                    observer.completed()
                }
            }
            catch let error {
                observer.failed(error)
            }
            return NonDisposable.instance
        }
    }
    
    private func update(old currency: Currency, with newCurrency: Currency) {
        currency.name = newCurrency.name
        currency.buy = newCurrency.buy
        currency.fifteenM = newCurrency.fifteenM
        currency.last = newCurrency.last
        currency.sell = newCurrency.sell
        currency.symbol = newCurrency.symbol
    }
    
    private func notContain(array first: [Currency], in second: [Currency]) -> [Currency] {
        return first.filter { firstElement in
            return !second.contains { secondElement in
                return firstElement.name == secondElement.name
            }
        }
    }
    
    private func contain(array first: [Currency], in second: [Currency]) -> [Currency] {
        return first.filter { firstElement in
            return second.contains { secondElement in
                return firstElement.name == secondElement.name
            }
        }
    }
}
