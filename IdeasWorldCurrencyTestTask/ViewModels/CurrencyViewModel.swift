//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import RealmSwift

class CurrencyViewModel: ViewModel {
    let bitcoinValue = Observable<String?>("")
    let currencyValue = Observable<String?>("")
    let symbolValue = Observable<String?>("")
    let buyValue = Observable<Double?>(0.0)
    private var notificationToken: NotificationToken?
    
    private var currency: Currency?
    private var services: ViewModelServices
    
    
    init(with services: ViewModelServices, currency: Currency?) {
        self.services = services
        self.currency = currency
        self.buyValue.value = currency?.buy
        self.symbolValue.value = currency?.symbol
        self.notificationToken = self.currency?.observe { [weak self] objectChange in
            switch objectChange {
            case .change(let changes):
                for change in changes {
                    if change.name == Constants.NetworkKeys.kBuy {
                        self?.buyValue.value = change.newValue as? Double
                    } else if change.name == Constants.NetworkKeys.kSymbol {
                        self?.symbolValue.value = change.newValue as? String
                    }
                }
                break
            case .error(_):
                break
            case .deleted:
                break
            }
        }
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
            .flatMapLatest { [unowned self] value in
                return self.services.getCurrencyExchangeService()
                    .exchange(count: value, by: self.buyValue.value ?? 0)
            }
            .map { [unowned self] value in
                return String(format: "%.2f%@", value, self.currency?.symbol ?? "")
            }
            .bind(to: self.currencyValue)
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
}
