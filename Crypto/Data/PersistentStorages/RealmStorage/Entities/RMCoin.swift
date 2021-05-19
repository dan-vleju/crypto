//
//  RMCoin.swift
//  Crypto
//
//  Created by Dan Vleju on 18.05.2021.
//

import Foundation
import RealmSwift

final class RMPriceRecord: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var time: TimeInterval = 0
    @objc dynamic var price: Double = 0

    override class func primaryKey() -> String? {
        return "key"
    }

    convenience init(time: TimeInterval, price: Double) {
        self.init()
        self.key = "\(time)"
        self.time = time
        self.price = price
    }
}

final class RMCoin: Object {

    @objc dynamic var name: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var imageUrl: String?
    dynamic var priceRecords = List<RMPriceRecord>()

    override class func primaryKey() -> String? {
        return "code"
    }
}

extension RMCoin: DomainConvertibleType {
    func asDomain() -> Coin {
        let priceFluctuations = Array(priceRecords.map({ ($0.time, $0.price) }))
        return Coin(name: name,
                    code: code,
                    price: price,
                    imageUrl: imageUrl,
                    priceFluctuations: priceFluctuations)
    }
}

extension Coin: RealmRepresentable {
    func asRealm() -> RMCoin {
        let obj = RMCoin()
        obj.name = name
        obj.code = code
        obj.price = price
        obj.imageUrl = imageUrl
        let priceRecords = List<RMPriceRecord>()
        priceRecords.append(objectsIn: priceFluctuations.map({ RMPriceRecord(time: $0.time, price: $0.price) }))
        obj.priceRecords = priceRecords

        return obj
    }
}
