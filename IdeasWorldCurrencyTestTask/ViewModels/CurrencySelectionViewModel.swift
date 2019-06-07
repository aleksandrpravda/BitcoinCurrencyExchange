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
        _ = self.selectedIndex
            .filter { index in
                return self.currencyData.value.collection.indices.contains(index.row)
            }
            .filter { index in
                return self.currencyData.value.collection is [CurrencySelectionCellViewModel]
            }
            .map { index in
                return self.currencyData.value.collection[index.row]
            }
            .observeNext { cellViewModel in
                self.services.push(viewModel: (cellViewModel as! CurrencySelectionCellViewModel).currencyViewModel)
            }
            .dispose(in: disposeBag)
    }
    
    func reloadData() {
        self.services.getNetworkService().loadCurrencies()
            .executeOn(.global(qos: .userInitiated))
            .observeOn(.main)
            .observeNext { loadingState in
                switch loadingState {
                case .loading:
                    self.loadingIndicator.value = true
                case .loaded(let currencies):
                    self.onLoadingSucceeded(currencies)
                    self.loadingIndicator.value = false
                case .failed(let error):
                    self.onLoadingFailed(error)
                    self.loadingIndicator.value = false
                }
            }
            .dispose(in: self.disposeBag)
    }
    
    internal func onLoadingFailed(_ error: Error) {
        self.services.getAlertService().presentAlertError(error, ())
            .flatMapLatest { _ in
                return self.services.getDataBaseService().fetchCurrenciesSignal()
            }
            .flatMapError { error in
                return self.services.getAlertService().presentAlertError(error, [])
            }
            .map { self.mapViewModel(with: $0, error) }
            .bind(to: self.currencyData)
    }
    
    internal func onLoadingSucceeded(_ currencies: [Currency]) {
        self.services.getDataBaseService().update(currencies: currencies)
            .flatMapLatest { _ in
                return self.services.getDataBaseService().fetchCurrenciesSignal()
            }
            .flatMapError { error in
                return self.services.getAlertService().presentAlertError(error, [])
            }
            .map { self.mapViewModel(with: $0, nil) }
            .bind(to: self.currencyData)
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
