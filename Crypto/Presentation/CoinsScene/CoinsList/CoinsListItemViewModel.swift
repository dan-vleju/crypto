//
//  CoinsListItemViewModel.swift
//  Crypto
//
//  Created by Dan Vleju on 16.05.2021.
//

import Foundation

struct CoinsListItemViewModel {
    let name: String
    let code: String
    let price: Double
    let imageUrl: String?
    let minPrice: Double?
    let maxPrice: Double?

    var priceAnimation: PriceAnimation?
}

extension CoinsListItemViewModel {

    init(coin: Coin) {
        self.name = coin.name
        self.code = coin.code
        self.price = coin.price
        self.imageUrl = coin.imageUrl
        let prices = coin.priceFluctuations.map({ $0.price })
        self.minPrice = prices.min()
        self.maxPrice = prices.max()
    }
}

extension CoinsListItemViewModel: Equatable {
    public static func == (lhs: CoinsListItemViewModel, rhs: CoinsListItemViewModel) -> Bool {
        return lhs.code == rhs.code
    }
}

enum PriceAnimationType {
    case increase
    case decrease
}

enum PriceAnimationState {
    case fadeIn
    case freeze

    var nextState: PriceAnimationState? {
        switch self {
        case .fadeIn: return .freeze
        case .freeze: return nil
        }
    }
}

typealias PriceAnimation = (type: PriceAnimationType, state: PriceAnimationState)
