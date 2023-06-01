//
//  GraniteStep.swift
//  
//
//  Created by 0xKala on 1/16/22.
//

import Foundation

public protocol GraniteStep: GranitePipe {
    func invalidate(context: GraniteScene)
}

extension GraniteStep {
    public func invalidate(context: GraniteScene) {}
}

extension GranitePipe {
    public func add<T1: GraniteStep>(_ input: T1) -> GranitePipeline<T1.Output> {
        return GranitePipeline(executables: [self, input], scene: GraniteScene())
    }
}
