//
//  CanvasEvents.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct CanvasEvents {
    public static var canvasQueue: DispatchQueue? = {
        .init(label: "canvas.run.queue",
              qos: .background,
              attributes: [ .concurrent ],
              autoreleaseFrequency: .workItem)
    }()
    
    public struct Prepare: GraniteEvent {
        let update: Bool
        let installation: Installation
        
        public init() {
            update = false
            installation = .empty
        }
        
        public init(installation: Installation) {
            self.installation = installation
            update = true
        }
        
        public var async: DispatchQueue? {
            CanvasEvents.canvasQueue
        }
    }
    public struct Run: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct Filter {
        public struct Update: GraniteEvent {
            let filter: CanvasFilter
            
            public var behavior: GraniteEventBehavior {
                .quiet
            }
        }
    }
    public struct Depth: GraniteEvent {
        
        public struct Adjust: GraniteEvent {
            let value: Float
            
            public var behavior: GraniteEventBehavior {
                .quiet
            }
        }
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct Glass: GraniteEvent {
        let sample: Float
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
}
