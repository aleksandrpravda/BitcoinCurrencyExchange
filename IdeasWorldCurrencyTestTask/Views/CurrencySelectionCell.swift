//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit

class CurrencySelectionCell: UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
    
    func bind(viewModel: CurrencySelectionCellViewModel) {
        viewModel.currencyName.bind(to: currencyLabel.reactive.text)
    }
}

