//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import ReactiveKit
import RealmSwift

class ViewModelServicesImpl: ViewModelServices {
    internal var navigationController: UINavigationController
    internal var networkService: NetworkService
    internal var databaseService: DataBaseService
    internal var alertService: AlertService
    internal var currencyExchangeService: CurrencyExchangeService
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkService = NetworkService(with: Constants.kBlockchainURL)
        self.databaseService = DataBaseService(with: Realm.Configuration.defaultConfiguration)
        self.alertService = AlertService(navigationController)
        self.currencyExchangeService = CurrencyExchangeService()
    }
    
    func getCurrencyExchangeService() -> CurrencyExchangeService {
        return self.currencyExchangeService
    }
    
    func getNetworkService() -> NetworkService {
        return self.networkService
    }
    
    func getDataBaseService() -> DataBaseService {
        return self.databaseService
    }
    
    func getAlertService() -> AlertService {
        return self.alertService
    }
    
    func push(viewModel: ViewModel) {
        var viewController: UIViewController?
        let storyboard: UIStoryboard = UIStoryboard(name: Constants.Storyboard.kStoryboardName, bundle: nil)
        if viewModel is CurrencyViewModel {
            let cvc = (storyboard.instantiateViewController(withIdentifier:Constants.Storyboard.kCurrencyViewControllerIdentifire) as? CurrencyViewController)
            cvc?.viewModel = viewModel as? CurrencyViewModel
            viewController = cvc
        } else {
            print([NSLocalizedDescriptionKey: NSLocalizedString("An unknown ViewModel was pushed", comment: "")])
        }
        guard let controller = viewController else {
            return
        }
        self.navigationController.pushViewController(controller, animated: true)
    }
}
