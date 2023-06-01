//
//  RouteExpedition.swift
//  stoic
//
//  Created by PEXAVC on 3/5/21.
//

import Foundation
import GraniteUI
import Combine

struct RouteExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MainEvents.RequestRoute
    typealias ExpeditionState = MainState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        connection.retrieve(\RouterDependency.router)?.request(event.route)
        //TODO: Used as a proxy to refresh, but maybe can be used for something useful?
    }
}
