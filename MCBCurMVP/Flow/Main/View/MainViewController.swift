//
//  MainViewController.swift
//  MCBCurMVP
//
//  Created by Grigory Stolyarov on 30.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let cellRateReuseID = "rateCell"
    private let rowHeight: CGFloat = 62
    private var refreshControl = UIRefreshControl()
    
    var presenter: MainViewToPresenterProtocol!
    
    // MARK: - Outlets
    
    @IBOutlet weak var ratesTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {

        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Program Logic
    
    private func setupNavigationBar() {
        
        let refreshButton = UIButton(type: .custom)
        refreshButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        
        let item1 = UIBarButtonItem(customView: refreshButton)
        navigationItem.setRightBarButtonItems([item1], animated: true)
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc func refreshButtonTapped() {
        
        presenter.getExchangeRates()
    }
    
    private func setupTableView() {
        
        ratesTableView.register(UINib(nibName: "RatesTableViewCell", bundle: nil),
                                forCellReuseIdentifier: cellRateReuseID)
        ratesTableView.cellLayoutMarginsFollowReadableWidth = true
        ratesTableView.separatorStyle = .none
        
        refreshControl.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        ratesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        presenter.getExchangeRates()
    }
    
    private func showAlert(alertMessage: String) {
        
        let alertController = UIAlertController(title: "MCB Currency App",
                                                message: alertMessage,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: UIAlertAction.Style.default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateTitle() {
        
        if let ratesDate = presenter.exchangeRates?.ratesDate {
            navigationItem.title = ratesDate
        } else {
            navigationItem.title = "Currencies"
        }
    }
    
    private func forceHideRefreshControl() {
        
        if ratesTableView.contentOffset.y < 0 {
            ratesTableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        presenter.exchangeRates?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRateReuseID, for: indexPath) as! RatesTableViewCell
        if let exchangeRate = presenter.exchangeRates?.rates[indexPath.row] {
            cell.exchangeRate = exchangeRate
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exchangeRate = presenter.exchangeRates?.rates[indexPath.row]
        presenter.rateTapped(exchangeRate: exchangeRate)
    }
}

// MARK: - MainPresenterToViewProtocol

extension MainViewController: MainPresenterToViewProtocol {
    
    func showExchangeRates() {
        
        refreshControl.endRefreshing()
        updateTitle()
        ratesTableView.reloadData()
    }
    
    func showError(error: String) {
        
        refreshControl.endRefreshing()
        showAlert(alertMessage: error)
        forceHideRefreshControl()
    }
}
