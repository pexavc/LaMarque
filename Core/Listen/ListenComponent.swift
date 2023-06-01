//
//  GlassComponent.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct ListenComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<ListenCenter, ListenState> = .init()
    
    public init() {}
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 6.0)
            .repeatForever(autoreverses: false)
    }
    
    public var body: some View {
        switch state.exhibitionStage {
        case .marbling:
            ZStack {
                if state.wantsToListen {
                    VStack {
                        Spacer()
                        
                        VStack {
                            
                            HStack(spacing: Brand.Padding.small) {
                                
                                GraniteButtonComponent(state: .init("♫_le_Verre",
                                                textColor: Brand.Colors.white,
                                                colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                                padding: .init(Brand.Padding.medium,
                                                               Brand.Padding.small,
                                                               Brand.Padding.medium,
                                                               Brand.Padding.small),
                                                action: {
                                                    //
                                                    GraniteHaptic.light.invoke()
                                                    sendEvent(ListenEvents.Radio.Begin())
                                                }))
                                
                                GraniteButtonComponent(state: .init("listen",
                                                                    textColor: Brand.Colors.greyV2,
                                                                    colors: [Brand.Colors.black,
                                                                             Brand.Colors.marble.opacity(0.24)],
                                                                    shadow: Brand.Colors.marble.opacity(0.57),
                                                                    padding: .init(Brand.Padding.medium,
                                                                                   Brand.Padding.small,
                                                                                   Brand.Padding.medium,
                                                                                   Brand.Padding.small),
                                                                    action: {
                                                                        //
                                                                        GraniteHaptic.light.invoke()
                                                                        sendEvent(ListenEvents.Listen.Permissions())
                                                                        
                                                                    }))
                            }
                            .padding(.all, Brand.Padding.medium)
                            .background(Brand.Colors.black.opacity(0.93))
                            .border(Brand.Colors.marble, width: 2)
                        }
                        .frame(maxWidth: 280, maxHeight: .infinity)
                        if state.stage == .listening {
                            Spacer()
                            GraniteButtonComponent(state: .init("◼︎",
                                                                textColor: Brand.Colors.greyV2,
                                                                colors: [Brand.Colors.black,
                                                                         Brand.Colors.marble.opacity(0.24)],
                                                                shadow: Brand.Colors.marble.opacity(0.57),
                                                                padding: .init(Brand.Padding.medium,
                                                                               Brand.Padding.small,
                                                                               Brand.Padding.medium,
                                                                               Brand.Padding.small),
                                                                action: {
                                                                    //
                                                                    GraniteHaptic.light.invoke()
                                                                    sendEvent(ListenEvents.Stop())
                                                                    
                                                                }))
                            
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Brand.Colors.marble.opacity(0.57))
                    .onTapGesture {
                        
                        set(\.wantsToListen, value: false)
                    }
                }
                
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        
                        
                        ZStack(alignment: .leading) {
                            
                            Rectangle()
                                .foregroundColor(Brand.Colors.black.opacity(0.75))
                                .frame(width: 93 + Brand.Padding.medium,
                                       height: 65,
                                       alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .cornerRadius(50)
                                .offset(x: -(Brand.Padding.medium + 27), y: 0)
                            
                            VStack(alignment: .leading) {
                                Image("disc_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50,
                                           alignment: .leading)
                                    .animation(.interactiveSpring())
                                    .transition(.move(edge: .top))
                                    .modifier(TapAndLongPressModifier(tapAction: {
                                        GraniteHaptic.light.invoke()
                                        set(\.wantsToListen, value: true)
            //                            state.intent = .li
            //                            onRoute(.exhibition(.listen))
                                    }))
                                    .rotationEffect(.degrees(state.stage == .listening ? 360 : 0))
                                    .animation(state.stage == .listening ? foreverAnimation : .default)
                            }
                            .padding(.leading, Brand.Padding.medium9)
                                
                        }

                        Spacer()
                    }
                    .padding(.bottom, state.intent == .showcase ? Brand.Padding.large * 3 : (EnvironmentConfig.isIPhone ? 4 : 1) * Brand.Padding.medium)
                    
                }
            }
            .animation(.interactiveSpring())
            .transition(.move(edge: .leading))
            
            
            Controller(stage: state.exhibitionStage,
                       intent: state.intent,
                       action: { filter in
                           sendEvent(CanvasEvents.Filter.Update.init(filter: filter), .contact)
                       })
        default:
            EmptyView().hidden()
        }
    }
}
