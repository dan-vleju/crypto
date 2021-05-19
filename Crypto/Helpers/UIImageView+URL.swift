//
//  UIImageView+URL.swift
//  Crypto
//
//  Created by Dan Vleju on 16.05.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImageFromURLString(_ urlString: String?, animated: Bool = false, placeholder: UIImage? = nil, completion: (() -> Void)? = nil) {
        self.image = placeholder

        guard let url = URL(string: urlString ?? "") else {
            completion?()
            return
        }

        let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
        var options = KingfisherOptionsInfo()
        if animated {
            options.append(.transition(.fade(0.15)))
        }

        self.kf.setImage(with: resource, options: options, completionHandler:  { result in
            completion?()
        })
    }
}
