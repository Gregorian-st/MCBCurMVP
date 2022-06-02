//
//  DetailViewController.swift
//  MCBCurMVP
//
//  Created by Grigory Stolyarov on 30.05.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var presenter: DetailViewToPresenterProtocol!
    private var exchangeRate: ExchangeRate?
    
    // MARK: - Outlets

    @IBOutlet var rateLabels: [UILabel]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter.setExchangeRate()
    }
    
    // MARK: - Program Logic
    
    private func showRate() {
    
        title = exchangeRate?.name ?? "Name"
        rateLabels.forEach {
            switch $0.tag {
            case 0: $0.text = "tp: \(exchangeRate?.tp ?? 0)"
            case 1: $0.text = "name: \(exchangeRate?.name ?? "")"
            case 2: $0.text = "from: \(exchangeRate?.from ?? 0)"
            case 3: $0.text = "currMnemFrom: \(exchangeRate?.currMnemFrom ?? "")"
            case 4: $0.text = "to: \(exchangeRate?.to ?? 0)"
            case 5: $0.text = "currMnemTo: \(exchangeRate?.currMnemTo ?? "")"
            case 6: $0.text = "basic: \(exchangeRate?.basic ?? 0)"
            case 7: $0.text = "buy: \(exchangeRate?.buy ?? 0)"
            case 8: $0.text = "sale: \(exchangeRate?.sale ?? 0)"
            case 9: $0.text = "deltaBuy: \(exchangeRate?.deltaBuy ?? 0)"
            case 10: $0.text = "deltaSale: \(exchangeRate?.deltaSale ?? 0)"
            default:
                $0.text = ""
            }
        }
    }
}

extension DetailViewController: DetailPresenterToViewProtocol {
    
    func showExchangeRate(exchangeRate: ExchangeRate?) {
        
        self.exchangeRate = exchangeRate
        showRate()
    }
}
