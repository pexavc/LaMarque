//
//  BootExpedition.swift
//  
//
//  Created by PEXAVC on 12/31/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct BootExpedition: GraniteExpedition {
    typealias ExpeditionEvent = EnvironmentEvents.Boot
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let page: EnvironmentConfig.Page = state.config.kind.page
        
        var windowsConfig: [[WindowConfig]] = []
        //
        var cols: [Int] = .init(repeating: 0, count: page.windows.first?.count ?? EnvironmentConfig.maxWindows.width.asInt)
        cols = cols.enumerated().map { $0.offset }
        //
        
        for row in 0..<min(page.windows.count, EnvironmentConfig.maxWindows.height.asInt) {
            var windowRowConfig: [WindowConfig] = []
            
            for col in cols {
                guard row < page.windows.count,
                      col < page.windows[row].count else { continue }
                let config: WindowConfig = .init(kind: page.windows[row][col],
                                                 index:
                                                    .init(x: col,
                                                          y: row)
                                                 )
                
                windowRowConfig.append(config)
            }
            
            guard windowRowConfig.isNotEmpty else { continue }
            windowsConfig.append(windowRowConfig)
        }
        
        state.activeWindowConfigs = windowsConfig
        
        GraniteLogger.info("setup windows for Environment - \(state.config.kind)\nwindows: \(state.activeWindowConfigs.flatMap { $0 }.count)\nself:\(String(describing: self))", .expedition, focus: true)
      /*
         
         
         [ 0  0  0  0  0  0 ]
         [ 0  0  0  0  0  0 ]
         [ 0  0  0  0  0  0 ]
         
         
         */
        
        GraniteLogger.info("boot", .expedition, focus: true)
    }
}
