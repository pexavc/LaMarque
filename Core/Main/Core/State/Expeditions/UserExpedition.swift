////
////  UserExpedition.swift
////  
////
////  Created by PEXAVC on 1/10/21.
////
//
import GraniteUI
import SwiftUI
import Combine
import Security

struct UserExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MainEvents.User
    typealias ExpeditionState = MainState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.exhibitionName.isNotEmpty else { return }
        
        //DEV:
        //Forced model warm up
        _ = try? MiDaS()
        //
        
        storage.update(GlobalDefaults.ExhibitionName, state.exhibitionName)
        storage.update(GlobalDefaults.ExhibitionID, UUID().uuidString)
        connection.update(\RouterDependency.authState, value: .authenticated)
        
        GraniteLogger.info("authenticated - \(storage.get(GlobalDefaults.ExhibitionName, defaultValue: ""))", .expedition, focus: true)
        
        //TODO: in case the previous prepare on launch does not fire?
        storage.update(GlobalDefaults.Prepared.prepared)
    }
}

struct PrepareUserExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MainEvents.User.Prepare
    typealias ExpeditionState = MainState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        storage.set(GlobalDefaults.defaults)
        storage.set(GlobalDefaults.variableDefaults)
        
        let prepared = storage.get(GlobalDefaults.Prepared.self)
        
        guard prepared == GlobalDefaults.Prepared.prepared.value else {
            
            storage.update(GlobalDefaults.Prepared.prepared)
            
            GraniteLogger.info("Setting defaults", .expedition, focus: true)
            connection.update(\RouterDependency.authState, value: .notAuthenticated)
            
            return
        }
        
        let creativeName = storage.get(GlobalDefaults.ExhibitionName, defaultValue: "")
        let creativeID = storage.get(GlobalDefaults.ExhibitionID, defaultValue: "")
        
        if creativeName.isNotEmpty && creativeID.isNotEmpty {
            state.exhibitionName = creativeName
            connection.update(\RouterDependency.authState, value: .authenticated)
            
            GraniteLogger.info("authenticated", .expedition, focus: true)
        } else {
            GraniteLogger.info("not authenticated", .expedition, focus: true)
            connection.update(\RouterDependency.authState, value: .notAuthenticated)
        }
    }
}
//
//struct LogoutExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = MainEvents.Logout
//    typealias ExpeditionState = MainState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        do {
//            try FirebaseAuth.Auth.auth().signOut()
//            connection.router?.clean()
//            connection.update(\RouterDependency.authState, value: .notAuthenticated, .here)
//        } catch let error {
//            GraniteLogger.info("Error logging out \(String(describing: error))", .expedition, focus: true)
//        }
//    }
//}
//
//struct DiscussSetResultExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = DiscussRelayEvents.Client.Set.Result
//    typealias ExpeditionState = MainState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        connection.update(\RouterDependency.environment.discuss.server, value: event.server, .quiet)
//        
//        GraniteLogger.info("set discuss", .expedition, focus: true)
//    }
//}
//
//struct LoginResultExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = NetworkEvents.User.Get.Result
//    typealias ExpeditionState = MainState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
////        if let user = event.user {
////            let info: UserInfo = .init(username: user.username,
////                                               email: user.email,
////                                               created: (Int(user.created) ?? 0).asDouble.date(),
////                                               uid: event.id)
////
////            coreDataInstance.getPortfolio(username: info.username) { portfolio in
////                let newUser: User = .init(info: info)
////                if let portfolio = portfolio {
////                    newUser.portfolio = portfolio
////                }
////                connection.update(\RouterDependency.authState, value: .authenticated, .here)
////                connection.update(\RouterDependency.environment.user, value: newUser, .here)
////                connection.request(DiscussRelayEvents.Client.Set.init(user: newUser))
////
////                GraniteLogger.info("set user", .expedition, focus: true)
////            }
////        }
//    }
//}
//
//struct LoginAuthCompleteExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = LoginEvents.AuthComplete
//    typealias ExpeditionState = MainState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        //TODO: Used as a proxy to refresh, but maybe can be used for something useful?
//    }
//}
