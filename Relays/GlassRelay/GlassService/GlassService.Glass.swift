//
//  MarbleService.Glass.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//

import Foundation
import GlassKit
import GraniteUI

extension GlassService: GlassMicEngineDelegate {
    public func audioFileDisposed() {
        
    }
    
    public func getSignal(fromMicrophone samples: [Float], sum: Float) {
        operation.addOperation { [weak self] in
            self?.connection?.request(GlassEvents.Glass.Ping.init(sample: sum))
        }
    }
}

extension GlassService: GlassPlayerEngineDelegate {
    public func startLeVerre() {
        engine.startLeVerre()
    }
    
    public func getSignal(fromPlayer samples: [Float], sum: Float) {
        operation.addOperation { [weak self] in
            self?.connection?.request(GlassEvents.Glass.Ping.init(sample: sum))
        }
    }
}
