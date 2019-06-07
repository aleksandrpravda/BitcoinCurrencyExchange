//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit

class ErrorCell: UITableViewCell {
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    func bind(viewModel: ErrorCellViewModel) {
        viewModel.errorMessage.bind(to: errorMessageLabel.reactive.text)
    }
}
