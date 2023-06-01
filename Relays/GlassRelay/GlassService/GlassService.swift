//
//  MarqueService.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI
import GlassKit

public class GlassService {
    var mic: GlassMicEngine {
        engine.mic
    }
    
    var player: GlassPlayerEngine {
        engine.player
    }
    
    var connection: GraniteConnection?
    
    let engine: GlassEngine
    
    public init() {
        engine = .init()
        engine.mic.delegate = self
        engine.player.delegate = self
    }
    
    public func preparePlayer() {
        engine.preparePlayer()
    }
    
    public func stop() {
        operation.cancelAllOperations()
        engine.stop()
        connection = nil
    }
    
    lazy var operation: OperationQueue = {
        var op = OperationQueue.init()
        op.qualityOfService = .background
        op.maxConcurrentOperationCount = 1
        op.name = "glass.ping.operation"
        return op
    }()
}
