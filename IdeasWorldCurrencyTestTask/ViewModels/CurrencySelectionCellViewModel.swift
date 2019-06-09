//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import RealmSwift

class CurrencySelectionCellViewModel: ViewModel {
    let currencyName = Observable<String?>("")
    private let currency: Currency
    private let services: ViewModelServices
    private var notificationToken = NotificationToken()
    var currencyViewModel: CurrencyViewModel {
        get {
            return CurrencyViewModel(with: services, currency: currency)
        }
    }
    
    init(with services: ViewModelServices, currency: Currency) {
        self.currency = currency
        self.services = services
        self.currencyName.value = self.currency.name
        self.notificationToken = self.currency.observe { [weak self]  objectChange in
            switch objectChange {
            case .change(let changes):
                for change in changes {
                    if change.name == Constants.NetworkKeys.kName {
                        self?.currencyName.value = change.newValue as? String
                    }
                }
                break
            case .error(_):
                break
            case .deleted:
                break
            }
        }
    }
    
    deinit {
        self.notificationToken.invalidate()
    }
}
