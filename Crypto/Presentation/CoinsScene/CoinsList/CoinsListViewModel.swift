//
//  CoinsListViewModel.swift
//  Crypto
//
//  Created by Dan Vleju on 15.05.2021.
//

import UIKit
import Combine

struct CoinsListViewModelActions {
    let showCoinDetails: (Coin) -> ()
}

protocol CoinsListViewModelInput {
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func priceAnimationStateShouldChange(for index: Int, animationState: PriceAnimationState?)
}

protocol CoinsListViewModelOutput {
    var state: CurrentValueSubject<CoinsListState, Never> { get }
}

enum CoinsListState {
    case loading
    case success([CoinsListItemViewModel], reloadType: ReloadType)
    case failure(Error)

    var items: [CoinsListItemViewModel] {
        guard case .success(let coins, _) = self else { return [] }
        return coins
    }

    enum ReloadType {
        case allItems
        case item(atIndex: Int)
    }
}

protocol CoinsListViewModel: CoinsListViewModelInput, CoinsListViewModelOutput {}

final class DefaultCoinsListViewModel: CoinsListViewModel {

    private let coinsListUseCase: CoinsListUseCase
    private let actions: CoinsListViewModelActions
    private var cancellables: [AnyCancellable] = []
    private var reconnectTimer: Timer?

    private var domainModels = [String : Coin]()

    // MARK: - OUTPUT
    var state = CurrentValueSubject<CoinsListState, Never>(.loading)

    // MARK: - Init
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(coinsListUseCase: CoinsListUseCase,
         actions: CoinsListViewModelActions) {
        self.coinsListUseCase = coinsListUseCase
        self.actions = actions

        handleEvents()
        addObservers()
    }

    private func loadCoins() {
        coinsListUseCase.getAllCoins()
            .receive(on: DispatchQueue.main)
            .sink { coins in
                self.domainModels = coins.reduce([:], { (result, coin) in
                    var result = result
                    result[coin.code] = coin
                    return result
                })
                let viewModelItems = coins.map(CoinsListItemViewModel.init)
                self.state.value = .success(viewModelItems, reloadType: .allItems)
            }
            .store(in: &cancellables)
    }

    private func handleEvents() {
        coinsListUseCase.didUpdateCoin
            .receive(on: DispatchQueue.main)
            .sink { coin in
                self.domainModels[coin.code] = coin
                var coins = self.state.value.items
                if let index = coins.firstIndex(where: { $0.code == coin.code }) {
                    var newCoin = CoinsListItemViewModel(coin: coin)
                    let oldPrice = coins[index].price
                    let newPrice = newCoin.price

                    if newPrice > oldPrice {
                        newCoin.priceAnimation = (type: .increase, state: .fadeIn)
                    } else if newPrice < oldPrice {
                        newCoin.priceAnimation = (type: .decrease, state: .fadeIn)
                    }

                    coins[index] = newCoin
                    self.state.value = .success(coins, reloadType: .item(atIndex: index))
                }
            }
            .store(in: &cancellables)

        coinsListUseCase.didDisconnect
            .receive(on: DispatchQueue.main)
            .sink {
                if UIApplication.shared.applicationState == .active {
                    self.doConnect()
                }
            }
            .store(in: &cancellables)
    }

    private func doConnect() {
        let connectResult = coinsListUseCase.connect()

        switch connectResult {
        case .failure(let error):
            guard let error = error as? CryptoError else { return }

            switch error {
            case .connectAfter(let date):
                startReconnectTimer(date: date)
            default:
                break
            }
        case .success:
            break
        }
    }

    private func startReconnectTimer(date: Date) {
        reconnectTimer?.invalidate()
        reconnectTimer = Timer(fire: date, interval: 0, repeats: false) { [weak self] _ in
            self?.doConnect()
        }
        RunLoop.current.add(reconnectTimer!, forMode: .default)
    }

    // MARK: - Observers
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func applicationDidEnterBackground() {
        coinsListUseCase.disconnect()
        reconnectTimer?.invalidate()
    }

    @objc func applicationWillEnterForeground() {
        doConnect()
    }
}

// MARK: - INPUT
extension DefaultCoinsListViewModel {
    func viewDidLoad() {
        loadCoins()
        doConnect()
    }

    func didSelectItem(at index: Int) {
        let code = state.value.items[index].code
        guard let coin = domainModels[code] else { return }
        actions.showCoinDetails(coin)
    }

    func priceAnimationStateShouldChange(for index: Int, animationState: PriceAnimationState?) {
        guard state.value.items.indices.contains(index) else { return }
        var items = state.value.items
        var item = items[index]
        guard let animation = item.priceAnimation else { return }

        item.priceAnimation = animationState != nil ? (animation.type, animationState!) : nil
        items[index] = item
        state.value = .success(items, reloadType: .item(atIndex: index))
    }
}
