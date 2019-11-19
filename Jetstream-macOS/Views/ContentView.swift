//
//  CustomView.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI
import JetstreamCore
import JetstreamPresentation

struct ContentView: View {
    @FetchRequest(fetchRequest: Weather.defaultFetchRequest()) var conditions: FetchedResults<Weather>
    
    var body: some View {
        // https://forums.developer.apple.com/thread/118172
        
        if let weather = conditions.first {
            let viewModel = WeatherViewModel(weather: weather)
            let weatherView = MenuWeatherView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .background(Color.yellow)
            return AnyView(weatherView)
        } else {
            return AnyView(Text("Empty"))
        }
    }
}

struct MenuWeatherView: View {
    private let viewModel: WeatherViewModel
    
    public init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ConditionsView(viewModel: self.viewModel)
                .background(Color.red)
            ForecastsView(viewModel: self.viewModel.dayForecastListViewModel)
                .background(Color.blue)
        }
    }
}


