//
//  GraniteLoadingComponent.swift
//  
//
//  Created by PEXAVC on 1/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraniteLoadingComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraniteLoadingCenter, GraniteLoadingState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 160,
                           height: 160,
                           alignment: .center)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
