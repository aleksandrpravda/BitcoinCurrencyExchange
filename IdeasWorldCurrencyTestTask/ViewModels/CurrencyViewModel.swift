//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

class CurrencyViewModel: ViewModel {
    let bitcoinValue = Observable<String?>("")
    let currencyValue = Observable<String?>("")
    
    private var currency: Currency
    private var services: ViewModelServices
    
    
    init(with services: ViewModelServices, currency: Currency) {
        self.services = services
        self.currency = currency
        self.bindBitcoinValueToCurrencyValue()
    }
    
    func filterInputTextSignal(_ text: String?) -> SafeSignal<String> {
        return SafeSignal<String> { observer in
            guard let text = text else {
                observer.next("")
                observer.completed()
                return BlockDisposable {}
            }
            var resultString: String = text
            if text.count > Constants.kMaxKeysInBitcontTextField {
                resultString = String(text.prefix(Constants.kMaxKeysInBitcontTextField))
            }
            observer.next(resultString)
            observer.completed()
            return BlockDisposable {}
        }
    }
    
    private func bindBitcoinValueToCurrencyValue() {
        bitcoinValue.value = "1"
        bitcoinValue
            .map { value in
                guard let safeDoule: Double = Double(value!) else {
                    return 0.0
                }
                return safeDoule
            }
            .flatMapLatest { value in
                return self.services.getCurrencyExchangeService()
                    .exchange(count: value, by: self.currency.buy)
            }
            .map { value in
                return String(format: "%.2f%@", value, self.currency.symbol)
            }
            .bind(to: self.currencyValue)
    }
}
