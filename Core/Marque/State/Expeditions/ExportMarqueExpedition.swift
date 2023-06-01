//
//  ExportMarqueExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/27/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct ExportLaMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Export
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let installation = state.sharing else { return }
        
//        state.kit.encode(installation.signature,
//                         withObject: installation.originalImage) { result in
//            
//            connection.request(LaMarqueEvents.Encoding.init(data: result))
//        }
        
        state.stage = .preparingExport
    }
}

struct EncodingLaMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Encoding
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.encoding = event.data
        state.stage = .preparedExport
    }
}
