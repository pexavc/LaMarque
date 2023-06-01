import Foundation
import Metal

extension MTLTexture {

    func toFloatArray(width: Int, height: Int, featureChannels: Int) -> [Float] {
        return toArray(width: width, height: height, featureChannels: featureChannels, initial: Float(0))
    }

    func toUInt8Array(width: Int, height: Int, featureChannels: Int) -> [UInt8] {
        return toArray(width: width, height: height, featureChannels: featureChannels, initial: UInt8(0))
    }

    func toArray<T>(width: Int, height: Int, featureChannels: Int, initial: T) -> [T] {
        assert(featureChannels != 3 && featureChannels <= 4, "channels must be 1, 2, or 4")

        var bytes = [T](repeating: initial, count: width * height * featureChannels)
        let region = MTLRegionMake2D(0, 0, width, height)
        
        getBytes(&bytes, bytesPerRow: width * featureChannels * MemoryLayout<T>.stride,
                 from: region, mipmapLevel: 0)
        
        return bytes
    }
    
}

