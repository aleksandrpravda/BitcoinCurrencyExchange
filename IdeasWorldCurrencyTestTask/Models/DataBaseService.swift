//  
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import RealmSwift
import ReactiveKit
import Bond

class DataBaseService {
    let dataObserver = MutableObservableArray<[Currency]>()
//    internal let inmemoryIdentifire: String
    private var notificationToken: NotificationToken?
    private let configuration: Realm.Configuration
    
    init(with configuration: Realm.Configuration) {
//        self.inmemoryIdentifire = inmemoryIdentifire
        self.configuration = configuration
    }
    
    func getResults() -> Signal<[Currency], Error> {
        return Signal<[Currency], Error> { [unowned self] observer in
            do {
                self.notificationToken?.invalidate()
                let realm = try Realm(configuration: self.configuration)
                let results = realm.objects(Currency.self).sorted(byKeyPath: Constants.NetworkKeys.kName)
                self.notificationToken = results.observe { changes in
                    switch changes {
                    case .initial(let results):
                        let currencies = Array(results)
                        observer.next(currencies)
                        print("DataBaseService:getResults():initial")
                    case .update(let value):
                        let currencies = Array(value.0)
                        observer.next(currencies)
                        observer.completed()
                        print("DataBaseService:getResults():update")
                    case .error(let error):
                        print("DataBaseService:getResults():update")
                        observer.failed(error)
                    }
                }
            }
            catch let error {
                observer.failed(error)
            }
            return NonDisposable.instance
        }
    }
    
    func update(dictionary: [String: [String: Any]]) -> Signal<Void, Error> {
        return Signal<Void, Error> {[unowned self] observer in
            DispatchQueue(label: "background").async {
                autoreleasepool {
                    do {
                        let realm = try Realm(configuration: self.configuration)
                        let results = realm.objects(Currency.self).sorted(byKeyPath: Constants.NetworkKeys.kName)
                        let existingCurrencies = Array(results)
                        let currencies = self.parseCurrencies(dictionary)
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
                }
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
    
    private func parseCurrencies(_ dictionary: [String: [String: Any]]) -> [Currency] {
        var currencies = [Currency]()
        for (key, value) in dictionary {
            let currency = self.parseCurrency(name: key, value)
            currencies.append(currency)
        }
        return currencies
    }
    
    private func parseCurrency(name: String, _ dictionary: [String: Any]) -> Currency {
        let currency = Currency()
        currency.name = name
        currency.buy = dictionary[Constants.NetworkKeys.kBuy] as? Double ?? 0.0
        currency.fifteenM = dictionary[Constants.NetworkKeys.kFifteenM] as? Double ?? 0.0
        currency.last = dictionary[Constants.NetworkKeys.kLast] as? Double ?? 0.0
        currency.symbol = dictionary[Constants.NetworkKeys.kSymbol] as? String ?? ""
        currency.sell = dictionary[Constants.NetworkKeys.kSell] as? Double ?? 0.0
        return currency
    }
    deinit {
        self.notificationToken?.invalidate()
    }
}
