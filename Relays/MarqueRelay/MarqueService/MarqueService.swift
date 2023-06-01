//
//  MarqueService.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI

public class MarqueService {
    
    let client: GraniteIPFS?
    
    public init() {
        do {

            client = try GraniteIPFS.init(host: "ipfs.infura.io", port: 5001, ssl: true)
//            try api.add(Bundle.main.url(forResource: "block", withExtension: "png")!.absoluteString) { node in
//                if let hash = node.first?.hash {
//
//                    try? api.pin.add(hash) { hash in
//
//                        GraniteLogger.info(hash)
//                    }
//                }
//            }
        } catch let error {
            self.client = nil
            GraniteLogger.info(error.localizedDescription, .utility, focus: true)
        }
    }
}
