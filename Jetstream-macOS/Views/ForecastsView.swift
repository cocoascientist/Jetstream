//
//  ForecastsView.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/20/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI
import JetstreamPresentation
import JetstreamCore

struct ForecastsView: View {
    private let viewModel: DayForecastListViewModel
    
    public init(viewModel: DayForecastListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                ForecastView(viewModel: self.viewModel.forecasts[index])
            }
        }
    }
}

struct ForecastView: View {
    private let viewModel: DayForecastViewModel
    
    public init(viewModel: DayForecastViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text(viewModel.dayOfWeek)
                .font(Font.system(.caption).smallCaps())
            Text(viewModel.icon.weatherSymbol)
                .font(Font.custom("Weather Icons", size: 20))
            Text(viewModel.high)
            Text(viewModel.low)
        }
    }
}
