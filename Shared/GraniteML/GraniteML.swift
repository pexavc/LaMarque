//
//  GraniteML.swift
//
//
//  Created by 0xKala on 2/26/21.
//

import Foundation
import SwiftUI
import GraniteUI

public class GraniteML<T> {
    public typealias Output = T
    
    public struct Pipelines {
        let imageIO: GranitePipeline<MTLTexture>
        let imageScaleableIO: GranitePipeline<MTLTexture>
        
        let textureScaleableIO: GranitePipeline<MTLTexture>
        
        let modelIO: GranitePipeline<CoreML.Output>?
    }
    
    public struct Options {
        let ignoreImageIO: Bool = false
    }
    
    public struct PredictionState {
        public var inputImage: Any? = nil
        public var inputTexture: MTLTexture? = nil
        public var scaled: MTLTexture? = nil
    }
    
    public let features: Features.Context
    public let modelUrl: URL?
    public var pipeline: Pipelines?
    public var lastPrediction: PredictionState
    
    private let inputType: CoreMLInputType
    
    public init(
        _ model: Any, input: CoreMLInputType = .texture) {
        
        let bundle = Bundle(for: GraniteML.self)
        modelUrl = bundle.url(forResource: identify(model), withExtension: "mlmodelc")
        features = .init(modelUrl)
        lastPrediction = .init()
        inputType = input
        pipeline = .init(
            imageIO: MetalAssistant.ImageToTexturePipeline(),
            imageScaleableIO: MetalAssistant.ImageToTexturePipelineScaleable(features.inputSize),
            textureScaleableIO: MetalAssistant.TextureScalePipeline(features.inputSize, mode: .stretch),
            modelIO: ModelPipeline(input))
    }
}

extension GraniteML {
    public func predict(
        _ input: Any,
        options: GraniteML.Options? = nil) -> Output? {
        guard let pipeline = self.pipeline else {
            return nil
        }
        
        guard let inputType = features.inputs.keys.first else {
            return nil
        }
        
        if inputType == .image {
            return predictForImageInput(
                pipeline,
                on: input,
                options: options ?? .init())
        } else {
            return nil
        }
    }
    
    public func predictForImageInput(
        _ pipeline: Pipelines,
        on input: Any,
        options: GraniteML.Options? = nil) -> Output? {
        
        switch inputType {
        case .buffer:
            guard let modelOutput = try? pipeline.modelIO?.run(
                    on: CoreMLInput.buffer(input as! CVPixelBuffer)) else {
                return nil
            }
            return modelOutput.values.compactMap({ $0 as? Output }).first
        default:
            //TODO: refactor
            var texture: MTLTexture? = nil
            var mlImage: Any? = nil
            
            if options?.ignoreImageIO == false || options == nil {
                if CFGetTypeID(input as CFTypeRef) == CVPixelBufferGetTypeID() {
                    mlImage = input as! CVPixelBuffer
                    
                    
                } else if let image = input as? GraniteImage {
                    mlImage = image
                } /* else if let image = input as? UIImage {
                 mlImage = image
                 } */ else if let metalTexture = input as? MTLTexture {
                    texture = metalTexture
                 } else {
                    return nil
                 }
            }
            
            lastPrediction.inputImage = mlImage
            lastPrediction.inputTexture = texture
            
            if texture == nil, let mlImage = mlImage {
                if features.inputSize == .zero {
                    texture = try? pipeline.imageIO.run(on: mlImage)
                } else {
                    texture = try? pipeline.imageScaleableIO.run(on: mlImage)
                }
            } else if let textureToMod = texture {
                let size = (textureToMod.width) * (textureToMod.height)
                let inputSize = Int(features.inputSize.width) * Int(features.inputSize.height)
                
                if size != inputSize {
                    texture = try? pipeline.textureScaleableIO.run(on: textureToMod)
                }
            }
            
            lastPrediction.scaled = texture
            
            guard let preparedTexture = texture else {
                return nil
            }
            
            guard let modelOutput = try? pipeline.modelIO?.run(
                    on: CoreMLInput.texture(preparedTexture)) else {
                return nil
            }
            
    //        var found: Any
    //        for inputValue in modelOutput.values {
    //            if CFGetTypeID(inputValue as CFTypeRef) == CVPixelBufferGetTypeID() {
    //                found = true
    //                return inputValue as? Output
    //            }else {
    //                found = inputValue
    //            }
    //        }
            
            return modelOutput.values.compactMap({ $0 as? Output }).first//inputValue as? Output
        }
    }
}

//MARK: Pipeline Creation
extension GraniteML {
    func ImageToTexturePipelineScaleable(
        _ scale: CGSize,
        format: MTLPixelFormat = .bgra8Unorm,
        makeTextureView: Bool = true,
        mode: ScaleTexture.ScaleMode = .stretch)
    -> GranitePipeline<ScaleTexture.Output> {
        
        return PassthroughPipe()
            .add(ImageToTexture(
                format: format,
                makeTextureView: makeTextureView))
            .add(ScaleTexture(
                width: Int(scale.width),
                height: Int(scale.height),
                mode: mode))
    }
    
    func ImageToTexturePipeline(
        format: MTLPixelFormat = .bgra8Unorm,
        makeTextureView: Bool = true) -> GranitePipeline<ImageToTexture.Output> {
        return PassthroughPipe()
            .add(ImageToTexture(
                format: format,
                makeTextureView: makeTextureView))
    }
}
extension GraniteML {
    func ModelPipeline(_ inputType: CoreMLInputType) -> GranitePipeline<CoreML.Output>? {
        guard let coreMLModel = self.modelUrl else {
            return nil
        }
        
        return PassthroughPipe().add(CoreML(url: coreMLModel, type: inputType))
    }
}
