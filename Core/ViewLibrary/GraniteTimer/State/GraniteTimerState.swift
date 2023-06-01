//
//  GraniteTimerState.swift
//  stoic
//
//  Created by PEXAVC on 2/22/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum GraniteTimerType {
    case countup
    case countdown
}
public enum GraniteTimerStyle {
    case minimal
    case none
}
public class GraniteTimerState: GraniteState {
    let initial: Date
    let type: GraniteTimerType
    let limit: Int
    let style: GraniteTimerStyle
    let empty: Bool
    
    public init(initial: Date, type: GraniteTimerType, limit: Int, style: GraniteTimerStyle) {
        self.initial = initial
        self.type = type
        self.limit = limit
        self.style = style
        self.empty = false
    }
    
    public init(empty: Bool) {
        self.initial = .today
        self.type = .countup
        self.limit = .max
        self.style = .none
        self.empty = true
    }
    
    public required init() {
        self.initial = .today
        self.type = .countup
        self.limit = .max
        self.style = .none
        self.empty = false
    }
}

public class GraniteTimerCenter: GraniteCenter<GraniteTimerState> {
}
