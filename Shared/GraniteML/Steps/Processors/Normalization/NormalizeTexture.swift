import Foundation
import Metal
import simd

public class NormalizeTexture: GraniteStep {
    public typealias Input = MTLTexture
    public typealias Output = MTLTexture

    let normalization : float2
    
    var context : GraniteScene?
    var kernel : MetalKernel?
    var buffer : MetalBuffer<float2>?
    
    public init(min : Float = 0.0, max : Float = 1.0) {
        self.normalization = float2(min, max)
    }
    
    public func invalidate(context: GraniteScene) {
        self.context = context
        self.kernel = MetalKernel(name: "NormalizeTexture", scene: context)
        self.buffer = MetalBuffer(data: normalization, context: context)
    }
    
    public func execute(input: NormalizeTexture.Input, state: GranitePipelineState) throws -> NormalizeTexture.Output? {
        guard let kernel = kernel, let buffer = buffer else {
            throw PipelineRuntimeError.missingContext(self)
        }
        
        let w = kernel.pipelineState.threadExecutionWidth
        let h = kernel.pipelineState.maxTotalThreadsPerThreadgroup / w
        let threadsPerThreadgroup = MTLSizeMake(w, h, 1)
        
        //Creating the output texture descriptor
        let outputTextureDescriptor : MTLTextureDescriptor = {
            let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: input.pixelFormat,
                                                                      width: input.width,
                                                                      height: input.height,
                                                                      mipmapped: false)
            descriptor.usage = [.shaderRead, .shaderWrite]
            return descriptor
        }()
        
        //Creating the output texture
        guard let output = context?.device.makeTexture(descriptor: outputTextureDescriptor) else {
            throw PipelineRuntimeError.genericError(self, "Cannot make texture to padded scale the texture")
        }
        
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
