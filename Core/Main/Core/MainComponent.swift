//
//  MainComponent.swift
//  
//
//  Created by PEXAVC on 12/19/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine


public struct MainComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<MainCenter, MainState> = .init()
    
    @Environment(\.scenePhase) var scenePhase
    
    public init() {
        command
            .center
            .routerDependency
            .router
            .home = command.center
    }
    
    var environment: EnvironmentComponent {
        EnvironmentComponent(state: .init(inject(\.routerDependency,
                                                    target: \.router.route)))
    }
    
    var controls: ControlBar {
        ControlBar(headerTitle: state.exhibitionName,
                   isIPhone: EnvironmentConfig.isIPhone,
                   currentRoute: command.center.routerDependency.router.route.convert(to: Route.self) ?? .exhibition(.none),
                   onRoute: { route in
            command.center.routerDependency.router.request(route)
        })
    }
    
    public var body: some View {
        switch command.center.authState {
        case .authenticated:
            VStack(spacing: 0) {
                controls
                environment
                    .listen(to: command)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .ignoresSafeArea(.all, edges: .bottom)
            .background(Color.black)
            .onChange(of: scenePhase) { newPhase in
                #if os(iOS)
                if newPhase == .inactive {
                } else if newPhase == .active {
                    if let newShare = checkShared() {
                        command.center.routerDependency.router.request(Route.verify(.check(newShare)))
                    }
                } else if newPhase == .background {
                }
                #endif
            }
        case .notAuthenticated:
            VStack(spacing: 0) {
                HStack {
                    
                    TextField("name of your exhibition",
                              text: _state.exhibitionName)
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .padding(.leading, Brand.Padding.small)
                        .padding(.trailing, Brand.Padding.small)
                        .multilineTextAlignment(.center)
                    
                }
                .frame(height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.top, Brand.Padding.large)
                .padding(.bottom, Brand.Padding.medium)
                
                GraniteButtonComponent(state: .init("open",
                                                    textColor: Brand.Colors.greyV2,
                                                    colors: [Brand.Colors.black,
                                                             Brand.Colors.marble.opacity(0.24)],
                                                    shadow: Brand.Colors.marble.opacity(0.57),
                                                    padding: .init(Brand.Padding.medium,
                                                                   Brand.Padding.small,
                                                                   Brand.Padding.medium,
                                                                   Brand.Padding.small),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        sendEvent(MainEvents.User())
                                                    }))
                    .padding(.bottom, Brand.Padding.medium)
            }.background(Brand.Colors.black)
            .frame(maxWidth: 300)
            .border(Brand.Colors.marble, width: 2)
        case .none:
            GraniteLoadingComponent()
//            .padding(.leading, Brand.Padding.large)
//            .padding(.trailing, Brand.Padding.large)
        }
    }
    #if os(iOS)
    public func checkShared() -> SharePayload? {
        let userDefault = UserDefaults(suiteName: Constants.General.groupName)
        var sharePayload = SharePayload()
        if userDefault != nil, let dict = userDefault!.value(forKey: "imgViaShareiOS") as? NSDictionary {
            
            if let data = dict.value(forKey: "imgData") as? Data,
                let image = UIImage(data: data){
                
                sharePayload.image = image
            } else if let _ = dict.value(forKey: "url") as? String {
                sharePayload.isUrl = true
            } else {
                sharePayload.isUnknown = true
            }
            
//            self.services.dataService.sharePayload = sharePayload
            userDefault!.removePersistentDomain(forName: Constants.General.groupName)
            userDefault!.synchronize()
            
            return sharePayload
            
//            for viewController in self.navigationController.viewControllers {
//                if let homeController = viewController as? HomeController {
//                    homeController.syncServices(self.services)
//
//                    if self.navigationController.viewControllers.count > 1 {
//                        self.navigationController.popToRootViewController(animated: true)
//                    }
//
//                    if isActive {
//                        homeController.checkShared()
//                    }
//                }
//            }
        } else {
            return nil
        }
    }
    #endif
}

public struct SharePayload: Equatable, Hashable {
    var image : GraniteImage? = nil
    var isUrl : Bool = false
    var isUnknown : Bool = false
}
