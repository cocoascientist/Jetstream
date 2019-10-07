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
                    .padding([.top, .bottom], 16.0)
            }
        }
        .padding([.top, .bottom], 8.0)
        .padding([.leading, .trailing], 16.0)
    }
}

struct DayForecastView: View {
    let viewModel: DayForecastViewModel
    
    var body: some View {
        GeometryReader { proxy in
            HStack() {
                Text(self.viewModel.dayOfWeek)
                    .frame(minWidth: proxy.size.width / 3, alignment: .leading)
                Spacer()
                Image(systemName: self.viewModel.icon.weatherSymbol)
                    .frame(alignment: .center)
                Spacer()
                HStack {
                    Text(self.viewModel.low)
                        .padding([.trailing], 4.0)
                    Text(self.viewModel.high)
                }
                .frame(minWidth: proxy.size.width / 3, minHeight: 16.0, alignment: .trailing)
            }
            .frame(width: proxy.size.width, alignment: .leading)
        }
    }
}
