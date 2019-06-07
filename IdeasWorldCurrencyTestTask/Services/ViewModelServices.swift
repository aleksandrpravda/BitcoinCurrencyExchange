//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

//import UIKit
protocol ViewModel {}

protocol ViewModelServices {
    func getCurrencyExchangeService() -> CurrencyExchangeService
    func getNetworkService() -> NetworkService
    func getDataBaseService() -> DataBaseService
    func getAlertService() -> AlertService
    func push(viewModel: ViewModel)
}
