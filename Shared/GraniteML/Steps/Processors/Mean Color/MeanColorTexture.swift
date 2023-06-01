import Foundation
import Metal
import simd

public class MeanColorTexture: GraniteStep {
    public typealias Input = MTLTexture
    public typealias Output = MTLTexture
  
    let color : SIMD4<Int32>

    var kernel : MetalKernel?
    var buffer : MetalBuffer<SIMD4<Int32>>?
    
    public init(red : Int, green : Int, blue : Int, alpha : Int = 0) {
        self.color = SIMD4<Int32>(Int32(red), Int32(green), Int32(blue), Int32(alpha))
    }
    
    public func invalidate(context: GraniteScene) {
        self.kernel = MetalKernel(name: "MeanColorTexture", scene: context)
        self.buffer = MetalBuffer(data: color, context: context)
    }
    
    public func execute(input: MTLTexture, state: GranitePipelineState) throws -> MTLTexture? {
        guard let kernel = kernel, let buffer = buffer else {
            throw PipelineRuntimeError.missingContext(self)
        }
        
        let output = input
        
        let encoder = state.commandBuffer.makeComputeCommandEncoder()
        encoder?.setMetalBuffer(buffer, offset: 0, index: 0)
        encoder?.setTexture(input, index: 0)
        encoder?.setTexture(output, index: 1)
        encoder?.dispatch(
            pipeline: kernel.pipelineState,
            width: input.width,
            height: input.height)
        encoder?.endEncoding()
        
        return output
    }
    
}


