import Foundation
import Metal
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension CGImage {
    
    func toTexture(with device : MTLDevice) -> MTLTexture? {
        let sourceImageWidth : Int = self.width
        let sourceImageHeight : Int = self.height
        let sourceBPR : Int = sourceImageWidth * 4
        let sourceBPC : Int = 8
        let sourceColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let sourceBitmapInfo : CGBitmapInfo = [.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)]
        
        var imageData : [UInt8] = [UInt8](repeating: 0, count: sourceImageHeight * sourceImageWidth * 4)
        
        guard let imageCtx : CGContext = CGContext(data: &imageData, width: sourceImageWidth, height: sourceImageHeight, bitsPerComponent: sourceBPC, bytesPerRow: sourceBPR, space: sourceColorSpace, bitmapInfo: sourceBitmapInfo.rawValue) else {
            return nil
        }
        
        imageCtx.interpolationQuality = .none
        imageCtx.draw(self, in: CGRect(x: 0, y: 0, width: CGFloat(sourceImageWidth), height: CGFloat(sourceImageHeight)))
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: sourceImageWidth, height: sourceImageHeight, mipmapped: false)
        textureDescriptor.usage = [.shaderRead, .shaderWrite]
        
        guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
            return nil
        }
        
        let region = MTLRegionMake2D(0, 0, sourceImageWidth, sourceImageHeight)
        texture.replace(region: region, mipmapLevel: 0, withBytes:&imageData, bytesPerRow:sourceBPR)
        
        return texture
    }
    
}
