//
//  ClockRelay.swift
//  
//
//  Created by PEXAVC on 12/19/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct MarqueRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<MarqueCenter, MarqueState> = .init()
    
    public init() {
    }
    
    public func setup() {
    }
    
    public func clean() {}
    
    public func cancel() {
        
    }
}
