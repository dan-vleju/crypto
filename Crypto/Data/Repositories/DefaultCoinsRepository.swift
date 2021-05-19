//
//  DefaultCoinsRepository.swift
//  Crypto
//
//  Created by Dan Vleju on 15.05.2021.
//

import Foundation
import Combine
import CryptoAPI

typealias CryptoError = CryptoAPI.CryptoError

final class DefaultCoinsRepository {

    private lazy var cryptoAPI = Crypto(delegate: self)
    private let cache: CoinsStorage

    private var cancellables: [AnyCancellable] = []

    var didConnect = PassthroughSubject<Void, Never>()
    var didUpdateCoin = PassthroughSubject<Coin, Never>()
    var didDisconnect = PassthroughSubject<Void, Never>()

    init(cache: CoinsStorage) {
        self.cache = cache
    }
}

extension DefaultCoinsRepository: CoinsRepository {
    func connect() -> Result<Bool, Error> {
        return cryptoAPI.connect()
    }

    func disconnect() {
        cryptoAPI.disconnect()
    }

    func getAllCoins() -> AnyPublisher<[Coin], Never> {
        return cache.getAllCoins()
            .flatMap { cachedCoins -> AnyPublisher<[Coin], Never> in
                var allCoins = self.cryptoAPI.getAllCoins().map({ $0.asDomain() })
                allCoins.updatePriceFluctuations(from: cachedCoins)
                allCoins = allCoins.map({ coin -> Coin in
                    var coin = coin
                    coin.recordCurrentPrice()
                    return coin
                })
                let _ = self.cache.save(coins: allCoins).sink(receiveValue: {})
                return CurrentValueSubject<[Coin], Never>(allCoins).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension DefaultCoinsRepository: CryptoDelegate {
    func cryptoAPIDidConnect() {
        didConnect.send()
    }

    func cryptoAPIDidUpdateCoin(_ coin: CryptoAPI.Coin) {
        var coin = coin.asDomain()
        cache.getBy(code: coin.code)
            .sink { cachedCoin in
                coin.priceFluctuations = cachedCoin?.priceFluctuations ?? []
                coin.recordCurrentPrice()
                let _ = self.cache.save(coins: [coin]).sink(receiveValue: {})
                self.didUpdateCoin.send(coin)
            }
            .store(in: &cancellables)
    }

    func cryptoAPIDidDisconnect() {
        didDisconnect.send()
    }
}

fileprivate extension CryptoAPI.Coin {
    func asDomain() -> Coin {
        return Coin(name: name,
                    code: code,
                    price: price,
                    imageUrl: imageUrl)
    }
}

private extension Array where Element == Coin {
    mutating func updatePriceFluctuations(from source: [Coin]) {
        self = map({ coin -> Coin in
            var updatedCoin = coin
            if let cachedCoin = source.first(where: { coin == $0 }) {
                updatedCoin.priceFluctuations = cachedCoin.priceFluctuations
            }
            return updatedCoin
        })
    }
}
