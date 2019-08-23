//
//  File.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 8/9/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import JetstreamKit

class ContentViewModel {
    
    private let weatherService: WeatherService
    private var cancelables: [AnyCancellable] = []
    
    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
    }
}

extension ContentViewModel: ObservableObject {
    typealias PublisherType = AnyPublisher<Void, Never>
    
    var willChange: AnyPublisher<Void, Never> {
        return weatherService.currentWeather
            .map { _ in return () }
            .eraseToAnyPublisher()
    }
}
