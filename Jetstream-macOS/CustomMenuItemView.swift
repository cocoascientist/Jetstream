//
//  CustomMenuItemView.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/15/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI

class CustomMenuItemView<Content>: NSView where Content: View {
    private var hostingView: NSHostingView<Content>

    init(frame: NSRect, view: Content) {
        hostingView = NSHostingView(rootView: view)

        super.init(frame: frame)
        addSubview(hostingView)
        hostingView.frame = bounds
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
