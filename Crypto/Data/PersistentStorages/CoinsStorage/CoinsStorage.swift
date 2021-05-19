//
//  CoinsStorage.swift
//  Crypto
//
//  Created by Dan Vleju on 17.05.2021.
//

import Foundation
import Combine

protocol CoinsStorage {
    func save(coins: [Coin]) -> AnyPublisher<Void, Never>
    func getBy(code: String) -> AnyPublisher<Coin?, Never>
    func getAllCoins() -> AnyPublisher<[Coin], Never>
}
