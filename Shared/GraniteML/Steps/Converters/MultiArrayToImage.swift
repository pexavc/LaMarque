import Foundation
import Metal
import CoreML
import GraniteUI

public struct MutliArrayToImage: GraniteStep {
    public typealias Input = Any
    public typealias Output = GraniteImage
    
    public init() {
        
    }
    
    public func execute(input: Any, state: GranitePipelineState) throws -> GraniteImage? {
        var array : MLMultiArray? = nil
        
        if let input = input as? [String : Any] {
            array = input.values.first as? MLMultiArray
        }
        else if let input = input as? MLMultiArray {
            array = input
        }
        
        guard let cgImage = array?.cgImage(min: -5, max: 5, channel: nil, axes: (2, 3, 4)) else {
            throw PipelineRuntimeError.genericError(self, "Cannot convert mask into CGImage")
        }
        
        return GraniteImage(cgImage: cgImage, size: .init(cgImage.width, cgImage.height))
    }
    
}
