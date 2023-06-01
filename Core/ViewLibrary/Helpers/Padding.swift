//
//  Padding.swift
//  
//
//  Created by PEXAVC on 1/6/21.
//

import Foundation
import SwiftUI
import GraniteUI

public struct PaddingVertical: View {
    let height: CGFloat
    let color: Color
    
    public init(_ height: CGFloat = 1,
                _ color: Color = Brand.Colors.marble) {
        self.height = height
        self.color = color
    }
    
    public var body: some View {
        Rectangle().frame(maxWidth: .infinity,
                          minHeight: height,
                          idealHeight: height,
                          maxHeight: height).foregroundColor(color)
    }
}

public struct PaddingHorizontal: View {
    let width: CGFloat
    let color: Color
    
    public init(_ width: CGFloat = Brand.Padding.small,
                _ color: Color = .black) {
        self.width = width
        self.color = color
    }
    
    public var body: some View {
        Rectangle().frame(minWidth: width,
                          idealWidth: width,
                          maxWidth: width,
                          maxHeight: .infinity).foregroundColor(color)
    }
}

public struct PaddingSafeAreaVertical: View {
    public var body: some View {
        GeometryReader { geometry in
            
            Brand.Colors.black.frame(
                    width: .infinity,
                    height: geometry.safeAreaInsets.top,
                    alignment: .center)
        }
        .edgesIgnoringSafeArea(.top)
    }
}
