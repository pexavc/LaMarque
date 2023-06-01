//
//  ExhibitionComponent.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct ExhibitionComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<ExhibitionCenter, ExhibitionState> = .init()
    
    public init() {}
    
    var columns: [GridItem] {
        [GridItem(.flexible(minimum: 120), spacing: 0)]
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry -> Proxy in
                let frame = geometry.frame(in: CoordinateSpace.global)
                state.globalFrame = frame
                return Proxy()
            }
            
            
            if state.prepared {
                
                switch state.intent {
                case .showcase:
                    InstallationComponent(state: .init(state.installations, isShowcase: true))
                        .attach(to: command)
                        .listen(to: command).frame(maxWidth: .infinity,
                                                   minHeight: 160,//asset.isLandscape ? 160 : (asset.isObviousPortrait ? 640 : 420),
                                                   maxHeight: .infinity,
                                                   alignment: .leading)
                default:
                    installations
                    
                    VStack {
                        if state.isSharing {
                            laMarqueSharing
                        } else {
                            laMarque
                        }
                    }
                }
            }
            
            ListenComponent(state: .init(stage: state.stage, intent: state.intent))
                .listen(to: command)
                .attach(to: command)
        }.background(Brand.Colors.marble)
    }
    
    public var installations: some View {
        ScrollView {
            if EnvironmentConfig.isIPhone {
                VStack(spacing: 0) {
                    ForEach(state.installations, id: \.self) { asset in
                        InstallationComponent(state: .init(asset))
                            .attach(to: command)
                            .listen(to: command).frame(maxWidth: .infinity,
                                                       minHeight: asset.isLandscape ? 160 : (asset.isObviousPortrait ? 640 : 420),
                                                       maxHeight: .infinity,
                                                       alignment: .leading)
                    }
                    
                    Rectangle().foregroundColor(Brand.Colors.marble).frame(height: 100)
                }
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(state.arrangement, id: \.self) { installations in
                        HStack(spacing: 0) {
                            ForEach(installations, id: \.self) { asset in
                                InstallationComponent(state: .init(asset))
                                    .listen(to: command)
                                    .attach(to: command)
                            }
                        }.frame(maxWidth: .infinity,
                                minHeight: 420,
                                maxHeight: .infinity,
                                alignment: .leading)
                        
                    }//.padding(.leading, state.le
                    
                    Rectangle().foregroundColor(Brand.Colors.marble).frame(height: 110)
                }
            }
            
        }.frame(maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center)
    }
    
    public var laMarque: some View {
        LaMarqueComponent(state: .init(state.intent == .add ? .picking : .none))
            .listen(to: command)
            .padding(.bottom, Brand.Padding.large)
    }
    
    public var laMarqueSharing: some View {
        VStack(spacing: 0) {
            LaMarqueComponent(state: .init(state.sharing))
                .listen(to: command)
            Rectangle()
                .foregroundColor(Brand.Colors.black.opacity(0.93))
                .frame(height: Brand.Padding.large)
        }
    }
}
