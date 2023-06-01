//
//  Geometry.swift
//  
//
//  Created by PEXAVC on 1/6/21.
//

import Foundation
import SwiftUI

public enum CustomEdge: Hashable {
    case top
    case left
    case right
    case bottom
}

struct InsetPreferenceKey: PreferenceKey {
    static var defaultValue: [CustomEdge: CGFloat] = [:]

    static func reduce(value: inout [CustomEdge: CGFloat], nextValue: () -> [CustomEdge: CGFloat]) {
        value = nextValue()
    }

    
    typealias Value = [CustomEdge: CGFloat]
}

struct InsetGetter: View {
    var body: some View {
        GeometryReader { geometry in
            return Rectangle().preference(
                key: InsetPreferenceKey.self,
                value: [
                    .top : geometry.safeAreaInsets.top,
                    .left : geometry.safeAreaInsets.leading,
                    .right : geometry.safeAreaInsets.trailing,
                    .bottom : geometry.safeAreaInsets.bottom
                ])
        }
    }
}

struct WindowSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }

    
    typealias Value = CGRect
}

struct WindowSizeGetter: View {
    var body: some View {
        GeometryReader { geometry in
            return Rectangle().preference(
                key: WindowSizePreferenceKey.self,
                value: geometry.frame(in: .local))
        }
    }
}
