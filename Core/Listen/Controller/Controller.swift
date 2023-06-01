//
//  Controller.swift
//  lamarque
//
//  Created by PEXAVC on 3/24/21.
//

import Foundation
import SwiftUI
import GraniteUI
import MarbleKit

struct Controller: View {
    var stage: ExhibitionStage
    var intent: ExhibitionIntent
    var action: ((CanvasFilter) -> Void)
    
    public init(stage: ExhibitionStage,
                intent: ExhibitionIntent,
                action: @escaping ((CanvasFilter) -> Void)) {
        self.action = action
        self.stage = stage
        self.intent = intent
    }
    
    @State var widthOpen: CGFloat = 129
    var controlWidth: CGFloat = 102
    var tongueWidth: CGFloat = 27
    var heightOpen: CGFloat = 160
    var cornerRadius: CGFloat = 16
    
    public enum Options: Equatable {
        case _a2
        case _2b
        case _9s
        case none
        
        var filter: CanvasFilter {
            switch self {
            case ._a2:
                return .init(effects: [.depth, .disco, .godRay])
            case ._2b:
                return .init(effects: [.depth, .stars, .godRay])
            case ._9s:
                return .init(effects: [.depth, .bokeh])
            default:
                return .init(effects: [.depth, .godRay])
            }
        }
    }
    
    @State var selected: Options = .none
    
    @State var open: Bool = false
    
    public func changeFilter(_ option: Options) {
        if selected == option {
            selected = .none
        } else {
            selected = option
        }
        
        action(selected.filter)
    }
    
    var body: some View {
        ZStack {
            switch stage {
            case .marbling:
            
            HStack {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(Brand.Colors.black.opacity(open ? 1.0 : 0.75))
                            .frame(width: controlWidth,
                                   height: heightOpen,
                                   alignment: .trailing)
                            .cornerRadius(cornerRadius)
                            .offset(y: cornerRadius*1.5 + Brand.Padding.small)
                        VStack(alignment: .center, spacing: Brand.Padding.large) {
                            GraniteText("[a2]",
                                        .headline,
                                        style: .v2Selection,
                                        selected: selected == ._a2)
                                        .modifier(TapAndLongPressModifier(tapAction: {
                                            GraniteHaptic.light.invoke()
                                            changeFilter(._a2)
                                        }))
                            
                            GraniteText("[2b]",
                                        .headline,
                                        style: .v2Selection,
                                        selected: selected == ._2b)
                                        .modifier(TapAndLongPressModifier(tapAction: {
                                            GraniteHaptic.light.invoke()
                                            changeFilter(._2b)
                                        }))
                            
                            GraniteText("[9s]",
                                        .headline,
                                        style: .v2Selection,
                                        selected: selected == ._9s)
                                        .modifier(TapAndLongPressModifier(tapAction: {
                                            GraniteHaptic.light.invoke()
                                            changeFilter(._9s)
                                        }))
                        }
                        .padding(.trailing, cornerRadius + Brand.Padding.medium)
                        .padding(.top, cornerRadius + Brand.Padding.large)
                    }
                    Color.clear.frame(width: widthOpen,
                                      height: 65,
                                      alignment: .trailing)
                }.padding(.bottom, intent == .showcase ? Brand.Padding.large * 3 : (EnvironmentConfig.isIPhone ? 4 : 1) * Brand.Padding.medium)
                .frame(width: widthOpen)
                .offset(x: (open ? 0 : (controlWidth - tongueWidth)) + (Brand.Padding.medium + cornerRadius), y: 0)
                .animation(.default)
            }
                    
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Spacer()
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(Brand.Colors.black.opacity(open ? 1.0 : 0.75))
                            .frame(width: widthOpen,
                                   height: 65,
                                   alignment: .trailing)
                            .cornerRadius(cornerRadius)
                        
                        
                        GraniteText(open ? "▶︎" : "◀︎",
                                    .callout,
                                    .bold,
                                    .leading)
                            .padding(.leading, open ? controlWidth/4 + Brand.Padding.medium/2 : Brand.Padding.medium)
                    }.onTapGesture {
                        open = !open
                    }
                }.padding(.bottom, intent == .showcase ? Brand.Padding.large * 3 : (EnvironmentConfig.isIPhone ? 4 : 1) * Brand.Padding.medium)
                .frame(width: widthOpen)
                .offset(x: (open ? tongueWidth : (controlWidth - (tongueWidth + 12))) + (Brand.Padding.medium + cornerRadius), y: 0)
                .animation(.default)
            }
                
            default:
                EmptyView().hidden()
            }
        }
        .animation(.interactiveSpring())
        .transition(.move(edge: .trailing))
    }
}
