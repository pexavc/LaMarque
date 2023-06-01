//
//  VariablesExpedition.swift
//  
//
//  Created by PEXAVC on 1/19/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct VariablesExpedition: GraniteExpedition {
    typealias ExpeditionEvent = EnvironmentEvents.Variables
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let envSettings = connection.retrieve(\EnvironmentDependency.envSettings),
              envSettings.lf != nil else {
            return
        }
        
        state.envSettings = envSettings
        
    }
}
