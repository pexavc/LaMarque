import Foundation
import Metal

public struct MetalBuffer<T> {
    
    public let nativeBuffer : MTLBuffer
    
    public init(data : T, context : GraniteScene) {
        let dataLength = MemoryLayout<T>.size
        
        if let buffer = context.device.makeBuffer(length: dataLength, options: []) {
            self.nativeBuffer = buffer
        }
        else {
            fatalError("Cannot initialize buffer for data.")
        }
        
        var data = data
        memcpy(nativeBuffer.contents(), &data, dataLength)
    }
    
    public init(context : GraniteScene) {
        let dataLength = MemoryLayout<T>.stride
        
        if let buffer = context.device.makeBuffer(length: dataLength, options: []) {
            self.nativeBuffer = buffer
        }
        else {
            fatalError("Cannot initialize buffer for data.")
        }
    }
    
}

public extension MTLComputeCommandEncoder {
    
    func setMetalBuffer<T>(_ buffer : MetalBuffer<T>, offset : Int, index : Int) {
        self.setBuffer(buffer.nativeBuffer, offset: offset, index: index)
    }
    
}
