//
//  IPFSExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct PinMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarqueEvents.Pin
    typealias ExpeditionState = MarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("entering", .expedition, focus: true)
        
        do {
            if let addHash = event.nodes.first?.hash {
                try state.service.client?.pin.add(addHash) { pinHash in
                    
                    
                    if let hash = pinHash.first,
                       let image = GraniteImage.init(data: event.encodedData) {
                        
                        //Find the existing signature
                        
                        //[CAN REMOVE] or [REPURPOSE], would search an image for the IPFS hash
//                        state.service.kit.search(image) { result in
                            
                            //Append the ipfs hash
                            
                            //[CAN REMOVE] or [REPURPOSE], would encode an image with MarqueKit with their IPFS hash
                            
                            
//                            let appendedMessage = MarqueKit.combine([b58String(hash), result.payload])
//
//                            //Encode and return to the user for saving
//                            state.service.kit.encode(appendedMessage, withObject: image) { result in
//                                if let data = result.data.pngData() {
//
//                                    connection.request(MarqueEvents.Pin.Result(addHash: addHash, pinHash: hash, encodedData: data))
//                                } else {
//                                    GraniteLogger.info("error appending encoding", .expedition, focus: true)
//                                    connection.request(MarqueEvents.Pin.Result(addHash: addHash, pinHash: hash, encodedData: event.encodedData))
//                                }
//                            }
//                        }
                        
                    } else {
                        GraniteLogger.info("error finding pin hash", .expedition, focus: true)
                    }
                    
                }
            } else {
                GraniteLogger.info("error finding hash", .expedition, focus: true)
            }
        } catch let error {
            GraniteLogger.info("error pinning:\n\(error)", .expedition, focus: true)
        }
        
        //            try api.add(Bundle.main.url(forResource: "block", withExtension: "png")!.absoluteString) { node in
        //                if let hash = node.first?.hash {
        //
        //                    try? api.pin.add(hash) { hash in
        //
        //                        GraniteLogger.info(hash)
        //                    }
        //                }
        //            }
    }
}

struct PinSiteMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarqueEvents.Pin.Site
    typealias ExpeditionState = MarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("entering", .expedition, focus: true)
        
        do {
            if let addHash = event.nodes.first?.hash {
                try state.service.client?.pin.add(addHash) { pinHash in
                    if let hash = pinHash.first {
                       
                        connection.request(MarqueEvents.Pin.Site.Result(addHash: addHash, pinHash: hash))
                        
                    } else {
                        GraniteLogger.info("error finding pin hash", .expedition, focus: true)
                    }
                    
                }
            } else {
                GraniteLogger.info("error finding hash", .expedition, focus: true)
            }
        } catch let error {
            GraniteLogger.info("error pinning:\n\(error)", .expedition, focus: true)
        }
        
        //            try api.add(Bundle.main.url(forResource: "block", withExtension: "png")!.absoluteString) { node in
        //                if let hash = node.first?.hash {
        //
        //                    try? api.pin.add(hash) { hash in
        //
        //                        GraniteLogger.info(hash)
        //                    }
        //                }
        //            }
    }
}
