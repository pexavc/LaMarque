//
//  BasicSliderState.swift
//  
//
//  Created by PEXAVC on 1/2/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class BasicSliderState: GraniteState {
    var number: Double = 0.5
}

public class BasicSliderCenter: GraniteCenter<BasicSliderState> {
}
