//
//  WeatherView.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 8/24/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct WeatherView: View {
    let viewModel: WeatherViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {
                    ConditionsView(viewModel: self.viewModel)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height / 2
                        )
                    Divider()
                    HourlyForecastListView(viewModel: self.viewModel.hourlyForecastListViewModel)
                    Divider()
                    DayForecastListView(viewModel: self.viewModel.dailyForecastListViewModel)
                    Divider()
                    SummaryForecastView(viewModel: self.viewModel.summaryForecastViewModel)
                        .padding([.bottom], 32.0)
                    Divider()
                }
            }
        }
    }
}

struct SummaryForecastView: View {
    let viewModel: SummaryViewModel
    
    var body: some View {
        VStack {
            Text(self.viewModel.summary)
        }
        .padding()
    }
}
