//
//  CanvasComponent.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import MarbleKit

public struct CanvasComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<CanvasCenter, CanvasState> = .init()
    
    public var interaction = GraniteInteraction.Tranlate.publisher
    
    public init(){}
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry -> Proxy in
                let frame = geometry.frame(in: CoordinateSpace.local)
                state.localFrame = frame
                return Proxy()
            }
            
            MetalViewUI(
                texture: _state.liveTexture,
                metalView: _state.metalView) { gestures in
                
                if let oldGestures = state.config?.environment.gestures {
                            
                    let update = MarbleCatalog.Environment.Gestures.prepare(
                        oldGestures,
                        willSet: (
                            gestures.pan.state.asMarbleEvent,
                            gestures.scale.pinch.state.asMarbleEvent,
                            gestures.pan.state.asMarbleEvent,
                            gestures.scroll.state))
                    
                    
                    if let pan = update.identityPan {

                        gestures.pan.setTranslation(
                            pan,
                            in: _state.metalView.wrappedValue)
                    }

//                    if let pinch = update.identityPinch {
//                        #if os(macOS)
//
//                        gestures.pinch.magnification = min(gestures.pinch.magnification, pinch)
//                        #else
//                        gestures.pinch.scale = min(gestures.pinch.scale, pinch)
//
//                        #endif
//                    }

                    if let rotate = update.identityRotate {
                        gestures.rotate.rotation = rotate
                    }
                }
                state.config?.environment.updateGestures(
                    .init(
                        pinch: (gestures.scale.pinch.state.asMarbleEvent,
                                gestures.scale.scale),
                        pan: (gestures.pan.state.asMarbleEvent,
                              gestures.pan.translation(in: _state.metalView.wrappedValue)),
                        tap: nil,
                        rotate: ((gestures.rotate.rotation != .zero) ? gestures.rotate.state.asMarbleEvent : nil,
                        gestures.rotate.rotation),
                        scroll: (gestures.scroll.state != .changed ? nil : MarbleUXEvent.changed, gestures.scroll.normalizedY)))
            }
            
//            VStack {
//                
//                
//                HStack {
//                    GraniteButtonComponent.init(state: .init("+", action: {sendEvent(CanvasEvents.Depth.Adjust.init(value: 0.01))}))
//                    GraniteButtonComponent.init(state: .init("-", action: {sendEvent(CanvasEvents.Depth.Adjust.init(value: -0.01))}))
//                }
//                Spacer()
//            }
        }
    }
}
