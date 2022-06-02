//
//  RouterTest.swift
//  MCBCurMVPTests
//
//  Created by Grigory Stolyarov on 31.05.2022.
//

import XCTest
@testable import MCBCurMVP

class MockNavigationController: UINavigationController {
    
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    var assembly = FlowAssemblyFactory()

    override func setUpWithError() throws {

        router = Router(navigationController: navigationController, assemblyFactory: assembly)
    }

    override func tearDownWithError() throws {

        router = nil
    }

    func testShowDetail() throws {

        router.showDetail(exchangeRate: nil)
        
        let detailViewController = navigationController.presentedVC
        
        XCTAssertTrue(detailViewController is DetailViewController)
    }
}
