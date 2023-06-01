//
//  BasicSliderComponent.swift
//  
//
//  Created by PEXAVC on 1/2/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct BasicSliderComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<BasicSliderCenter, BasicSliderState> = .init()

    public init() {}
    
    var sliderHeightScale: CGFloat {
        if EnvironmentConfig.isIPhone {
            return 0.5
        } else {
            return 1.0
        }
    }
    
    public var body: some View {
        VStack {
            ValueSlider(value: _state.number,
                        onEditingChanged: { changed in
                            sendEvent(BasicSliderEvents.Value(
                                        data: state.number,
                                        isActive: changed), .contact)
                        })
                .frame(height: 64*sliderHeightScale)
                .valueSliderStyle(
                    HorizontalValueSliderStyle(
                        track: HorizontalValueTrack(
                            view: LinearGradient(
                                gradient: Gradient(colors: [Brand.Colors.marble, Brand.Colors.redBurn]),
                            startPoint: .leading,
                            endPoint: .trailing),
                            mask: RoundedRectangle(cornerRadius: 3)
                        )
                        .frame(height: 64*sliderHeightScale)
                        .cornerRadius(6),
                        thumb: RoundedRectangle(cornerRadius: 4).foregroundColor(Brand.Colors.white),
                        thumbSize: CGSize(width: 12*sliderHeightScale, height: 42*sliderHeightScale)
                    )
                )
                .shadow(color: Color.black, radius: 4.0, x: 2.0, y: 2.0)
            
        }
    }
}

public struct HalfCapsule: View, InsettableShape {
    private let inset: CGFloat

    public func inset(by amount: CGFloat) -> HalfCapsule {
        HalfCapsule(inset: self.inset + amount)
    }
    
    public func path(in rect: CGRect) -> Path {
        let width = rect.size.width - inset * 2
        let height = rect.size.height - inset * 2
        let heightRadius = height / 2
        let widthRadius = width / 2
        let minRadius = min(heightRadius, widthRadius)
        return Path { path in
            path.move(to: CGPoint(x: width, y: 0))
            path.addArc(center: CGPoint(x: minRadius, y: minRadius), radius: minRadius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 180), clockwise: true)
            path.addArc(center: CGPoint(x: minRadius, y: height - minRadius), radius: minRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
        }.offsetBy(dx: inset, dy: inset)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            self.path(in: CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height))
        }
    }
    
    public init(inset: CGFloat = 0) {
        self.inset = inset
    }
}
