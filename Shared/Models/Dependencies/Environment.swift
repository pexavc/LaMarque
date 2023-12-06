//
//  Environment.swift
//  
//
//  Created by PEXAVC on 1/7/21.
//

import Foundation
import GraniteUI
import SwiftUI

class EnvironmentDependency: GraniteDependable {
    var home: Home = .init()
    
    var user: User = .init()
    
    var exhibition: Exhibition = .init()
    
    var envSettings: EnvironmentStyle.Settings = .init()
    
}

extension EnvironmentStyle {
    public struct Settings: Equatable {
        public struct LocalFrame: Equatable {
            let data: CGRect
        }
        
        var lf: LocalFrame? = nil
    }
}
