//
//  InstallationComponent.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import MarbleKit

public struct InstallationComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<InstallationCenter, InstallationState> = .init()
    
    public init() {}
    
    var aspectRatio: CGFloat {
        min(state.currentImage.width, state.currentImage.height) / max(state.currentImage.width, state.currentImage.height)
    }
    
    public var body: some View {
        ZStack {
            if state.stage.isSnapshot && !state.viewingMarble {
                #if os(macOS)
                Image(nsImage: state.currentImage)
                    .centerCropped()
                
                #else
                Image(uiImage: state.currentImage)
                    .centerCropped()
                #endif
            } else if state.stage.isPrepared {
                CanvasComponent(state: .init(image: state.originalImage,
                                             installation: state.installation,
                                             exhibit: state.viewingMarble))
                    .attach(to: command)
                    .listen(to: command)
                
                if !state.installation.marbled {
                    VStack {
                        Spacer()
                        GraniteText("marbling",
                                    .headline,
                                    .boldItalic)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        GraniteText(state.installation.creativeName,
                                    Brand.Colors.marbleV2,
                                    .headline,
                                    .bold,
                                    .leading,
                                    addSpacers: false)
                            .padding(.leading, Brand.Padding.medium9)
                            .padding(.trailing, Brand.Padding.medium9)
                            .padding(.top, Brand.Padding.small)
                        GraniteText("by "+state.installation.creativeAuthor,
                                    Brand.Colors.marbleV2,
                                    .footnote,
                                    .italic,
                                    .leading,
                                    addSpacers: false)
                            .padding(.leading, Brand.Padding.medium9)
                            .padding(.trailing, Brand.Padding.medium9)
                            .padding(.bottom, Brand.Padding.small)
                    }
                    .background(Brand.Colors.black)
                    .border(Brand.Colors.marble, width: 2)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        GraniteText(state.installation.displayHash,
                                    Brand.Colors.marbleV2,
                                    .caption,
                                    .regular,
                                    fontType: .menlo)
                                    .padding(.top, Brand.Padding.small)
                                    .padding(.leading, Brand.Padding.medium9)
                                    .padding(.trailing, Brand.Padding.medium9)
                                    .padding(.bottom, Brand.Padding.small)
                    }
                    .background(Brand.Colors.black)
                    .border(Brand.Colors.marble, width: 2)
                }
            }
            .allowsHitTesting(false)
            
            
            
            if state.isEditing {
                VStack(spacing: 0) {
                    GraniteButtonComponent(state: .init("remove",
                                                        textColor: Brand.Colors.greyV2,
                                                        colors: [Brand.Colors.black,
                                                                 Brand.Colors.marble.opacity(0.24)],
                                                        shadow: Brand.Colors.marble.opacity(0.57),
                                                        padding: .init(Brand.Padding.medium,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.small),
                                                        action: {
                                                            GraniteHaptic.light.invoke()
                                                            sendEvent(ExhibitionEvents.Remove(installation: state.installation), .contact)
                                                        }))
                    
                    GraniteButtonComponent(state: .init("share",
                                                        textColor: Brand.Colors.white,
                                                        colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                                        padding: .init(Brand.Padding.small,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.medium,
                                                                       Brand.Padding.small),
                                                        action: {
                                                            GraniteHaptic.light.invoke()
                                                            sendEvent(ExhibitionEvents.Share(installation: state.installation), .contact)
                                                        }))
                }.frame(maxWidth: .infinity,
                        maxHeight: .infinity)
                .background(Brand.Colors.black.opacity(0.93))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120, maxHeight: .infinity)
        .background(Color.black)
        .border(Brand.Colors.marble, width: 2)
        .modifier(TapAndLongPressModifier(disabled: state.isShowcase,
                                          tapAction: {
                                            guard !state.viewingMarble else { return }
                                            GraniteHaptic.light.invoke()
                                            set(\.isEditing, value: !state.isEditing)
                                            
                                          },
                                          longPressAction: {
                                            GraniteHaptic.light.invoke()
                                            sendEvent(InstallationEvents.ViewMarble())
                                          },
                                          longPressTempAction: { isPressing in
                                           //guard !state.viewingMarble else { return }
                                           //set(\.viewingOriginal, value: isPressing)
                                          })
        )
//        .onReceive(state.loader.didChange) { data in
//            set(\.originalImage, value: GraniteImage(data: data) ?? GraniteImage())
//        }
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}
