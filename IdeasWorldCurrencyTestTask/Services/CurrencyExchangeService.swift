//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import ReactiveKit

class CurrencyExchangeService {
    init() {
    }
    
    func exchange(count: Double, by cource: Double) -> SafeSignal<Double> {
        return SafeSignal<Double> { observer in
            let result = round(count * cource * 100) / 100
            observer.next(result)
            observer.completed()
            return NonDisposable.instance
        }
    }
}
