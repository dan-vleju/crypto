//
//  AppFlowCoordinator.swift
//  Crypto
//
//  Created by Dan Vleju on 13.05.2021.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let coinsSceneDIContainer = appDIContainer.makeCoinsSceneDIContainer()
        let flow = coinsSceneDIContainer.makeCoinsFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
