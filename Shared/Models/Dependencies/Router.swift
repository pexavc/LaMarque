//
//  Router.swift
//   (iOS)
//
//  Created by PEXAVC on 1/6/21.
//

import Foundation
import GraniteUI
import SwiftUI

class RouterDependency: GraniteRouterDependable {
    var router: Router = .init()
    var authState: AuthState = .none
}

public class Router: GraniteRouter {
//    public var route: GraniteRoute = Route.home
//    public var home: GraniteAdAstra? = nil
    
//    public override func request(_ route: GraniteRoute) {
//        guard let newRoute = route.convert(to: Route.self) else { return }
//        clean()
//
//        self.route = newRoute
//    }
//
}

class LaMarqueDependencies: GraniteDependencyManager {
    private let router: RouterDependency
    private let environment: EnvironmentDependency
    
    init() {
        self.router = .init()
        self.environment = .init()
        addDependencies()
    }
    
    private func addDependencies() {
        let resolver = GraniteResolver.shared
        
        resolver.add(router)
        resolver.add(environment)
    }
}
