//
//  GlobalDefaults.swift
//  marble
//
//  Created by PEXAVC on 2/28/21.
//

import GraniteUI
import Foundation
public struct GlobalDefaults: LocalStorageDefaults {
    public init() {}
    
    public static var defaults: [LocalStorage.Value<LocalStorageValue>] {
        lsvDefaults
    }
    
    public static var lsvDefaults: [LocalStorage.Value<LocalStorageValue>] {
        [
            LocalStorage.Value.init(Prepared.none),
            LocalStorage.Value.init(Encoding.original),
            LocalStorage.Value.init(Permissions.Listen.off)
        ]
    }
    
    public static var variableDefaults: [LocalStorage.Value<Any>] {
        return userDefaults
    }
    
    public static var userDefaults: [LocalStorage.Value<Any>] {
        return [
            LocalStorage.Value.init(GlobalDefaults.ExhibitionName, ""),
            LocalStorage.Value.init(GlobalDefaults.ExhibitionID, ""),
            LocalStorage.Value.init(GlobalDefaults.ExhibitionSite, "")
        ]
    }
    
    public enum Prepared: Int, LocalStorageValue {
        case prepared
        case none
        
        public var value: Int {
            return self.rawValue
        }
        
        public var permissions: LocalStorageReadWrite {
            return .readAndWrite
        }
    }
    
    public enum Encoding: Int, LocalStorageValue {
        case original
        case marbled
        
        public var value: Int {
            return self.rawValue
        }
        
        public var permissions: LocalStorageReadWrite {
            return .readAndWrite
        }
    }
    
    public struct Permissions {
        public enum Listen: Int, LocalStorageValue {
            case on
            case off
            
            public var value: Int {
                return self.rawValue
            }
            
            public var permissions: LocalStorageReadWrite {
                return .readAndWrite
            }
            
            public static var canListen: Bool {
                Services.shared.localStorage.get(GlobalDefaults.Permissions.Listen.self) == Permissions.Listen.on.rawValue
            }
        }
    }
    
//    public enum Reachability: Int, LocalStorageValue {
//        case wifi
//        case cellular
//        case unavailable
//
//        public var value: Int {
//            return self.rawValue
//        }
//
//        public var asString: String {
//            switch self {
//            case .wifi: return "you are online, wifi connection"
//            case .cellular: return "you are online, cellular connection"
//            case .unavailable: return "you are not online"
//            }
//        }
//
//        public var description: String {
//            "reachable".lowercased().localized
//        }
//
//        public var permissions: LocalStorageReadWrite {
//            .internalReadAndWrite
//        }
//
//        public var isOnline: Bool {
//            self != .unavailable
//        }
//
//        public static func from(_ value: Int?) -> GlobalDefaults.Reachability {
//            if let value = value {
//                return GlobalDefaults.Reachability.init(rawValue: value) ?? GlobalDefaults.Reachability.unavailable
//            } else {
//                return GlobalDefaults.Reachability.unavailable
//            }
//        }
//    }
    
    //MARK: -- User
    public static var ExhibitionName: String = "ExhibitionName"
    public static var ExhibitionID: String = "ExhibitionID"
    public static var ExhibitionSite: String = "ExhibitionSite"
}
