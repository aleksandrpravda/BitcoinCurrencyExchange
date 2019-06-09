//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import ReactiveKit

class CurrencySelectionCell: UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
    let bagDispose = DisposeBag()
    
    func bind(viewModel: CurrencySelectionCellViewModel) {
        bagDispose.dispose()
        viewModel.currencyName
            .bind(to: self.currencyLabel.reactive.text)
            .dispose(in: bagDispose)
    }
}

