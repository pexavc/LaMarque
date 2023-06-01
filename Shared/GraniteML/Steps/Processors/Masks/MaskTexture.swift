import Foundation
import Metal

public class MaskTexture: GraniteStep {
    public typealias Input = [String: MTLTexture]
    public typealias Output = MTLTexture
    
    var kernel : MetalKernel?

    public init() {
        
    }

    public func invalidate(context: GraniteScene) {
        self.kernel = MetalKernel(name: "MaskTexture", scene: context)
    }
    
    public func execute(input: [String : MTLTexture], state: GranitePipelineState) throws -> MTLTexture? {
        guard let kernel = kernel else {
            throw PipelineRuntimeError.missingContext(self)
        }
        
        guard let mask = input["mask"], let input = input["image"] else {
            throw PipelineRuntimeError.genericError(self, "Expected 'mask' and 'image' to be present as arguments")
        }
  
        let output = input
        
        let encoder = state.commandBuffer.makeComputeCommandEncoder()
        encoder?.setTexture(input, index: 0)
        encoder?.setTexture(output, index: 1)
        encoder?.setTexture(mask, index: 2)
        encoder?.dispatch(
            pipeline: kernel.pipelineState,
            width: input.width,
            height: input.height)
        encoder?.endEncoding()
        
        return output
    }
    
}
