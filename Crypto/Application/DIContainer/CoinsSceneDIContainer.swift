//
//  CoinsSceneDIContainer.swift
//  Crypto
//
//  Created by Dan Vleju on 13.05.2021.
//

import UIKit

final class CoinsSceneDIContainer {

    // MARK: - Persistent Storage
    lazy var coinsCache = RealmCoinsStorage()

    // MARK: - Use Cases
    func makeCoinsListUseCase() -> CoinsListUseCase {
        return DefaultCoinsListUseCase(coinsRepository: makeCoinsRepository())
    }

    // MARK: - Repositories
    func makeCoinsRepository() -> CoinsRepository {
        return DefaultCoinsRepository(cache: coinsCache)
    }

    // MARK: - Coins list
    func makeCoinsListViewController(actions: CoinsListViewModelActions) -> CoinsListViewController {
        return CoinsListViewController(viewModel: makeCoinsListViewModel(actions: actions))
    }

    func makeCoinsListViewModel(actions: CoinsListViewModelActions) -> CoinsListViewModel {
        return DefaultCoinsListViewModel(coinsListUseCase: makeCoinsListUseCase(),
                                  actions: actions)
    }

    // MARK: - Coin details
    func makeCoinDetailsViewController(coin: Coin) -> CoinDetailsViewController {
        return CoinDetailsViewController(viewModel: makeCoinDetailsViewModel(coin: coin))
    }

    func makeCoinDetailsViewModel(coin: Coin) -> CoinDetailsViewModel {
        return DefaultCoinDetailsViewModel(coin: coin)
    }

    // MARK: - Flow Coordinators
    func makeCoinsFlowCoordinator(navigationController: UINavigationController) -> CoinsFlowCoordinator {
        return CoinsFlowCoordinator(navigationController: navigationController,
                                    dependencies: self)
    }
}

extension CoinsSceneDIContainer: CoinsFlowCoordinatorDependencies {}
