//
//  Router.swift
//  MCBCurMVP
//
//  Created by Grigory Stolyarov on 30.05.2022.
//

import UIKit

protocol RouterGlobalProtocol {
    
    var navigationController: UINavigationController? { get set }
    var assemblyFactory: AssemblyFactoryProtocol? { get set }
}

protocol RouterProtocol: RouterGlobalProtocol {
    
    func initiateViewController()
    func popToRoot()
    func showDetail(exchangeRate: ExchangeRate?)
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyFactory: AssemblyFactoryProtocol?
    
    init(navigationController: UINavigationController, assemblyFactory: AssemblyFactoryProtocol) {
        
        self.navigationController = navigationController
        self.assemblyFactory = assemblyFactory
    }
    
    func initiateViewController() {
        
        if let navigationController = navigationController {
            guard let mainViewController = assemblyFactory?.createMain(router: self)
            else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func popToRoot() {
        
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func showDetail(exchangeRate: ExchangeRate?) {
        
        if let navigationController = navigationController {
            guard let detailViewController = assemblyFactory?.createDetail(exchangeRate: exchangeRate, router: self)
            else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
}
