//
//  Session.swift
//  IdeasWorldCurrencyTestTask
//
//  Created by Nick on 30/05/2019.
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import RealmSwift

class Session: Object {
    dynamic var date : Date = Date()
    let currency = List<Currency>()
}
