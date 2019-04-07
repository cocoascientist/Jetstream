//
//  WeatherSceneView.swift
//  Jetstream
//
//  Created by Andrew Shepard on 6/16/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

import UIKit
import SceneKit

//private let blueColor = UIColor.hexColor("#72bdff")
private let purpleColor = UIColor.hexColor("#5d3f70")
private let grayColor = UIColor.hexColor("#abb8cc")

class WeatherSceneView: SCNView {    
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private var particles: [String] {
        return ["Cloud1", "Cloud6"]
//        return ["Stars1"]
//        return ["Rain"]
    }
    
    private func setupScene() {
        let scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(-10, -1, 3)
//        cameraNode.position = SCNVector3Make(0, -5, 8)
        
        scene.rootNode.addChildNode(cameraNode)
        
        particles.forEach { name in
            guard let particle = SCNParticleSystem(named: name, inDirectory: nil) else {
                fatalError("missing particle system")
            }
            scene.rootNode.addParticleSystem(particle)
        }
        
        self.backgroundColor = blueColor
        self.pointOfView = cameraNode
        self.scene = scene
    }
}
