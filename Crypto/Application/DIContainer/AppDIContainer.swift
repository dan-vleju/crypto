//
//  AppDIContainer.swift
//  Crypto
//
//  Created by Dan Vleju on 13.05.2021.
//

import Foundation

final class AppDIContainer {

    func makeCoinsSceneDIContainer() -> CoinsSceneDIContainer {
        return CoinsSceneDIContainer()
    }
}
