//
//  HourlyForecastView.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/30/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct HourlyForecastListView: View {
    let viewModel: HourlyForecastListViewModel
    
    var body: some View {
        ScrollView([.horizontal]) {
            HStack {
                ForEach(self.viewModel.forecasts, id: \.self) { hourlyViewModel in
                    HourlyForecastView(viewModel: hourlyViewModel)
                }
            }
        }
    }
}

struct HourlyForecastView: View {
    let viewModel: HourlyForecastViewModel
    
    var body: some View {
        VStack {
            Text(self.viewModel.timeOfDay)
            Text(self.viewModel.icon.weatherSymbol)
                .font(Font.custom("Weather Icons", size: 26))
                .padding([.top, .bottom], 4.0)
            Text(self.viewModel.temperature)
        }
        .padding()
    }
}
