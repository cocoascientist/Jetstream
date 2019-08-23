//
//  ContentView.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 8/6/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI
import JetstreamKit

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    @FetchRequest(fetchRequest: Weather.defaultFetchRequest()) var conditions: FetchedResults<Weather>
    
    var body: some View {
        if let weather = conditions.first {
            return Text("Weather: \(weather)")
        } else {
            return Text("Empty")
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
