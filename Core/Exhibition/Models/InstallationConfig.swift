//
//  InstallationConfig.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine
import MarbleKit

public class InstallationConfig {

    public init(canvasType: CanvasType = .snapshot) {
        engines = .init()
        environment = .init(
            actions: .init(
                isPaused: false,
                isRestarting: false),
            gestures: .init())
        self.canvasType = canvasType
    }
    
    public struct Engines {
        let marble: MarbleEngine = .init()
        
        public struct Info {
        }
        
        var info: Info = .init()
    }
    
    let engines: Engines
    var assistant: MetalAssistant = .init(
        referenceSize: MarbleCatalog.Const.defaultRes,
        format: .rgba8Unorm,
        mode: .aspectFitTighten)
    var assistantExpand: MetalAssistant = .init(
        referenceSize: MarbleCatalog.Const.defaultRes,
        format: .rgba8Unorm,
        mode: .aspectFill)
    var assistantAdaptive: MetalAssistant = .init(
        referenceSize: MarbleCatalog.Const.defaultRes,
        format: .rgba8Unorm,
        mode: .aspectFillAdaptive)
    
    var environment: MarbleCatalog.Environment
    
    var depthAssistant: MetalAssistant = .init(
        referenceSize: MarbleCatalog.Const.defaultRes,
        format: .r8Unorm,
        floatFormat: .r16Float,
        makeTextureView: false,
        mode: .aspectFill)
    
    var liveLayers: [MarbleLayer] = []
    
    var debug: Bool = false
    
    func updateAssistantAdaptive(_ size: CGSize) {
        assistantAdaptive = .init(
            referenceSize: size,
            format: .rgba8Unorm,
            mode: .aspectFillAdaptive)
        GraniteLogger.info("updateAssitantAdaptive: \(size)", .utility, focus: true)
    }
    
    func updateAssistantExpand(_ size: CGSize) {
        assistantExpand = .init(
            referenceSize: size,
            format: .rgba8Unorm,
            mode: .aspectFill)
        GraniteLogger.info("updateAssistantExpand: \(size)", .utility, focus: true)
    }
    
    func updateAssistantDepth(_ size: CGSize) {
        depthAssistant = .init(
            referenceSize: size,
            format: .r8Unorm,
            floatFormat: .r16Float,
            makeTextureView: false,
            mode: .stretch)
        GraniteLogger.info("updateAssistantDepth: \(size)", .utility, focus: true)
    }
    
    var canvasType: CanvasType = .snapshot
    
    /******  debug *********/
    
    var initialLaunch: Bool = true
    
    var counter: Int = 0
}
