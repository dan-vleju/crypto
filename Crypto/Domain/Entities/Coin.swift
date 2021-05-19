//
//  Coin.swift
//  Crypto
//
//  Created by Dan Vleju on 16.05.2021.
//

import Foundation

typealias PriceRecord = (time: TimeInterval, price: Double)

struct Coin {
    let name: String
    let code: String
    let price: Double
    let imageUrl: String?

    var priceFluctuations: [PriceRecord] = []

    mutating func recordCurrentPrice() {
        priceFluctuations.append((Date().timeIntervalSince1970, price))
    }
}

extension Coin: Equatable {
    public static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.code == rhs.code
    }
}
