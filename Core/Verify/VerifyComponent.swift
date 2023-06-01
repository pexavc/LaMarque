//
//  VerifyComponent.swift
//  marble
//
//  Created by PEXAVC on 2/25/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct VerifyComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<VerifyCenter, VerifyState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            LaMarqueComponent(state: .init(.verify))
                .listen(to: command)
                .attach(to: command)
        }
    }
}
