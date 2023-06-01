//
//  Routes.swift
//   (iOS)
//
//  Created by PEXAVC on 1/6/21.
//

import Foundation
import GraniteUI
import SwiftUI

public indirect enum Route: ID, GraniteRoute, Equatable {
    case exhibition(ExhibitionIntent)
    case verify(VerifyIntent)
    case settings
    case debug(Route)
    case none
    
    var isDebug: Bool {
        switch self{
        case .debug:
            return true
        default:
            return false
        }
    }
    
    var isExhibition: Bool {
        switch self {
        case .exhibition:
            return true
        default:
            return false
        }
    }
    
    var isVerify: Bool {
        switch self {
        case .verify:
            return true
        default:
            return false
        }
    }
    
    var isShowcase: Bool {
        switch self {
        case .exhibition(let intent):
            return intent == .showcase
        default:
            return false
        }
    }
    
    public var host: GraniteAdAstra.Type? {
        MainCenter.route
    }
    
    public var home: GraniteAdAstra.Type? {
        EnvironmentCenter.route
    }
}

