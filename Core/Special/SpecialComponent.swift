//
//  SpecialComponent.swift
//
//
//  Created by PEXAVC on 1/11/21.
//  Copyright (c) 2021 Stoic Collective, LLC. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

//[CAN REMOVE]
public struct SpecialComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<SpecialCenter, SpecialState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Used to be a 3D Model here, now it's removed.")
//            state.scene.onAppear(perform: {
//                state.scene.run()
//            }).onDisappear(perform: {
//                state.scene.clear()
//            })
        }
    }
}
