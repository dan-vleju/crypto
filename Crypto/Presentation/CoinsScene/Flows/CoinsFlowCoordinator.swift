//
//  CoinsFlowCoordinator.swift
//  Crypto
//
//  Created by Dan Vleju on 13.05.2021.
//

import UIKit

protocol CoinsFlowCoordinatorDependencies {
    func makeCoinsListViewController(actions: CoinsListViewModelActions) -> CoinsListViewController
    func makeCoinDetailsViewController(coin: Coin) -> CoinDetailsViewController
}

final class CoinsFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: CoinsFlowCoordinatorDependencies

    private weak var coinsListVC: CoinsListViewController?

    init(navigationController: UINavigationController,
         dependencies: CoinsFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = CoinsListViewModelActions(showCoinDetails: showCoinDetails)
        let vc = dependencies.makeCoinsListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        coinsListVC = vc
    }

    private func showCoinDetails(coin: Coin) {
        let vc = dependencies.makeCoinDetailsViewController(coin: coin)
        navigationController?.pushViewController(vc, animated: true)
    }
}
