//
//  CoinTableViewCell.swift
//  Crypto
//
//  Created by Dan Vleju on 13.05.2021.
//

import UIKit
import Combine

final class CoinTableViewCell: UITableViewCell {

    static let height: CGFloat = 80

    private let fadeDuration: TimeInterval = 0.5
    private let freezeDuration: TimeInterval = 1

    var coinImageView: UIImageView!
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var priceContainerView: UIView!
    var priceLabel: UILabel!
    var minLabel: UILabel!
    var maxLabel: UILabel!
    var minPriceLabel: UILabel!
    var maxPriceLabel: UILabel!

    private var fadeInAnimationTimer: Timer?
    private var freezeAnimationTimer: Timer?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: CoinsListItemViewModel, priceAnimationStateShouldChange: @escaping (_ state: PriceAnimationState?) -> ()) {
        coinImageView.setImageFromURLString(viewModel.imageUrl)
        nameLabel.text = viewModel.name
        codeLabel.text = viewModel.code
        priceLabel.text = "$ \(viewModel.price.commaRepresentation)"
        minPriceLabel.text = "$ \((viewModel.minPrice ?? viewModel.price).commaRepresentation)"
        maxPriceLabel.text = "$ \((viewModel.maxPrice ?? viewModel.price).commaRepresentation)"
        handlePriceAnimation(viewModel.priceAnimation, priceAnimationStateShouldChange: priceAnimationStateShouldChange)
    }

    private func handlePriceAnimation(_ animation: PriceAnimation?, priceAnimationStateShouldChange: @escaping (_ state: PriceAnimationState?) -> ()) {
        invalidateAnimationTimers()
        guard let animation = animation else {
            priceContainerView.backgroundColor = .clear
            priceLabel.textColor = .black
            return
        }

        switch animation.state {
        case .fadeIn:
            priceContainerView.backgroundColor = .clear
            priceLabel.textColor = .white

            UIView.animate(withDuration: fadeDuration) {
                self.priceContainerView.backgroundColor = self.backgroundColor(for: animation.type)
            }

            fadeInAnimationTimer = createAndRunTimer(with: fadeDuration) {
                priceAnimationStateShouldChange(animation.state.nextState)
            }

        case .freeze:
            priceContainerView.backgroundColor = backgroundColor(for: animation.type)
            priceLabel.textColor = .white

            freezeAnimationTimer = createAndRunTimer(with: freezeDuration) {
                priceAnimationStateShouldChange(animation.state.nextState)
            }
        }
    }

    private func backgroundColor(for animationType: PriceAnimationType) -> UIColor {
        switch animationType {
        case .increase:
            return .green
        case .decrease:
            return .red
        }
    }

    private func createAndRunTimer(with duration: TimeInterval, blockAction: @escaping () -> ()) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: duration,
                                                    repeats: false,
                                                    block: { _ in blockAction() })
        RunLoop.current.add(timer, forMode: .default)

        return timer
    }

    private func invalidateAnimationTimers() {
        fadeInAnimationTimer?.invalidate()
        fadeInAnimationTimer = nil
        freezeAnimationTimer?.invalidate()
        freezeAnimationTimer = nil
    }
}
