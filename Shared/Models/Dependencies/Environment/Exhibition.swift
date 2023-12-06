//
//  Exhibition.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI
import SwiftUI
import MarbleKit
import CoreML

public struct Exhibition {
    var listening: Bool = false
    var atlas: Atlas? = nil
    let model: GraniteML<MLMultiArray>? = GraniteML<MLMultiArray>(MiDaS.self, input: .buffer)
    var intent: ExhibitionIntent = .none
}
