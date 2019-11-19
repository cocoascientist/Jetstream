//
//  SummaryViewModel.swift
//  Jetstream-iOS
//
//  Created by Andrew Shepard on 9/30/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import JetstreamCore

public struct SummaryViewModel {
    let forecast: Forecast?
    
    public var summary: String {
        return forecast?.summary ?? ""
    }
}
