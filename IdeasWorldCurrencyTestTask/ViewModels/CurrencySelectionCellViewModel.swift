//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class CurrencySelectionCellViewModel: ViewModel {
    let currencyName = Observable<String?>("")
    private let currency: Currency
    private let services: ViewModelServices
    var currencyViewModel: CurrencyViewModel {
        get {
            return CurrencyViewModel(with: services, currency: currency)
        }
    }
    
    init(with services: ViewModelServices, currency: Currency) {
        self.currency = currency
        self.services = services
        currencyName.value = self.currency.name
    }
}
