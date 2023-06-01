//
//  DecodeMarqueExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/27/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct DecodingLaMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Decoding
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        let url = URL.init(fileURLWithPath: event.path)
        if let data = try? Data.init(contentsOf: url) {
            if let image = GraniteImage.init(data: data) {
                
                //[CAN REMOVE] uses marque for decoding
//                state.kit.search(image) { result in
//                    let decoded = LaMarqueEvents.Decoding.Result.init(installation: .init(result.parts, data: data))
//
//                    DispatchQueue.main.async {
//                        connection.request(decoded)
//                    }
//                }
            }
        }
    }
}

struct DecodingResultLaMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Decoding.Result
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard event.valid else {
            state.stage = .invalidMarque
            return
        }
        
        state.verification = event.installation
        
        state.stage = .verified
    }
}
