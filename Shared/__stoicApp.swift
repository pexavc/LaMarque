//
//  __stoicApp.swift
//  Shared
//
//  Created by PEXAVC on 12/18/20.
//

import SwiftUI

@main
struct __stoicApp: App {
    //Property wrapped injectable dependencies
    //should exist at the most top-level component
    //of an aplicatino interface. In this project
    //its `App`
    private let dependencies = LaMarqueDependencies()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}
