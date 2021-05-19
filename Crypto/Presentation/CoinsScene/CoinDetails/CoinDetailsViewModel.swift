//
//  CoinDetailsViewModel.swift
//  Crypto
//
//  Created by Dan Vleju on 19.05.2021.
//

import Foundation
import Combine
import Charts

protocol CoinDetailsViewModelInput {
    func viewDidLoad()
}

protocol CoinDetailsViewModelOutput {
    var title: String { get }
    var chartDataEntries: [CandleChartDataEntry]! { get }
}

protocol CoinDetailsViewModel: CoinDetailsViewModelOutput {}

final class DefaultCoinDetailsViewModel: CoinDetailsViewModel {

    var title: String
    var chartDataEntries: [CandleChartDataEntry]!

    private let groupingIntervalInSeconds: TimeInterval = 20
    private let totalIntervalInSeconds: TimeInterval = 240

    init(coin: Coin) {
        title = coin.name
        chartDataEntries = chartDataEntries(from: coin.priceFluctuations)
    }

    private func chartDataEntries(from priceFluctuations: [PriceRecord]) -> [CandleChartDataEntry] {
        guard !priceFluctuations.isEmpty else { return [] }

        var priceFluctuations = priceFluctuations.sorted(by: { $0.time < $1.time })

        // Get records for specified time interval
        let lastRecordedTime = priceFluctuations.last!.time
        let reversedPriceFluctuations = Array(priceFluctuations.reversed())
        if let index = reversedPriceFluctuations.firstIndex(where: { $0.time <= lastRecordedTime - totalIntervalInSeconds }) {
            priceFluctuations = Array(reversedPriceFluctuations[0..<index]).reversed()
        }

        // Set group indexes
        var referenceTime: TimeInterval!
        var indexes = [Int]()
        for (i, element) in priceFluctuations.enumerated() {
            if referenceTime == nil || element.time >= referenceTime {
                referenceTime = element.time + groupingIntervalInSeconds
                indexes.append(i)
            }
        }

        return stride(from: 0, to: indexes.count - 1, by: 1)
            .map { (start: indexes[$0], end: indexes[$0+1]) }
            .enumerated()
            .reduce([]) { (result, arg1) in
                var result = result
                let group = Array(priceFluctuations[arg1.1.start..<arg1.1.end])
                let high = group.max(by: { $0.time < $1.time })!.price
                let low = group.min(by: { $0.time < $1.time })!.price
                let open = group.first!.price
                let close = group.last!.price

                let entry = CandleChartDataEntry(x: Double(arg1.0), shadowH: high, shadowL: low, open: open, close: close, icon: nil)
                result.append(entry)

                return result
            }
    }
}
