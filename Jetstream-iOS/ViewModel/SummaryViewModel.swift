//
//  SummaryViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/30/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamKit

struct SummaryViewModel {
    let forecast: Forecast?
    
    var summary: String {
        return forecast?.summary ?? ""
    }
}
