//
//  ContentView.swift
//  Shared
//
//  Created by PEXAVC on 12/18/20.
//

import GraniteUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        RouterComponent()
            .frame(minWidth: 480,
                   minHeight: 480)
        #else
        RouterComponent()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
