//
//  GraniteDisclaimerState.swift
//  
//
//  Created by PEXAVC on 1/15/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class GraniteDisclaimerState: GraniteState {
    var colors: [Color]
    let text: String
    let opacity: Double
    let action: (() -> Void)?
    let cancel: (() -> Void)?
    
    let leftButtonText: String = "cancel"
    let rightButtonText: String = "okay"
    
    var isActionable: Bool {
        action != nil
    }
    
    public init(_ text: String,
                opacity: Double = 1.0,
                colors: [Color] = [Brand.Colors.marbleV2, Brand.Colors.marble],
                action: (() -> Void)? = nil,
                cancel: (() -> Void)? = nil) {
        self.text = text
        self.colors = colors
        self.opacity = opacity
        self.action = action
        self.cancel = cancel
    }
    public required init() {
        text = ""
        self.colors = [Brand.Colors.marbleV2, Brand.Colors.marble]
        self.opacity = 1.0
        self.action = nil
        self.cancel = nil
    }
}

public class GraniteDisclaimerCenter: GraniteCenter<GraniteDisclaimerState> {
    var gradients: [Color] {
        state.payload?.object as? [Color] ?? state.colors
    }
}
