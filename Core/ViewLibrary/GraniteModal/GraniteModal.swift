//
//  GraniteModal.swift
//  
//
//  Created by PEXAVC on 1/11/21.
//

import Foundation
import GraniteUI
import SwiftUI

public struct GraniteModal<Content>: View where Content: View {
    let content: Content
    let onExitTap: (() -> Void)
    public init(@ViewBuilder content: () -> Content,
                             onExitTap: @escaping (() -> Void)) {
        self.content = content()
        self.onExitTap = onExitTap
    }
    
    public var body: some View {
        Brand.Colors.black.opacity(0.57).overlay (
            VStack {
                content
            }.frame(maxWidth: 400, maxHeight: 500)
            .background(Brand.Colors.black)
            .cornerRadius(6)
            .shadow(color: Color.black, radius: 6, x: 4, y: 4)
        ).onTapGesture(perform: {
            
            onExitTap()
        })
    }
}
