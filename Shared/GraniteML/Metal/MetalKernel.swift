import Foundation
import Metal
import MetalPerformanceShaders

public struct MetalKernel {
    
    //Pipeline descriptor instance
    public let pipelineState : MTLComputePipelineState
    
    public init(name: String, scene: GraniteScene) {
        if let function = scene.library.makeFunction(name: name) {
            let descriptor = MTLComputePipelineDescriptor()
            descriptor.threadGroupSizeIsMultipleOfThreadExecutionWidth = false
            descriptor.computeFunction = function
            
            do {
                self.pipelineState = try scene.device.makeComputePipelineState(descriptor: descriptor,
                                                                               options: MTLPipelineOption(),
                                                                               reflection: nil)
            }
            catch let error {
                fatalError("Cannot initialize MetalKernel with function named '\(name)': \(error.localizedDescription).")
            }
        }
        else {
            fatalError("Cannot initialize MetalKernel with function named '\(name)'.")
        }
    }
    
}
