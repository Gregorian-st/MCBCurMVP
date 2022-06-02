//
//  DetailPresenter.swift
//  MCBCurMVP
//
//  Created by Grigory Stolyarov on 30.05.2022.
//

import Foundation

protocol DetailPresenterToViewProtocol: AnyObject {
    
    func showExchangeRate(exchangeRate: ExchangeRate?)
}

protocol DetailViewToPresenterProtocol: AnyObject {
    
    init(view: DetailPresenterToViewProtocol, exchangeRate: ExchangeRate?, router: RouterProtocol)
    func setExchangeRate()
}

class DetailPresenter: DetailViewToPresenterProtocol {
    
    weak var view: DetailPresenterToViewProtocol?
    var router: RouterProtocol?
    var exchangeRate: ExchangeRate?
    
    required init(view: DetailPresenterToViewProtocol, exchangeRate: ExchangeRate?, router: RouterProtocol) {
        
        self.view = view
        self.exchangeRate = exchangeRate
        self.router = router
    }
    
    func setExchangeRate() {
        
        view?.showExchangeRate(exchangeRate: exchangeRate)
    }
}
