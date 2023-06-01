import Foundation
import CoreGraphics
import Metal
import GraniteUI
#if os(iOS)
import UIKit
#endif

extension CGImage {
    
    class func fromTexture(_ texture: MTLTexture,
                              scale: Float = 1,
                              offset: Float = 0) -> CGImage? {
        switch texture.pixelFormat {
        case .rgba8Unorm:
            return fromTextureRGBA8Unorm(texture)
        case .bgra8Unorm, .bgra8Unorm_srgb:
            return fromTextureBGRA8Unorm(texture)
        case .r8Unorm:
            return fromTextureR8Unorm(texture)
        case .r8Uint:
            return fromTextureR8Uint(texture)
        default:
            GraniteLogger.error("unsupported MTLTexture pixel format while converting to CGImage.", .metal)
            return nil
        }
    }
    
    fileprivate class func fromTextureRGBA8Unorm(_ texture: MTLTexture) -> CGImage? {
        assert(texture.pixelFormat == .rgba8Unorm)
        
        let w = texture.width
        let h = texture.height
        var bytes = texture.toUInt8Array(width: w, height: h, featureChannels: 4)
        return CGImage.fromByteArray(&bytes, width: w, height: h)
    }
    
    fileprivate class func fromTextureBGRA8Unorm(_ texture: MTLTexture) -> CGImage? {
        assert(texture.pixelFormat == .bgra8Unorm || texture.pixelFormat == .bgra8Unorm_srgb)
        
        let w = texture.width
        let h = texture.height
        var bytes = texture.toUInt8Array(width: w, height: h, featureChannels: 4)
        
        for i in 0..<bytes.count/4 {
            bytes.swapAt(i*4 + 0, i*4 + 2)
        }
        
        return CGImage.fromByteArray(&bytes, width: w, height: h)
    }
    
    fileprivate class func fromTextureR8Unorm(_ texture: MTLTexture) -> CGImage? {
        assert(texture.pixelFormat == .r8Unorm)
        
        let w = texture.width
        let h = texture.height
        var bytes = texture.toUInt8Array(width: w, height: h, featureChannels: 1)
        
        var rgbaBytes = [UInt8](repeating: 0, count: w * h * 4)
        for i in 0..<bytes.count {
            rgbaBytes[i*4 + 0] = bytes[i]
            rgbaBytes[i*4 + 1] = bytes[i]
            rgbaBytes[i*4 + 2] = bytes[i]
            rgbaBytes[i*4 + 3] = 255
        }
        
        return CGImage.fromByteArray(&rgbaBytes, width: w, height: h)
    }
    
    fileprivate class func fromTextureR8Uint(_ texture: MTLTexture) -> CGImage? {
        assert(texture.pixelFormat == .r8Uint)
        
        let w = texture.width
        let h = texture.height
        var bytes = texture.toUInt8Array(width: w, height: h, featureChannels: 1)

        var rgbaBytes = [UInt8](repeating: 0, count: w * h * 4)
        for i in 0..<bytes.count {
            rgbaBytes[i*4 + 0] = bytes[i]
            rgbaBytes[i*4 + 1] = bytes[i]
            rgbaBytes[i*4 + 2] = bytes[i]
            rgbaBytes[i*4 + 3] = bytes[i] == 0 ? 0 : 255
        }
        
        return CGImage.fromByteArray(&rgbaBytes, width: w, height: h)
    }
    
    @nonobjc class func fromByteArray(_ bytes: UnsafeMutableRawPointer,
                                      width: Int,
                                      height: Int) -> CGImage? {
        
        if let context = CGContext(data: bytes, width: width, height: height,
                                   bitsPerComponent: 8, bytesPerRow: width * 4,
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
            let cgImage = context.makeImage() {
            return cgImage
        } else {
            return nil
        }
    }
    
}

