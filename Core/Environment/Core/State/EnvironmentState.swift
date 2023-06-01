//
//  ExperienceState.swift
//  
//
//  Created by PEXAVC on 12/31/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class EnvironmentState: GraniteState {
    var activeWindowConfigs: [[WindowConfig]] = []
    
    let config: EnvironmentConfig
    
    let route: Route
    //
    var envSettings: EnvironmentStyle.Settings = .init()
    
    public init(_ route: GraniteRoute?) {
        let newRoute = route?.convert(to: Route.self) ?? .none
        self.route = newRoute
        switch newRoute {
        case .debug(let debugRoute):
            self.config = EnvironmentConfig.route(debugRoute)
        default:
            self.config = EnvironmentConfig.route(self.route)
        }
    }
    
    required init() {
        self.config = .none
        self.route = .none
    }
}

public class EnvironmentCenter: GraniteCenter<EnvironmentState> {
    //TODO:
    //Memory leaks with Subscribers that are not cancelled
    //during component re-draw phases of an application
//    var clockRelay: ClockRelay {
//        var clock = ClockRelay([StockEvents.GetMovers(),
//                                CryptoEvents.GetMovers()])
//
//        clock.enabled = false//state.config.kind == .home
//
//        return clock
//    }
    
    var maxWidth: Int {
        Array(state.activeWindowConfigs.map { $0.count }).max() ?? 0
    }
    
    var maxHeight: Int {
        state.activeWindowConfigs.count
    }
    
    var totalWindows: Int {
        state.activeWindowConfigs.flatMap { group in group.map { $0 } }.count
    }
    
    var nonIPhoneHStackSpacing: CGFloat {
        if maxWidth < 2 {
            return 0.0
        } else {
            return Brand.Padding.small
        }
    }
    
    @GraniteDependency
    var routerDependency: RouterDependency
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
//    public override var relays: [GraniteBaseRelay] {
//        [
//            clockRelay
//        ]
//    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(EnvironmentEvents.Boot()),
            .onAppear(EnvironmentEvents.Broadcasts()),
            .onAppear(EnvironmentEvents.Variables(), .dependant),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            BootExpedition.Discovery(),
            VariablesExpedition.Discovery(),
        ]
    }
    
    public var environmentMinSize: CGSize {
        return .init(
            CGFloat(state.activeWindowConfigs.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindowConfigs[0].count)*WindowStyle.minWidth,
            CGFloat(state.activeWindowConfigs.count)*WindowStyle.minHeight)
    }
    
    public var environmentMaxSize: CGSize {
        return .init(
            CGFloat(state.activeWindowConfigs.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindowConfigs[0].count)*WindowStyle.maxWidth,
            CGFloat(state.activeWindowConfigs.count)*WindowStyle.maxHeight)
    }
    
    public var environmentIPhoneSize: CGSize {
        return .init(width: .infinity,
                     height: (state.envSettings.lf?.data.height ?? EnvironmentConfig.iPhoneScreenHeight))
    }
}
