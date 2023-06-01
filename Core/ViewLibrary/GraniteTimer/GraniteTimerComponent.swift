//
//  GraniteTimerComponent.swift
//  stoic
//
//  Created by PEXAVC on 2/22/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraniteTimerComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraniteTimerCenter, GraniteTimerState> = .init()
    
    public init () {}
    
    @State var timePassed = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        
        if state.empty {
            GraniteText("00:00:00",
                        .footnote,
                        .regular,
                        .leading)
        } else {
            Passthrough {
                switch state.style {
                case .minimal:
                    GraniteText("\(state.initial.asStringTimedWithTime((self.timePassed) * (state.type == .countup ? 1 : -1)))",
                                .footnote,
                                .regular,
                                .leading)
                default:
                    GraniteText("\(state.initial.asStringTimedWithTime((self.timePassed) * (state.type == .countup ? 1 : -1)))",
                                .headline,
                                .bold,
                                style: .init(gradient: [Brand.Colors.black.opacity(0.75),
                                                        Brand.Colors.black.opacity(0.36)]))
                }
            }
            .onReceive(timer) { _ in
                if timePassed <= state.limit {
                    timePassed += 1 //tate.type == .countup ? 1 : -1
                }
            }
        }
    }
}
