//
//  FlowAssemblyFabric.swift
//  MCBCurMVP
//
//  Created by Grigory Stolyarov on 30.05.2022.
//

import UIKit

protocol AssemblyFactoryProtocol {
    
    func createMain(router: RouterProtocol) -> UIViewController
    func createDetail(exchangeRate: ExchangeRate?, router: RouterProtocol) -> UIViewController
}

class FlowAssemblyFactory: AssemblyFactoryProtocol {
    
    func createMain(router: RouterProtocol) -> UIViewController {
        
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view,
                                      networkService: networkService,
                                      router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createDetail(exchangeRate: ExchangeRate?, router: RouterProtocol) -> UIViewController {
        
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view,
                                        exchangeRate: exchangeRate,
                                        router: router)
        view.presenter = presenter
        
        return view
    }
}
