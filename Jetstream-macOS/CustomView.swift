//
//  CustomView.swift
//  Jetstream-macOS
//
//  Created by Andrew Shepard on 11/12/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import SwiftUI

public struct DrawingView: NSViewRepresentable {
    public typealias NSViewType = DrawingViewImplementation

    public func makeNSView(context: NSViewRepresentableContext<DrawingView>) -> DrawingViewImplementation {
        return DrawingViewImplementation()
    }

    public func updateNSView(_ nsView: DrawingViewImplementation, context: NSViewRepresentableContext<DrawingView>) {
        nsView.setNeedsDisplay(nsView.bounds)
    }
}

enum DrawingType {
    case Rect
    case Circle
}

public class DrawingViewImplementation: NSView {

    var currentType = DrawingType.Rect

    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.blue.set()
        switch currentType {
        case .Rect:
            NSRect(x: 100, y: 100, width: 100, height: 100).frame()
        case .Circle:
            NSBezierPath(ovalIn: NSRect(x: 100, y: 100, width: 100, height: 100)).stroke()
        }
    }

    @IBAction func toggleDrawingType(sender: Any) {
        switch currentType {
        case .Rect:
            currentType = .Circle
        case .Circle:
            currentType = .Rect
        }
        setNeedsDisplay(bounds)
   }

    public override func mouseDown(with event: NSEvent) {
        toggleDrawingType(sender: self)
    }
}
