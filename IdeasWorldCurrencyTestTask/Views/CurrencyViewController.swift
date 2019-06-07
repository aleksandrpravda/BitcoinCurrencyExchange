//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var bitCoinTextField: UITextField!
    var viewModel: CurrencyViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        self.viewModel?.currencyValue.bind(to: self.currencyValueLabel.reactive.text)
        self.bitCoinTextField.reactive.text
            .flatMapLatest { value in
                return self.viewModel!.filterInputTextSignal(value)
            }
            .bind(to: self.bitCoinTextField.reactive.text)
        self.viewModel!.bitcoinValue.bidirectionalBind(to: self.bitCoinTextField.reactive.text)
    }
}
