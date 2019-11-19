//
//  ConditionsView.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/19/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI
import JetstreamCore
import JetstreamPresentation

struct ConditionsView: View {
    private let viewModel: WeatherViewModel
    
    public init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            TopView(viewModel: self.viewModel)
            Divider()
            BottomView(viewModel: self.viewModel)
        }
    }
}

struct TopView: View {
    let viewModel: WeatherViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.citystate)
                    .font(.caption)
                Text(viewModel.conditionsSummary)
                    .font(.body)
                    .bold()
            }
            .padding([.all], 2.0)
            Spacer()
            VStack {
                HStack {
                    Text(viewModel.icon.weatherSymbol)
                        .font(Font.custom("Weather Icons", size: 20))
                    Text(viewModel.currentTemperature)
                        .font(.headline)
                }
            }
            .padding([.all], 2.0)
        }
    }
}

struct BottomView: View {
    let viewModel: WeatherViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                // wind symbol
                Text("\u{f050}".weatherSymbol)
                    .font(Font.custom("Weather Icons", size: 20))
                VStack(alignment: .leading, spacing: 0.0) {
                    HStack(alignment: .lastTextBaseline, spacing: 1.0) {
                        Text(viewModel.windSpeed)
                            .font(.subheadline)
                        Text("MPH")
                            .font(Font.system(.caption).smallCaps())
                    }
                    Text(viewModel.windBearing)
                        .font(Font.system(.caption).smallCaps())
                }
            }
            .padding([.all], 2.0)
            Spacer()
            HStack {
                // water drops symbol
                Text("\u{f04e}".weatherSymbol)
                    .font(Font.custom("Weather Icons", size: 20))
                VStack(alignment: .leading) {
                    Text("58%")
                        .font(.caption)
                    Text("Humidity")
                        .font(Font.system(.caption).smallCaps())
                }
            }
            .padding([.all], 2.0)
        }
    }
}
