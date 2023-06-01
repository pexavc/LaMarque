//
//  CanvasState.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import MarbleKit

public enum CanvasStage {
    case none
    case prepared
    case running
}

public enum CanvasType {
    case snapshot
    case exhibit
}

public struct CanvasFilter {
    let effects: [MarbleEffect]
}

public class CanvasState: GraniteState {
    var stage: CanvasStage = .none
    
    var localFrame: CGRect = .init()
    var installation: Installation
    var image: GraniteImage
    var config: InstallationConfig?
    var filter: CanvasFilter = .init(effects: [.depth, .godRay])
    
    var currentTexture: MTLTexture?
    var liveTexture: MTLTexture?
    var depthTexture: MTLTexture?
    
    var glassSample: Float = 0.0
    var glassFrames: Int64 = 0
    var depthLevel: Float = 0.012
    //var lastDepthMarbleTexture: MTLTexture?
    
    var metalView: MetalView = .init()
    
    var type: CanvasType {
        config?.canvasType ?? .snapshot
    }
    
    var exhibit: Bool
    
    public init(image: GraniteImage,
                installation: Installation,
                exhibit: Bool) {
        self.image = image
        self.installation = installation
        self.exhibit = exhibit
    }
    
    public required init() {
        self.installation = .empty
        self.image = .init()
        self.exhibit = false
    }
}

public class CanvasCenter: GraniteCenter<CanvasState> {
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            PrepareCanvasExpedition.Discovery(),
            RunCanvasExpedition.Discovery(),
            CanvasFilterExpedition.Discovery(),
            GlassCanvasExpedition.Discovery(),
            DepthDebugCanvasExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(CanvasEvents.Prepare(), .dependant)
        ]
    }
    
    public override var behavior: GraniteEventBehavior {
        .broadcastable
    }
}

//var atlas: Atlas = .init()
//func begin() {
//    atlas.consumer = { _ in
//        self.sendEvent(CanvasMLEvents.CanvasTest())
//    }
//    atlas.start()
//}
