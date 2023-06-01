//
//  BasicButton.swift
//  
//
//  Created by PEXAVC on 1/4/21.
//

import SwiftUI

struct BasicButton: View {
    var text: String
    var textColor: Color
    var colors: [Color]
    var shadow: Color
    
    var body: some View {
        HStack(alignment: .center) {
            
            ZStack {
                GradientView(colors: colors,
                             cornerRadius: 6.0,
                             direction: .topLeading).overlay(
                    
                    GraniteText(text,
                                textColor,
                                .subheadline,
                                .bold,
                                .center)
                )
                .frame(width: 120, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(color: shadow, radius: 2, x: 1, y: 1)
                
            }
        }
    }
}

//struct BasicButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicButton()
//    }
//}
