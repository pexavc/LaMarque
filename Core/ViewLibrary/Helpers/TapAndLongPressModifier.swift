//
//  TapAndLongPressModifier.swift
//  
//
//  Created by PEXAVC on 1/29/21.
//

import Foundation
import SwiftUI

public struct TapAndLongPressModifier: ViewModifier {
    @State private var isLongPressing = false
    let tapAction: (()->())
    let longPressAction: (()->())?
    let longPressTempAction: ((Bool)->())?
    let simultaneous: Bool
    let disabled: Bool
    @GestureState private var isPressingDown: Bool = false 
    
    public init(disabled: Bool = false,
                simultaneous: Bool = false,
                tapAction: @escaping (()->()),
                longPressAction: (()->())? = nil,
                longPressTempAction: ((Bool)->())? = nil) {
        self.disabled = disabled
        self.simultaneous = simultaneous
        self.tapAction = tapAction
        self.longPressAction = longPressAction
        self.longPressTempAction = longPressTempAction
    }
    
    public func body(content: Content) -> some View {
        Passthrough {
            if simultaneous || disabled {
                content
//                    .scaleEffect(isLongPressing ? 0.97 : 1.0)
//                    .simultaneousGesture(
//                        LongPressGesture(minimumDuration: 1.2)
//                            .sequenced(before: LongPressGesture(minimumDuration: .infinity))
//                            .updating($isPressingDown) { value, state, transaction in
//                                switch value {
//                                    case .second(true, nil):
//                                        state = true
//                                    default: break
//                                }
//                            }.onChanged({ isPressing in
//                                withAnimation {
//                                    switch isPressing {
//                                        case .first(true):
//                                            isLongPressing = true
//                                        case .second(true, true), .second(true, nil):
//                                            isLongPressing = false
//                                        default: break
//                                    }
//                                }
//                                switch isPressing {
//                                    case .first(true):
//                                        longPressTempAction?(true)
//                                    case .second(true, true), .second(true, nil):
//                                        longPressTempAction?(false)
//                                        longPressAction?()
//                                    default: break
//                                }
//                            }))
                    
            } else {
                
                content
                    .scaleEffect(isLongPressing ? 0.97 : 1.0)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tapAction()
                    }
        //            .simultaneousGesture(
        //                LongPressGesture(minimumDuration: 1.0)
        //                    .onChanged { isPressing in
        //                        isLongPressing = isPressing
        //                    }
        //                    .onEnded { item in
        //
        //                    }
        //            )
                    .onLongPressGesture(minimumDuration: 1.0, pressing: { (isPressing) in
                        withAnimation {
                            isLongPressing = isPressing
                        }
                        
                        longPressTempAction?(isPressing)
                    }, perform: {
                        longPressAction?()
                    })
            }
        }
    }
}
