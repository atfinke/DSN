//
//  DishView.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import SceneKit

class DishView: UIView {

    // MARK: Properties

    private let sceneView = SCNView()

    private var dish: SCNNode {
        return sceneView.scene!.rootNode.childNode(withName: "dishro", recursively: true)!
    }

    private var group: SCNNode {
        return sceneView.scene!.rootNode.childNode(withName: "Group", recursively: true)!
    }

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)

        sceneView.preferredFramesPerSecond = 30
        sceneView.backgroundColor = UIColor.clear
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.scene = SCNScene(named: "art.scnassets/dish.scn")!

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        sceneView.scene?.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        sceneView.scene?.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        sceneView.scene?.rootNode.addChildNode(ambientLightNode)

        addSubview(sceneView)
        let constraints = [
            sceneView.leftAnchor.constraint(equalTo: leftAnchor),
            sceneView.rightAnchor.constraint(equalTo: rightAnchor),
            sceneView.topAnchor.constraint(equalTo: topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    func rotate() {
        let eulerAnimation = CABasicAnimation(keyPath: "eulerAngles")
        eulerAnimation.toValue = NSValue(scnVector3: SCNVector3(Double.pi / 4, 0, 0))
        eulerAnimation.duration = 2
        eulerAnimation.isRemovedOnCompletion = false
        eulerAnimation.fillMode = kCAFillModeForwards
        dish.addAnimation(eulerAnimation, forKey: nil)

        let y = arc4random_uniform(2) == 0 ? 1.0 : -1.0
        let rotateAnimation = CABasicAnimation(keyPath: "rotation")
        rotateAnimation.toValue = NSValue(scnVector4: SCNVector4(0.0, y, 0.0, Double.pi * 2))
        rotateAnimation.duration = 10
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        group.addAnimation(rotateAnimation, forKey: nil)
    }

    func update(status: AntennaStatus?) {
        guard let status = status,
            let azimuthAngle = Double(status.azimuthAngle),
            let elevationAngle = Double(status.elevationAngle) else {
                dish.eulerAngles = SCNVector3(0, 0, 0)
                group.eulerAngles = SCNVector3(0, 0, 0)
                animateDish(to: 0, group: 0)
                return
        }

        var adjustedElevationAngle = elevationAngle / 180.0 * Double.pi - Double.pi / 2
        if adjustedElevationAngle > Double.pi {
            adjustedElevationAngle -= Double.pi * 2
        }

        var adjustedAzimuthAngle = azimuthAngle / 180.0 * Double.pi
        if adjustedAzimuthAngle > Double.pi {
            adjustedAzimuthAngle -= Double.pi * 2
        }

        guard fabs(adjustedElevationAngle - Double(dish.eulerAngles.x)) > 0.1 ||
            fabs(adjustedAzimuthAngle - Double(group.eulerAngles.y)) > 0.1 else {
                return
        }

        animateDish(to: adjustedElevationAngle, group: adjustedAzimuthAngle)
    }

    private func animateDish(to elevationAngle: Double, group azimuthAngle: Double) {
        sceneView.scene?.isPaused = false

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 2.5

        dish.eulerAngles = SCNVector3(elevationAngle, 0, 0)
        group.eulerAngles = SCNVector3(0, azimuthAngle, 0)
        
        SCNTransaction.completionBlock = {
            self.sceneView.scene?.isPaused = true
        }
        
        SCNTransaction.commit()
    }
    
}
