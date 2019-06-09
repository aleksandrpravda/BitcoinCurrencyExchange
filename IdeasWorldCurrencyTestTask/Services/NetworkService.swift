//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import ReactiveKit
import Alamofire
import RealmSwift
import AlamofireNetworkActivityIndicator

class NetworkService {
    private let stringURl: String
    private var reachabilityManager: NetworkReachabilityManager = NetworkReachabilityManager()!
    internal var isReachable: Bool = true
    
    init(with stringURl: String) {
        self.stringURl = stringURl
        self.connectReachabilityManager()
        self.connectActivityIndicatorManager()
    }
    
    func loadCurrencies() -> Signal<LoadingState<[String: [String: Any]], Error>, Never>{
        return Signal<LoadingState<[String: [String: Any]], Error>, Never> {[unowned self] observer in
            observer.next(LoadingState.loading)
            if !self.isReachable {
                let error = NSError(domain: "", code: -1, userInfo:[NSLocalizedDescriptionKey: NSLocalizedString("Internet Connection Not Reachable", comment: "")])
                observer.next(LoadingState.failed(error))
                observer.completed()
                return BlockDisposable {}
            }
            let task = self.currencyRequest(by: self.stringURl, completion: { result in
                switch result {
                case .success(let value):
                    observer.next(LoadingState.loaded(value))
                    observer.completed()
                case .failure(let error):
                    observer.next(LoadingState.failed(error))
                    observer.completed()
                }
            })
            return BlockDisposable{
                task.cancel()
            }
        }
    }
    
    private func currencyRequest(by urlString: String, completion: @escaping (Result<[String: [String: Any]]>) -> ()) -> DataRequest {
        let task = Alamofire.request(urlString, parameters: nil)
            .response(
                responseSerializer: DataRequest.jsonResponseSerializer(),
                completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        guard let dictionary = value as? [String: [String: Any]] else {
                            let error = NSError(domain: "", code: -1, userInfo:[NSLocalizedDescriptionKey: NSLocalizedString("Data Response error", comment: "")])
                            completion(Result.failure(error))
                            return
                        }
                        completion(Result.success(dictionary))
                    case .failure(let error):
                        completion(Result.failure(error))
                    }
            }
        )
        return task
    }
    
    private func connectReachabilityManager() {
        isReachable = reachabilityManager.isReachable

        reachabilityManager.listener = { [weak self] status in
            self?.isReachable = (status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan))
        }

        reachabilityManager.startListening()
    }
    
    private func connectActivityIndicatorManager() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.0
        NetworkActivityIndicatorManager.shared.completionDelay = 0.0
    }
}
