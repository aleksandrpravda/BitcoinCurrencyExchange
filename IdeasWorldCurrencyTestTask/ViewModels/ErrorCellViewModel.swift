//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class ErrorCellViewModel: ViewModel {
    let errorMessage = Observable<String?>("")
    
    init(with services: ViewModelServices, error message: String) {
        errorMessage.value = message
    }
}
