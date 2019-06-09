//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import RealmSwift
import Alamofire

class CurrencySelectionViewModel: ViewModel {
    let loadingIndicator = Observable<Bool>(false)
    let reloadDataObserver = Observable<Void>(())
    let selectedIndex = PublishSubject<IndexPath, Never>()
    let currencyData = MutableObservableArray<ViewModel>()
    
    private let disposeBag = DisposeBag()
    
    internal var services: ViewModelServices
    
    init(with services: ViewModelServices) {
        self.services = services
        self.services.getDataBaseService().getResults()
            .flatMapError { [unowned self] error in
                return self.services.getAlertService().presentAlertError(error)
                    .flatMapLatest { error in
                        return SafeSignal<[Currency]>(just: [])
                    }
            }
            .map {[unowned self] value in
                return self.mapViewModel(with: value, nil)
            }
            .bind(to: self.currencyData)
        
        _ = self.selectedIndex
            .filter { [unowned self] index in
                return self.currencyData.value.collection.indices.contains(index.row)
            }
            .filter { [unowned self] index in
                return self.currencyData.value.collection is [CurrencySelectionCellViewModel]
            }
            .map { [unowned self] index in
                return self.currencyData.value.collection[index.row]
            }
            .observeNext { [unowned self] cellViewModel in
                self.services.push(viewModel: (cellViewModel as! CurrencySelectionCellViewModel).currencyViewModel)
            }
            .dispose(in: self.disposeBag)

    }
    
    func reloadData() {
        self.services.getNetworkService().loadCurrencies()
            .executeOn(.global(qos: .userInitiated))
            .observeOn(.main)
            .flatMapError {[unowned self] error in
                return self.services.getAlertService().presentAlertError(error)
                    .flatMapLatest { error in
                        return SafeSignal<LoadingState<[String: [String: Any]], Error>>(just: LoadingState.failed(error))
                    }
            }
            .observeNext { [unowned self] loadingState in
                switch loadingState {
                case .loading:
                    self.loadingIndicator.value = true
                case .loaded(let currencies):
                    self.onLoadingSucceeded(currencies)
                    self.loadingIndicator.value = false
                case .failed(_):
                    self.loadingIndicator.value = false
                }
            }
            .dispose(in: self.disposeBag)
    }
    
    internal func onLoadingSucceeded(_ dictionary: [String: [String: Any]]) {
        self.services.getDataBaseService().update(dictionary: dictionary)
            .flatMapError {[unowned self] error in
                return self.services.getAlertService().presentAlertError(error)
                    .flatMapLatest { _ in
                        return SafeSignal<Void>(just: ())
                    }
            }
            .observeNext{_ in
                print("Data updatetd")
            }
            .dispose(in: self.disposeBag)
        
    }
    
    private func mapViewModel(with currencies: [Currency], _ error: Error? = nil) -> [ViewModel] {
        var models: [ViewModel]
        if !currencies.isEmpty {
            models = currencies.map {CurrencySelectionCellViewModel(with: self.services, currency: $0)}
        } else if (error != nil) {
            models = [ErrorCellViewModel(with: self.services, error: error!.localizedDescription)]
        } else {
            models = [ErrorCellViewModel(with: self.services, error: NSLocalizedString("No data awailable", comment: ""))]
        }
        return models
    }
}
