//
//  MetalAssistant.swift
//
//
//  Created by 0xKala on 9/14/20.
//

import Foundation
import Metal
import SwiftUI
import GraniteUI

public struct MetalAssistant {
    public struct Pipelines {
        public let imageIO: GranitePipeline<MTLTexture>
        public let imageScaleableIO: GranitePipeline<MTLTexture>
        public let textureScaleableIO: GranitePipeline<MTLTexture>
        public let floatTextureIO: GranitePipeline<MTLTexture>
        public let textureIO: GranitePipeline<GraniteImage>
        public let paddedTextureIO: GranitePipeline<MTLTexture>
    }
    
    public let pipeline: Pipelines
    public let device: MTLDevice?
    public init(
        referenceSize size: CGSize,
        format: MTLPixelFormat = .bgra8Unorm,
        floatFormat: MTLPixelFormat = .rgba32Float,
        makeTextureView: Bool = true,
        mode: ScaleTexture.ScaleMode = .aspectFit
        ) {
        pipeline = .init(
            imageIO: MetalAssistant.ImageToTexturePipeline(
                format: format,
                makeTextureView: makeTextureView),
            imageScaleableIO: MetalAssistant.ImageToTexturePipelineScaleable(
                size,
                format: format,
                makeTextureView: makeTextureView,
                mode: mode),
            textureScaleableIO: MetalAssistant.TextureScalePipeline(
                size,
                mode: mode),
            floatTextureIO: MetalAssistant.FloatTexturePipeline(format: format),
            textureIO: MetalAssistant.TextureToImagePipeline(),
            paddedTextureIO: MetalAssistant.PaddedTexturePipeline(size))
        
        device = MTLCreateSystemDefaultDevice()
    }
}

//MARK: Pipeline Creation
extension MetalAssistant {
    public static func ImageToTexturePipelineScaleable(
        _ scale: CGSize,
        format: MTLPixelFormat = .bgra8Unorm,
        makeTextureView: Bool = true,
        mode: ScaleTexture.ScaleMode = .aspectFit)
    -> GranitePipeline<MTLTexture> {
        
        return PassthroughPipe()
            .add(ImageToTexture(
                format: format,
                makeTextureView: makeTextureView))
            .add(ScaleTexture(
                width: Int(scale.width),
                height: Int(scale.height),
                mode: mode))
    }
    
    public static func ImageToTexturePipeline(
        format: MTLPixelFormat = .bgra8Unorm,
        makeTextureView: Bool = true) -> GranitePipeline<MTLTexture> {
        return PassthroughPipe()
            .add(ImageToTexture(
                format: format,
                makeTextureView: makeTextureView))
    }
    
    public static func TextureScalePipeline(
        _ scale: CGSize,
        mode: ScaleTexture.ScaleMode = .aspectFit) -> GranitePipeline<MTLTexture> {
        return PassthroughPipe()
            .add(ScaleTexture(
            width: Int(scale.width),
            height: Int(scale.height),
            mode: mode))
    }
    
    public static func FloatTexturePipeline(
        format: MTLPixelFormat = .rgba32Float) -> GranitePipeline<MTLTexture> {
        return PassthroughPipe().add(ToFloatTexture(format: format))
    }
    
    public static func TextureToImagePipeline() -> GranitePipeline<GraniteImage> {
        return PassthroughPipe().add(TextureToImage())
    }
    
    public static func PaddedTexturePipeline(
        _ scale: CGSize,
        mode: ScaleTexture.ScaleMode = .aspectFillAdaptive) -> GranitePipeline<MTLTexture> {
        return PassthroughPipe()
            .add(PaddedScaleTexture(
                width: Int(scale.width),
                height: Int(scale.height)))
    }
}

//MARK: Buffer tools
extension MetalAssistant {
    public static func makeMetalCompatible(_ buffer: CVPixelBuffer?) -> CVPixelBuffer? {
        // Other possible options:
        //   String(kCVPixelBufferOpenGLCompatibilityKey): true,
        //   String(kCVPixelBufferIOSurfacePropertiesKey): [
        //     "IOSurfaceOpenGLESFBOCompatibility": true,
        //     "IOSurfaceOpenGLESTextureCompatibility": true,
        //     "IOSurfaceCoreAnimationCompatibility": true
        //   ]
        
        guard let buffer = buffer else { return nil }
        let attributes: [String: Any] = [
            String(kCVPixelBufferMetalCompatibilityKey): true,
        ]
        return MetalAssistant.deepCopy(buffer, withAttributes: attributes)
    }
    
    /**
    Copies a CVPixelBuffer to a new CVPixelBuffer.
    This lets you specify new attributes, such as whether the new CVPixelBuffer
    must be IOSurface-backed.
    See: https://developer.apple.com/library/archive/qa/qa1781/_index.html
    */
    public static func deepCopy(
        _ buffer: CVPixelBuffer,
        withAttributes attributes: [String: Any] = [:]) -> CVPixelBuffer? {
        
        let srcPixelBuffer = buffer
        let srcFlags: CVPixelBufferLockFlags = .readOnly
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(srcPixelBuffer, srcFlags) else {
            return nil
        }
        defer { CVPixelBufferUnlockBaseAddress(srcPixelBuffer, srcFlags) }

        var combinedAttributes: [String: Any] = [:]

        // Copy attachment attributes.
        if let attachments = CVBufferGetAttachments(srcPixelBuffer, .shouldPropagate) as? [String: Any] {
          for (key, value) in attachments {
            combinedAttributes[key] = value
          }
        }

        // Add user attributes.
        combinedAttributes = combinedAttributes.merging(attributes) { $1 }

        var maybePixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         CVPixelBufferGetWidth(srcPixelBuffer),
                                         CVPixelBufferGetHeight(srcPixelBuffer),
                                         CVPixelBufferGetPixelFormatType(srcPixelBuffer),
                                         combinedAttributes as CFDictionary,
                                         &maybePixelBuffer)

        guard status == kCVReturnSuccess, let dstPixelBuffer = maybePixelBuffer else {
            return nil
        }

        let dstFlags = CVPixelBufferLockFlags(rawValue: 0)
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(dstPixelBuffer, dstFlags) else {
            return nil
        }
        
        defer { CVPixelBufferUnlockBaseAddress(dstPixelBuffer, dstFlags) }

        for plane in 0...max(0, CVPixelBufferGetPlaneCount(srcPixelBuffer) - 1) {
            if let srcAddr = CVPixelBufferGetBaseAddressOfPlane(srcPixelBuffer, plane),
               let dstAddr = CVPixelBufferGetBaseAddressOfPlane(dstPixelBuffer, plane) {
                    let srcBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(srcPixelBuffer, plane)
                    let dstBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(dstPixelBuffer, plane)

                    for h in 0..<CVPixelBufferGetHeightOfPlane(srcPixelBuffer, plane) {
                        let srcPtr = srcAddr.advanced(by: h*srcBytesPerRow)
                        let dstPtr = dstAddr.advanced(by: h*dstBytesPerRow)
                        dstPtr.copyMemory(from: srcPtr, byteCount: srcBytesPerRow)
                    }
            }
        }
        return dstPixelBuffer
    }
}

//MARK: Debug tools
extension MetalAssistant {
    public static func toFloatArray(_ texture: MTLTexture, featureChannels: Int) -> [Float] {
        return toArray(texture, featureChannels: featureChannels, initial: Float(0))
    }

    public static  func toUInt8Array(_ texture: MTLTexture, featureChannels: Int) -> [UInt8] {
        return toArray(texture, featureChannels: featureChannels, initial: UInt8(0))
    }

    public static func toArray<T>(_ texture: MTLTexture, featureChannels: Int, initial: T) -> [T] {
        assert(featureChannels != 3 && featureChannels <= 4, "channels must be 1, 2, or 4")

        var bytes = [T](repeating: initial, count: texture.width * texture.height * featureChannels)
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        
        texture.getBytes(&bytes, bytesPerRow: texture.width * featureChannels * MemoryLayout<T>.stride,
                 from: region, mipmapLevel: 0)
        
        return bytes
    }
}
