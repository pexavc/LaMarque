//
//  Gradient.swift
//  
//
//  Created by PEXAVC on 1/14/21.
//

import Foundation
import SwiftUI

public struct GradientView: View {
    
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let colors: [Color]
    let direction: UnitPoint
    
    public init(colors: [Color] = [Brand.Colors.yellow, Brand.Colors.purple],
                cornerRadius: CGFloat = 12,
                direction: UnitPoint = .leading) {
        
        self.width = .infinity
        self.height = .infinity
        self.cornerRadius = cornerRadius
        self.colors = colors
        self.direction = direction
    }
    
    public init(width: CGFloat,
                height: CGFloat,
                colors: [Color] = [Brand.Colors.yellow, Brand.Colors.purple],
                cornerRadius: CGFloat = 12,
                direction: UnitPoint = .leading) {
        
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.colors = colors
        self.direction = direction
    }
    
    public var body: some View {
        Rectangle()
            .frame(minWidth: 0,
                   idealWidth: width,
                   maxWidth: width,
                   minHeight: 0,
                   idealHeight: height,
                   maxHeight: height,
                   alignment: .center)
            .padding()
            .foregroundColor(.clear)
            .background(LinearGradient(
                            gradient: Gradient(colors: colors),
                            startPoint: direction,
                            endPoint: endPoint))
            .cornerRadius(cornerRadius)
    }
    
    var endPoint: UnitPoint {
        switch direction {
        case .leading:
            return .trailing
        case .trailing:
            return .leading
        case .topLeading:
            return .bottomTrailing
        case .bottomLeading:
            return .topTrailing
        case .topTrailing:
            return .bottomLeading
        case .bottomTrailing:
            return .topLeading
        case .top:
            return .bottom
        case .bottom:
            return .top
        default:
            return .bottom
            
        }
    }
}
