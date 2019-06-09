//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import ReactiveKit

class AlertService {
    internal let navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentAlertError(_ error: Error) -> SafeSignal<Error> {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                      message: error.localizedDescription,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.navigationController.present(alert, animated: true, completion: nil)
        return SafeSignal<Error>(just: error)
    }
}
