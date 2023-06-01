import Foundation
import Metal
import MetalPerformanceShaders

open class ScaleTexture : GraniteStep {
    
    public enum ScaleMode {
        case aspectFillAdaptive //Mainly for depth
        case aspectFitTighten
        case aspectFit
        case aspectFill
        case stretch
    }
    
    public typealias Input = MTLTexture
    public typealias Output = MTLTexture

    let width : Int
    let height : Int
    let mode : ScaleMode

    var context : GraniteScene?
    var scale : MPSImageBilinearScale?
    var adaptive: GranitePipeline<PaddedScaleTexture.Output>?
    
    public init(width : Int, height : Int, mode : ScaleMode = .aspectFill) {
        self.width = width
        self.height = height
        self.mode = mode
        
    }
    
    func AdaptivePipeline(
        format: MTLPixelFormat = .bgra8Unorm,
        width: Int,
        height: Int) -> GranitePipeline<PaddedScaleTexture.Output> {
        
        return PassthroughPipe()
            .add(PaddedScaleTexture(
                width: width,
                height: height))
    }
    
    public func invalidate(context : GraniteScene) {
        self.context = context
        self.scale = MPSImageBilinearScale(device: context.device)
    }
    
    public func execute(input: MTLTexture, state: GranitePipelineState) throws -> MTLTexture? {
        
        if mode == .aspectFillAdaptive {
            adaptive = AdaptivePipeline(
                format: input.pixelFormat,
                width: width,
                height: height)
        }
        
        var transform = MPSScaleTransform(scaleX: 0, scaleY: 0, translateX: 0, translateY: 0)
        
        let inputSize: CGSize = .init(width: input.width, height: input.height)
        let outputSize: CGSize = .init(width: width, height: height)
        let scaleX = Double(outputSize.width / inputSize.width)
        let scaleY = Double(outputSize.height / inputSize.height)
        let scaleValue = (mode == .aspectFill) ? max(scaleX, scaleY) : min(scaleX, scaleY)
        
        
        
        let newWidth: Int
        let newHeight: Int
        
        if mode == .aspectFitTighten {
            newWidth = Int(Double(inputSize.width)*scaleValue)
            newHeight = Int(Double(inputSize.height)*scaleValue)
        } else {
            newWidth = width
            newHeight = height
        }
        
        
        if mode == .stretch {
            transform = MPSScaleTransform(scaleX: scaleX, scaleY: scaleY, translateX: 0, translateY: 0)
        }
        else {
            
            let xPadding = ((Double(inputSize.width)*scaleValue) - Double(outputSize.width))/2
            let yPadding = ((Double(inputSize.height)*scaleValue) - Double(outputSize.height))/2
            
            let translateX: Double = (mode == .aspectFill) ? -xPadding : 0
            let translateY: Double = (mode == .aspectFill) ? -yPadding : 0
            
            transform = MPSScaleTransform(scaleX: scaleValue, scaleY: scaleValue, translateX: translateX, translateY: translateY)
        }
        
        withUnsafePointer(to: &transform) { ptr in
            scale?.scaleTransform = ptr
        }
        
        
        //Creating the output texture descriptor
        let outputTextureDescriptor : MTLTextureDescriptor = {
            let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: input.pixelFormat,
                                                                      width:  newWidth,
                                                                      height: newHeight,
                                                                      mipmapped: false)
            descriptor.usage = [.shaderRead, .shaderWrite]
            return descriptor
        }()
        
        //Creating the output texture
        guard let output = context?.device.makeTexture(descriptor: outputTextureDescriptor) else {
            throw PipelineRuntimeError.genericError(self, "Cannot make texture to scale the texture")
        }
        
        scale?.encode(commandBuffer: state.commandBuffer,
                     sourceTexture: input,
                     destinationTexture: output)
        
        var adaptiveOutput: MTLTexture? = nil
        if mode == .aspectFillAdaptive {
            state.insertCommandBufferExecutionBoundary()
            adaptiveOutput = try? adaptive?.run(on: output)
            state.currentInputSize = CGSize(width: adaptiveOutput?.width ?? 0, height: adaptiveOutput?.height ?? 0)
            return adaptiveOutput
        } else {
            state.currentInputSize = CGSize(width: output.width, height: output.height)
            return output
        }
        
    }
    
}
