//
//  GraniteButtonComponent.swift
//  
//
//  Created by PEXAVC on 1/11/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraniteButtonComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraniteButtonCenter, GraniteButtonState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            switch state.type {
            case .text(let text):
                BasicButton(text: text,
                            textColor: state.textColor,
                            colors: state.textColors,
                            shadow: state.textShadow)
            case .image(let name):
                Image(name)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: state.size.width,
                           height: state.size.height,
                           alignment: .leading)
                    .foregroundColor(state.foregroundColor)
                    .background(
                        Passthrough {
                            if state.selected {
                                GradientView(colors: state.textColors,
                                             cornerRadius: 0.0,
                                             direction: .topLeading).overlay (
                                                
                                                Brand.Colors.black
                                                    .opacity(0.57)
                                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                    .padding(.top, 4)
                                                    .padding(.leading, 4)
                                                    .padding(.trailing, 4)
                                                    .padding(.bottom, 4)
                                                
                                                
                                             )
                                    .padding(.top, -8)
                                    .padding(.leading, -8)
                                    .padding(.trailing, -8)
                                    .padding(.bottom, -8)
                                    .shadow(color: Color.black, radius: 2.0, x: 1.0, y: 2.0)
                            }
                        }
                    )
            case .add, .addNoSeperator:
                VStack(spacing: 0) {
                    if case .add = state.type {
                        PaddingVertical(Brand.Padding.xSmall)
                    }
                    GradientView(width: state.size.width,
                                 height: state.size.height,
                                 colors: state.textColors,
                                 cornerRadius: state.size.width/2,
                                 direction: .topLeading).overlay(
                                    GraniteText("+", Brand.Colors.white,
                                                .headline,
                                                .bold,
                                                fontType: .menlo)
                                 
                                 ).padding(.top, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.small)
                        .padding(.trailing, Brand.Padding.small)
                        .padding(.bottom, Brand.Padding.medium)
                        .shadow(color: Color.black.opacity(0.75), radius: 1, x: 1, y: 1)
//                    Circle()
//                        .foregroundColor(Brand.Colors.marble).overlay(
//
//                            GraniteText("+", Brand.Colors.black,
//                                        .headline,
//                                        .bold,
//                                        fontType: .menlo)
//
//
//                        ).frame(width: state.size.width, height: state.size.height)
//                        .padding(.top, Brand.Padding.medium)
//                        .padding(.leading, Brand.Padding.small)
//                        .padding(.trailing, Brand.Padding.small)
//                        .padding(.bottom, Brand.Padding.medium)
//                        .shadow(color: Color.black.opacity(0.75), radius: 1, x: 1, y: 1)
                }
            }
        }
        .padding(.top, state.padding.top)
        .padding(.leading, state.padding.leading)
        .padding(.trailing, state.padding.trailing)
        .padding(.bottom, state.padding.bottom)
        .modifier(TapAndLongPressModifier(tapAction: { state.action?() }))
    }
}
