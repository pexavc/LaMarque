//
//  WindowConfig.swift
//   (iOS)
//
//  Created by PEXAVC on 12/31/20.
//

import Foundation
import GraniteUI
import SwiftUI

public struct WindowConfig: Hashable, Identifiable {
    public var id: ObjectIdentifier {
        return .init(Instance.init(name: ""))
    }
    
    public struct Index: Hashable, Equatable {
        public static func == (lhs: Index, rhs: Index) -> Bool {
            lhs.x == rhs.x &&
            lhs.y == rhs.y
        }
        
        let x: Int
        let y: Int
        
        static var zero: Index {
            .init(x: 0, y: 0)
        }
    }
    
    var style: WindowStyle = .init()
    var kind: WindowType = .unassigned
    let index: Index
    
    static var none: WindowConfig {
        .init(index: .zero)
    }
    
    var detail: String {
        """
        Window: \(id)
        ------------
        index: (\(index.x), \(index.y))
        kind: \(kind)
        """
    }
    
    public static func == (lhs: WindowConfig, rhs: WindowConfig) -> Bool {
        lhs.index == rhs.index
    }
}

public enum WindowType: Hashable {
    
    case exhibition(ExhibitionIntent)
    case settings
    case verify(VerifyIntent)
    
    case unassigned
    
    var max: Int {
        return 1
    }
    
    var label: String {
        return ""
    }
}

public struct WindowStyle: Hashable, Equatable {
    public static func == (lhs: WindowStyle, rhs: WindowStyle) -> Bool {
        lhs.idealWidth == rhs.idealWidth &&
        lhs.idealHeight == rhs.idealHeight
    }
    
    
    var idealWidth: CGFloat = 375
    var idealHeight: CGFloat = 420
    
    
    static var minWidth: CGFloat = 300
    static var minHeight: CGFloat = 360
    static var maxWidth: CGFloat = 500
    static var maxHeight: CGFloat = 400
    
    static var windowSizeProxy: some View {
        GeometryReader { reader in
            Rectangle().frame(width: reader.size.width, height: reader.size.height, alignment: .center)
        }
    }
}
