//
//  DayForecastView.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/30/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct DayForecastListView: View {
    let viewModel: DayForecastListViewModel
    
    var body: some View {
        VStack {
            ForEach(self.viewModel.forecasts, id: \.self) { dayViewModel in
                DayForecastView(viewModel: dayViewModel)
            }
        }
    }
}

struct DayForecastView: View {
    let viewModel: DayForecastViewModel
    
    var body: some View {
        HStack {
            Text(self.viewModel.dayOfWeek)
            Spacer()
            Text(self.viewModel.icon.weatherSymbol)
                .font(Font.custom("Weather Icons", size: 26))
            Spacer()
            Text(self.viewModel.low)
                .padding([.trailing], 4.0)
            Text(self.viewModel.high)
        }
        .padding()
    }
}
