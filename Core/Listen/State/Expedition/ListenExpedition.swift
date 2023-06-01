//
//  ListenPermissionsExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//
import AVKit
import GraniteUI
import Combine
import MarbleKit
import Foundation

struct ListenStageExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ListenEvents.Stage
    typealias ExpeditionState = ListenState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        state.exhibitionStage = event.stage
    }
}

struct ListenPermissionsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ListenEvents.Listen.Permissions
    typealias ExpeditionState = ListenState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        if GlobalDefaults.Permissions.Listen.canListen {
            connection.request(ExhibitionEvents.Glass.Listen(), .contact)
            state.wantsToListen = false
            state.stage = .listening
        } else {
            #if os(macOS)
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    storage.update(GlobalDefaults.Permissions.Listen.on)
                } else {
                    storage.update(GlobalDefaults.Permissions.Listen.off)
                }
            }
            #else
            let audioSession = AVAudioSession.sharedInstance()
            
            audioSession.requestRecordPermission { granted in
                if granted {
                    storage.update(GlobalDefaults.Permissions.Listen.on)
                } else {
                    storage.update(GlobalDefaults.Permissions.Listen.off)
                }
            }
            #endif
        }
    }
}
