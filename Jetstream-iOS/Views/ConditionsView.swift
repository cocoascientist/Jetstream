//
//  ConditionsView.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 8/24/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI
import JetstreamKit

struct ConditionsView: View {
    let weather: WeatherDescribing
    
    var body: some View {
        VStack {
            Text("\(weather.city ?? "XX"), \(weather.state ?? "XX")")
                .font(.title)
            Text(weather.conditionsSummary ?? "")
        }
    }
}

struct ConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionsView(weather: MockWeather())
    }
}

struct MockWeather: WeatherDescribing {
    var city: String? { return "City" }
    var state: String? { return "State" }
    
    var conditionsSummary: String? { return "cloudy outside" }
}
