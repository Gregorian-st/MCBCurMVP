//
//  MainPresenter.swift
//  MCBCurMVP
//
//  Created by Grigory Stolyarov on 30.05.2022.
//

import Foundation

protocol MainPresenterToViewProtocol: AnyObject {
    
    func showExchangeRates()
    func showError(error: String)
}

protocol MainViewToPresenterProtocol: AnyObject {
    
    var exchangeRates: ExchangeRateResult? { get set }
    
    init(view: MainPresenterToViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getExchangeRates()
    func rateTapped(exchangeRate: ExchangeRate?)
}

class MainPresenter: MainViewToPresenterProtocol {
    
    weak var view: MainPresenterToViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var exchangeRates: ExchangeRateResult?
    
    required init(view: MainPresenterToViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        
        self.view = view
        self.networkService = networkService
        self.router = router
        getExchangeRates()
    }
    
    func getExchangeRates() {
        
        networkService.getExchangeRates { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let rateResult):
                self.exchangeRates = rateResult
                DispatchQueue.main.async {
                    self.view?.showExchangeRates()
                    if let alertMessage = self.exchangeRates?.message,
                       alertMessage != "" {
                        self.view?.showError(error: alertMessage)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showError(error: error.localizedDescription)
                }
            }
        }
    }
    
    func rateTapped(exchangeRate: ExchangeRate?) {
        
        router?.showDetail(exchangeRate: exchangeRate)
    }
}
