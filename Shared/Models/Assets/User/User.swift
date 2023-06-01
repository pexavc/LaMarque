//
//  User.swift
//  
//
//  Created by PEXAVC on 1/8/21.
//

import Foundation
import GraniteUI
import SwiftUI

public class User: Hashable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.info.uid == rhs.info.uid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(info.uid)
    }
    
    var info: UserInfo = .empty
    
    var appearance: UserAppearance = .init()
    
    public init(info: UserInfo) {
        self.info = info
    }
    
    public init() {}
    
    public static func guest(with username: String,
                             color: Color = Brand.Colors.white) -> User  {
        let guestUser: User = .init(info: .init(username: username,
                                      email: "",
                                      created: .today,
                                      uid: UUID().uuidString))
        
        guestUser.appearance.color = color
        
        return guestUser
    }
}

public struct UserAppearance {
    var color: Color = Brand.Colors.yellow
}

public struct UserInfo {
    var username: String
    var email: String
    var created: Date
    var uid: String
    
    static var empty: UserInfo {
        return .init(username: "", email: "", created: .today, uid: "")
    }
    
    public var isReady: Bool {
        self.username.isNotEmpty && self.email.isNotEmpty
    }
}




