//
//  RoundedEdge.swift
//  stoic
//
//  Created by PEXAVC on 2/1/21.
//

import Foundation
import SwiftUI

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}
