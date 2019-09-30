//
//  ConditionsView.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/30/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct ConditionsView: View {
    let viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Text(self.viewModel.citystate)
                .font(.largeTitle)
                .bold()
                .padding([.top], 60)
            Text(self.viewModel.conditionsSummary)
                .font(.headline)
                .padding([.top], 8)
            Text(self.viewModel.currentTemperature)
                .font(Font.system(size: 88))
                .fontWeight(Font.Weight.light)
                .padding([.top], 8)
            Spacer()
            TodayConditionsView(viewModel: self.viewModel.todayConditionsViewModel)
                .padding([.bottom], 4)
        }
    }
}

struct TodayConditionsView: View {
    let viewModel: TodayConditionsViewModel
    
    var body: some View {
        HStack {
            Text(self.viewModel.dayOfWeek)
                .fontWeight(.bold)
                .padding([.leading], 8)
            Text("Today")
            Spacer()
            Text(self.viewModel.lowTemperature)
            Text(self.viewModel.highTemperature)
                .padding([.trailing], 8)
        }
    }
}
