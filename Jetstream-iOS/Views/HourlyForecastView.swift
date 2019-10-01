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
            .padding([.top, .bottom], 8.0)
            .padding([.leading, .trailing], 16.0)
        }
    }
}

struct HourlyForecastView: View {
    let viewModel: HourlyForecastViewModel
    
    var body: some View {
        VStack {
            Text(self.viewModel.timeOfDay)
                .font(Font.system(.body).smallCaps())
                .padding([.leading, .trailing], 2.0)
//                .layoutPriority(1)
            Text(self.viewModel.icon.weatherSymbol)
                .font(Font.custom("Weather Icons", size: 26))
                .padding([.top, .bottom], 4.0)
            Text(self.viewModel.temperature)
        }
    }
}
