//
//  ControlBar.swift
//   (iOS)
//
//  Created by PEXAVC on 1/6/21.
//

import Foundation
import SwiftUI
import GraniteUI

public struct ControlBar: View {
    var headerTitle: String
    var isIPhone: Bool
    var iconSize: CGFloat {
        if isIPhone {
            return 20
        } else {
            return 20
        }
    }
    var fontSize: Fonts.FontSize = .headline
    var currentRoute: Route
    var onRoute: ((Route) -> Void)
    
    public var body: some View {
        HStack(alignment: .center) {
            actions
        }.frame(maxWidth: .infinity,
                minHeight: EnvironmentStyle.ControlBar.iPhone.minHeight,
                maxHeight: EnvironmentStyle.ControlBar.iPhone.maxHeight,
                alignment: .center)
        .padding([.top, .leading, .trailing, .bottom],
                 EnvironmentConfig.isIPhone ? Brand.Padding.small : Brand.Padding.medium)
    }
    
    var actions: some View {
        Passthrough {
            Spacer()
            HStack(alignment: .center) {

                GraniteText(headerTitle,
                            fontSize,
                            .regular,
                            style: .v2Selection,
                            selected: currentRoute.isExhibition,
                            addSpacers: false)
                            .modifier(TapAndLongPressModifier(tapAction: {
                                GraniteHaptic.light.invoke()
                                onRoute(.exhibition(.none))
                            })).padding(.trailing, Brand.Padding.xMedium)
                
//                if currentRoute.isExhibition {
//                    GraniteText("+",
//                                fontSize,
//                                .bold,
//                                style: .v2Selection,
//                                selected: true)
//                                .frame(width: iconSize, height: iconSize, alignment: .center)
//                                .modifier(TapAndLongPressModifier(tapAction: {
////                                    GraniteHaptic.light.invoke()
////                                    onRoute(.exhibition(.add))
//                                    shouldPick = !shouldPick
//                                }))
//                        .animation(.interactiveSpring())
//                        .transition(.move(edge: .top))
//                        .sheet(isPresented: $shouldPick) {
//                            ImagePicker(image: $imagePicked) { path in
////                                marque(path)
//                            }
//                        }
//                }
                
                
                Spacer()
            }
            
            Spacer()
            
            
            HStack(alignment: .center, spacing: Brand.Padding.large) {
                GraniteButtonComponent(state: .init(.image("exhibit_icon"),
                                                    selected: currentRoute.isShowcase,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.exhibition(.showcase))
                                                    }))
                
                GraniteButtonComponent(state: .init(.image("community_icon"),
                                                    selected: currentRoute.isVerify,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.verify(.none))
                                                    }))
                
                GraniteButtonComponent(state: .init(.image("settings_icon"),
                                                    selected: currentRoute == .settings,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.settings)
                                                    }))
                        
            }
            
            Spacer()
        }
    }
}
