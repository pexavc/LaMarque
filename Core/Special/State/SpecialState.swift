//
//  SpecialState.swift
//  
//
//  Created by PEXAVC on 1/11/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import SceneKit

public class SpecialState: GraniteState {
    var scene: SceneKitView = SceneKitView(nodes: SCNNodes().nodes, bgColor: Brand.Colors.black)
}

public class SpecialCenter: GraniteCenter<SpecialState> {
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            SetupSceneExpedition.Discovery()
        ]
    }
}

extension SpecialState {
    struct SCNNodes {
        var nodes: [SCNNode] {
            [cameraNode, lightNode, ambientLightNode, alexanderNode]
        }
        
        var cameraNode: SCNNode {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 24)
            cameraNode.rotation = SCNVector4(0, 0, 0, 0)
            return cameraNode
        }
        
        var lightNode: SCNNode {
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.type = .omni
            lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
            
            return lightNode
        }
        
        var ambientLightNode: SCNNode {
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light!.type = .ambient
            #if os(iOS)
            ambientLightNode.light!.color = UIColor.darkGray
            #else
            ambientLightNode.light!.color = NSColor.darkGray
            #endif
            
            return ambientLightNode
        }
        
        var alexanderNode: SCNNode {
            let path = Bundle.main.path(forResource: "alexander", ofType: "obj")
            let url = NSURL(fileURLWithPath: path!)
            let materialPath = Bundle.main.path(forResource: "alexander", ofType: "jpg")
            let materialURL = NSURL(fileURLWithPath: materialPath!)
            let asset = MDLAsset(url: url as URL)
            
            
            let scatteringFunction = MDLScatteringFunction.init()
            let material = MDLMaterial.init(name: "baseMaterial", scatteringFunction: scatteringFunction)
            
            let property = MDLMaterialProperty.init(name: "baseMaterial", semantic: .baseColor, url: materialURL as URL)
            material.setProperty(property)
            
            for mesh in ((asset.object(at: 0) as? MDLMesh)?.submeshes as? [MDLSubmesh]) ?? [] {
              mesh.material = material
            }
            
            asset.loadTextures()
            
            guard let object = asset.object(at: 0) as? MDLMesh
                 else { fatalError("Failed to get mesh from asset.") }
            
            let alexanderNode = SCNNode(mdlObject: object)
            return alexanderNode
        }
    }
}
