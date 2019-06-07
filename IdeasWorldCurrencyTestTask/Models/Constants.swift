//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation

struct Constants {
    static let kMaxKeysInBitcontTextField = 5
    struct Realm {
        static let kINMemoryIdentifier = "realm-currency-collection"
    }
    struct Storyboard {
        static let kStoryboardName = "Main"
        static let kCurrencyViewControllerIdentifire = "CurrencyViewControllerIdentifire"
        static let kCurrencySelectionViewControllerIdentifire = "CurrencySelectionViewControllerIdentifire"
    }
    struct CellIdentifiers {
        static let currencySelectionCell = "CurrencySelectionCell"
        static let errorCell = "errorCell"
    }
    static let kBlockchainURL = "https://blockchain.info/ticker"
    struct NetworkKeys {
        static let kName = "name"
        static let kBuy = "buy"
        static let kFifteenM = "15m"
        static let kLast = "last"
        static let kSymbol = "symbol"
        static let kSell = "sell"
    }
}
