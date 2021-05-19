//
//  CoinsRepository.swift
//  Crypto
//
//  Created by Dan Vleju on 15.05.2021.
//

import Foundation
import Combine

protocol CoinsRepository {
    func getAllCoins() -> AnyPublisher<[Coin], Never>
    func connect() -> Result<Bool, Error>
    func disconnect()
    var didConnect: PassthroughSubject<Void, Never> { get }
    var didUpdateCoin: PassthroughSubject<Coin, Never> { get }
    var didDisconnect: PassthroughSubject<Void, Never> { get }
}
