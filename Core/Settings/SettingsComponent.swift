//
//  SettingsComponent.swift
//  stoic
//
//  Created by PEXAVC on 1/30/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct SettingsComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<SettingsCenter, SettingsState> = .init()
    
    var exhibitionName: String
    var exhibitionID: String
    var exhibitionSite: String
    public init() {
        exhibitionName = Services.shared.localStorage.get(GlobalDefaults.ExhibitionName, defaultValue: "")
        exhibitionID = Services.shared.localStorage.get(GlobalDefaults.ExhibitionID, defaultValue: "")
        exhibitionSite = Services.shared.localStorage.get(GlobalDefaults.ExhibitionSite, defaultValue: "")
    }
    
    class toggleMarble: ObservableObject {
        @Published var isOn: Bool = false {
            didSet {
                Services.shared.localStorage.update(isOn ? GlobalDefaults.Encoding.marbled : GlobalDefaults.Encoding.original)
            }
        }
        
        public init() {
            isOn = Services.shared.localStorage.get(GlobalDefaults.Encoding.self) == GlobalDefaults.Encoding.marbled.value
        }
        
    }
    
    @ObservedObject var toggleMarbleStore: toggleMarble = .init()
    
    var version: String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return "unknown"
        }
        let version = (dictionary["CFBundleShortVersionString"] as? String) ?? "unknown"
//        let build = dictionary["CFBundleVersion"] as! String
        return "\(version)"
    }
    
    @State private var toggleMarbled = false
    
    public var body: some View {
        VStack {
            Toggle("encode \"marbled\" images over originals",
                   isOn: $toggleMarbleStore.isOn)
                   .font(Fonts.specific(.subheadline, .regular, type: .menlo))
                   .padding(.top, Brand.Padding.large)
                .toggleStyle(SwitchToggleStyle(tint: Brand.Colors.marble))
            
            if exhibitionSite.isNotEmpty,
               let url = URL.init(string: Installation.gateway+exhibitionSite) {
                Spacer()
                
                VStack {
                    Link("your exhibition on ipfs",
                          destination: url)
                        .foregroundColor(Brand.Colors.marble)
                        .font(Fonts.live(.headline, .regular))
                }.padding(.top, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .padding(.leading, Brand.Padding.medium)
                .padding(.bottom, Brand.Padding.medium)
                .background(Brand.Colors.black)
                .border(Brand.Colors.marble, width: 2)
            }
            GraniteText("exhibition id: \(exhibitionID.lowercased())",
                        Brand.Colors.marble,
                        .subheadline,
                        .regular,
                        fontType: .menlo)
                        .padding(.top, Brand.Padding.medium)
            
            Spacer()
            GraniteText("La Marque v\(version)",
                        Brand.Colors.marble,
                        .headline,
                        .bold,
                        fontType: .menlo)
                        .padding(.bottom, Brand.Padding.xSmall)
            GraniteText("site: https://stoic.nyc",
                        Brand.Colors.yellow,
                        .subheadline,
                        .bold,
                        fontType: .menlo)
                        .padding(.bottom, Brand.Padding.xSmall)
            GraniteText("© 2019-\(Date.today.dateComponents().year) Stoic Collective, LLC.\nAll Rights Reserved",
                        .footnote,
                        fontType: .menlo)
                .padding(.bottom, Brand.Padding.large)
            GraniteText("[ Thank you for using La Marque, \(exhibitionName). \ncontact :: twitter/github/instagram - @pexavc ]",
                        Brand.Colors.marble,
                        .subheadline,
                        .boldItalic)
                .padding(.bottom, Brand.Padding.large)
        }.frame(maxWidth: .infinity)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
