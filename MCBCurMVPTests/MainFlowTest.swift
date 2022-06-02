//
//  MainFlowTest.swift
//  MCBCurMVPTests
//
//  Created by Grigory Stolyarov on 31.05.2022.
//

import XCTest
@testable import MCBCurMVP

class MockMainView: MainPresenterToViewProtocol {
    
    func showExchangeRates() {
        
    }
    
    func showError(error: String) {
        
    }
}

class MockNetworkService: NetworkServiceProtocol {
    
    var exchangeRateResult: ExchangeRateResult!
    
    init(){}
    
    convenience init(exchangeRateResult: ExchangeRateResult?) {
        
        self.init()
        self.exchangeRateResult = exchangeRateResult
    }
    
    func getExchangeRates(completion: @escaping (Result<ExchangeRateResult, Error>) -> Void) {
        
        if let exchangeRateResult = exchangeRateResult {
            completion(.success(exchangeRateResult))
        } else {
            let error = NSError(domain: "", code: 404, userInfo: nil)
            completion(.failure(error))
        }
    }
}

class MainFlowTest: XCTestCase {
    
    var view: MockMainView!
    var presenter: MainPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var exchangeRateResult: ExchangeRateResult?

    override func setUpWithError() throws {

        let navigationController = UINavigationController()
        let assembly = FlowAssemblyFactory()
        router = Router(navigationController: navigationController, assemblyFactory: assembly)
    }

    override func tearDownWithError() throws {

        view = nil
        router = nil
        networkService = nil
        presenter = nil
    }

    func testMainPresenter() throws {
        
        let testResult = ExchangeRateResult(code: 0,
                                        messageTitle: "",
                                        message: "",
                                        rid: "",
                                        downloadDate: "Now",
                                        productState: 1,
                                        ratesDate: "Now")
        
        view = MockMainView()
        networkService = MockNetworkService(exchangeRateResult: testResult)
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        
        presenter.view?.showExchangeRates()
        
        XCTAssertEqual(presenter.exchangeRates?.downloadDate, testResult.downloadDate)
    }
}
