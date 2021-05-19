//
//  CoinsListUseCase.swift
//  Crypto
//
//  Created by Dan Vleju on 15.05.2021.
//

import Foundation
import Combine

protocol CoinsListUseCase {
    func getAllCoins() -> AnyPublisher<[Coin], Never>
    func connect() -> Result<Bool, Error>
    func disconnect()
    var didConnect: PassthroughSubject<Void, Never> { get }
    var didUpdateCoin: PassthroughSubject<Coin, Never> { get }
    var didDisconnect: PassthroughSubject<Void, Never> { get }
}

final class DefaultCoinsListUseCase: CoinsListUseCase {

    private let coinsRepository: CoinsRepository
    var didConnect: PassthroughSubject<Void, Never>
    var didUpdateCoin: PassthroughSubject<Coin, Never>
    var didDisconnect: PassthroughSubject<Void, Never>

    init(coinsRepository: CoinsRepository) {
        self.coinsRepository = coinsRepository
        self.didConnect = coinsRepository.didConnect
        self.didUpdateCoin = coinsRepository.didUpdateCoin
        self.didDisconnect = coinsRepository.didDisconnect
    }

    func getAllCoins() -> AnyPublisher<[Coin], Never> {
        return coinsRepository.getAllCoins()
    }

    func connect() -> Result<Bool, Error> {
        return coinsRepository.connect()
    }

    func disconnect() {
        coinsRepository.disconnect()
    }
}
