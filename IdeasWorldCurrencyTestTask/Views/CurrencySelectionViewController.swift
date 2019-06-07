//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import ReactiveKit

class CurrencySelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CurrencySelectionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let control = UIRefreshControl()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = control
        } else {
            tableView.addSubview(control)
        }
        bindViewModel()
        self.viewModel?.reloadData()
    }
    
    private func bindViewModel() {
        self.viewModel?.currencyData
            .bind(to: tableView) { dataSource, indexPath, tableView in
                let viewModel = dataSource[indexPath.row]
                if viewModel is CurrencySelectionCellViewModel {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.currencySelectionCell, for: indexPath) as! CurrencySelectionCell
                    cell.bind(viewModel: viewModel as! CurrencySelectionCellViewModel)
                    return cell
                } else  {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.errorCell, for: indexPath) as! ErrorCell
                    cell.bind(viewModel: viewModel as! ErrorCellViewModel)
                    return cell
                }
            }
        
        self.tableView.reactive.selectedRowIndexPath
            .filter { indexPath in
                return !self.tableView.refreshControl!.isRefreshing
            }
            .bind(to: self.viewModel!.selectedIndex)
        
        _ = self.tableView.refreshControl!.reactive.controlEvents(.valueChanged)
            .observeNext {
            self.viewModel?.reloadData()
        }
        
        viewModel?.loadingIndicator
            .map { isLoading in
                self.tableView.allowsSelection = !isLoading
                return isLoading
            }
            .bind(to: self.tableView.refreshControl!.reactive.refreshing)
    }
}
