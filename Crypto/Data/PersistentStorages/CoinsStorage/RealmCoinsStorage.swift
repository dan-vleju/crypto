//
//  RealmCoinsStorage.swift
//  Crypto
//
//  Created by Dan Vleju on 18.05.2021.
//

import Foundation
import Combine

final class RealmCoinsStorage {

    private let realmStorage = RealmStorage<Coin>()

    init() {}
}

extension RealmCoinsStorage: CoinsStorage {

    func save(coins: [Coin]) -> AnyPublisher<Void, Never> {
        return realmStorage.save(entities: coins)
            .eraseToAnyPublisher()
    }

    func getBy(code: String) -> AnyPublisher<Coin?, Never> {
        return realmStorage.query(primaryKey: code)
            .eraseToAnyPublisher()
    }

    func getAllCoins() -> AnyPublisher<[Coin], Never> {
        return realmStorage.queryAll()
    }
}
