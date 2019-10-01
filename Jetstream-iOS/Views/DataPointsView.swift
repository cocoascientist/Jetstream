//
//  DataPointsView.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/30/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI

struct DataPointsListView: View {
    let viewModel: DataPointsViewModel
    
    var body: some View {
        VStack {
            ForEach(self.viewModel.dataPointGroups, id: \.self) { dataPointGroup in
                VStack {
                    DataPointsGroupView(dataPointGroup: dataPointGroup)
                    Divider()
                }
            }
        }
        .padding([.top], 8.0)
        .padding([.leading, .trailing], 16.0)
    }
}

struct DataPointsGroupView: View {
    let dataPointGroup: DataPointGroup
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.dataPointGroup.first.name)
                    .fontWeight(.thin)
                    .font(Font.system(.caption).smallCaps())
                Text(self.dataPointGroup.first.value)
                    .font(.title)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(self.dataPointGroup.second.name)
                    .fontWeight(.thin)
                    .font(Font.system(.caption).smallCaps())
                Text(self.dataPointGroup.second.value)
                    .font(.title)
            }
        }
    }
}
