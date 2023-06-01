import Foundation
import Metal

#if os(iOS)
import UIKit
#endif

public class PaddedScaleTexture: GraniteStep {
    public typealias Input = MTLTexture
    public typealias Output = MTLTexture
    
    let width: Int
    let height: Int
    
    var scene: GraniteScene?
    var kernel: MetalKernel?

    public init(width : Int, height : Int) {
        self.width = width
        self.height = height
    }
    
    public func invalidate(context: GraniteScene) {
        self.scene = context
        self.kernel = MetalKernel(name: "PaddedScaleTexture", scene: context)
    }
    
    public func execute(input: MTLTexture, state: GranitePipelineState) throws -> MTLTexture? {
        guard let kernel = kernel else {
            throw PipelineRuntimeError.missingContext(self)
        }
        
        let w = kernel.pipelineState.threadExecutionWidth
        let h = kernel.pipelineState.maxTotalThreadsPerThreadgroup / w
        let threadsPerThreadgroup = MTLSizeMake(w, h, 1)
        
        //Creating the output texture descriptor
        let outputTextureDescriptor : MTLTextureDescriptor = {
            let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: input.pixelFormat,
                                                                      width: width,
                                                                      height: height,
                                                                      mipmapped: false)
            descriptor.usage = [.shaderRead, .shaderWrite]
            return descriptor
        }()
        
        
        //Creating the output texture
        guard let output = scene?.device.makeTexture(descriptor: outputTextureDescriptor) else {
            throw PipelineRuntimeError.genericError(self, "Cannot make texture to padded scale the texture")
        }
        
        let encoder = state.commandBuffer.makeComputeCommandEncoder()
        encoder?.setTexture(input, index: 0)
        encoder?.setTexture(output, index: 1)
        encoder?.dispatch(
            pipeline: kernel.pipelineState,
            width: width,
            height: height)
        encoder?.endEncoding()
        
        state.currentInputSize = CGSize(width: output.width, height: output.height)
        
        return output
    }
    
}
