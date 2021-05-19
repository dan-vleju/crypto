//
//  Utils.swift
//  Crypto
//
//  Created by Dan Vleju on 17.05.2021.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension Double {
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    internal var commaRepresentation: String {
        return Double.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
