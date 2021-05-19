//
//  CoinTableViewCell+UI.swift
//  Crypto
//
//  Created by Dan Vleju on 18.05.2021.
//

import UIKit

extension CoinTableViewCell {

    func buildUI() {
        coinImageView = UIImageView()
        coinImageView.contentMode = .scaleAspectFit
        addSubview(coinImageView)
        coinImageView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(16)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }

        nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(coinImageView.snp.right).offset(8)
            make.centerY.equalTo(coinImageView)
        }

        codeLabel = UILabel()
        codeLabel.textColor = .lightGray
        codeLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(codeLabel)
        codeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(8)
            make.centerY.equalTo(coinImageView)
        }

        priceContainerView = UIView()
        priceContainerView.layer.cornerRadius = 4
        addSubview(priceContainerView)
        priceContainerView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(coinImageView)
            make.height.equalTo(30)
        }

        priceLabel = UILabel()
        priceLabel.backgroundColor = .clear
        priceLabel.textColor = .black
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceContainerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.edges.equalTo(priceContainerView).inset(8)
        }

        minLabel = UILabel()
        minLabel.text = "min: "
        minLabel.textColor = .lightGray
        minLabel.font = UIFont.systemFont(ofSize: 8)
        addSubview(minLabel)
        minLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(-8)
        }

        minPriceLabel = UILabel()
        minPriceLabel.textColor = .black
        minPriceLabel.textAlignment = .left
        minPriceLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(minPriceLabel)
        minPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(minLabel.snp.right)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.bottom.equalTo(-8)
            make.width.equalTo(70)
        }

        maxLabel = UILabel()
        maxLabel.text = "max: "
        maxLabel.textColor = .lightGray
        maxLabel.font = UIFont.systemFont(ofSize: 8)
        addSubview(maxLabel)
        maxLabel.snp.makeConstraints { make in
            make.left.equalTo(minPriceLabel.snp.right).offset(8)
            make.bottom.equalTo(-8)
        }

        maxPriceLabel = UILabel()
        maxPriceLabel.textColor = .black
        maxPriceLabel.textAlignment = .left
        maxPriceLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(maxPriceLabel)
        maxPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(maxLabel.snp.right)
            make.bottom.equalTo(-8)
            make.width.equalTo(70)
        }
    }
}
