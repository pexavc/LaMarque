//
//  VerifySharedAssetExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/24/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct VerifySharedAssetExpedition: GraniteExpedition {
    typealias ExpeditionEvent = VerifyEvents.Shared
    typealias ExpeditionState = VerifyState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        #if os(iOS)
        switch state.intent {
        case .check(let share):
            let fileName = "la-marque-verify"
            guard let fileURL = UIImage.iosImagePathURL?.appendingPathComponent(fileName) else { return }
            if let imageData = share.image?.pngData() {
                try? imageData.write(to: fileURL, options: .atomic)
                
                if let path = UIImage.iosImagePathURL?.appendingPathComponent(fileName).path {
                    connection.hear(event: LaMarqueEvents.Decoding.init(path: path))
                }
            }
        case .none:
            break
        }
        #endif
    }
}
