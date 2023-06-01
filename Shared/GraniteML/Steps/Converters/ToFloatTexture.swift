import Foundation
import Metal

public class ToFloatTexture: GraniteStep {
    public typealias Input = MTLTexture
    public typealias Output = MTLTexture
    
    var context : GraniteScene?
    var kernel : MetalKernel?
    var format: MTLPixelFormat
    
    public init(
        format: MTLPixelFormat = .rgba32Float) {
        self.format = format
    }
    
    public func invalidate(context: GraniteScene) {
        self.context = context
        self.kernel = MetalKernel(name: "FloatTexture", scene: context)
    }
    
    public func execute(input: NormalizeTexture.Input, state: GranitePipelineState) throws -> NormalizeTexture.Output? {
        guard let kernel = kernel else {
            throw PipelineRuntimeError.missingContext(self)
        }
        
        guard let output = context?.device.makeTexture(descriptor:
                                                        MTLTextureDescriptor.basicRW(format: format, input: input)) else {
            throw PipelineRuntimeError.genericError(self, "Cannot make texture to convert to float texture")
        }
        
        let encoder = state.commandBuffer.makeComputeCommandEncoder()
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
