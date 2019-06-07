//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class Currency: Object {
    dynamic var buy : Double = 0.0
    dynamic var sell : Double = 0.0
    dynamic var last : Double = 0.0
    dynamic var fifteenM : Double = 0.0
    dynamic var symbol : String = ""
    dynamic var name : String = ""
}
