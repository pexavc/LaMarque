import Foundation
import Metal
import CoreML
import Accelerate

public enum CoreMLInput {
    case multiArray(MLMultiArray)
    case buffer(CVPixelBuffer)
    case texture(MTLTexture)
}

public enum CoreMLInputType {
    case buffer
    case multiarray
    case texture
}

public class CoreML: GraniteStep {
    public typealias Input = CoreMLInput
    public typealias Output = [String: Any]
 
    fileprivate var model: MLModel? = nil
    fileprivate weak var scene: GraniteScene?
    
    fileprivate var lastMultiArrayPointer: UnsafeMutableRawPointer?
    fileprivate var bytes: [Double] = [Double]()
    
    convenience public init(url : URL, type: CoreMLInputType) {
        self.init(path: url.path)
    }
    
    public init(path : String) {
        do { 
            if path.hasSuffix("mlmodelc") {
                self.model = try MLModel(contentsOf: URL(fileURLWithPath: path))
            } else {
                let compiledModelUrl = try MLModel.compileModel(at: URL(fileURLWithPath: path))
                self.model = try MLModel(contentsOf: compiledModelUrl)
            }
        }
        catch {
            
        }
    }
    
    public func invalidate(context: GraniteScene) {
        self.scene = context
    }
    
    public func execute(input: CoreMLInput, state: GranitePipelineState) throws -> [String : Any]? {
        guard let model = model else {
            throw PipelineRuntimeError.genericError(self, "Unable to load specified CoreML model")
        }
        
        switch input {
        case .multiArray(_):
            state.insertCommandBufferExecutionBoundary()
        case .texture(let texture):
            state.synchronize(resource: texture)
            state.insertCommandBufferExecutionBoundary()
        case .buffer(_):
            break
        }
        
        var inputs = [String : AnyObject]()
        var outputs = [String : Any]()
    
        for (name, description) in model.modelDescription.inputDescriptionsByName {
            
            switch input {
            case .multiArray(let value):
                if description.type == .multiArray {
                    inputs[name] = value
                }
            case .texture(let texture):
                if description.type == .multiArray {
                    guard let constraint = description.multiArrayConstraint else {
                        continue
                    }
                    inputs[name] = createMultiArray(from: texture, constraint: constraint)
                } else if description.type == .image {
                    inputs[name] = createCVPixelBuffer(from: texture)
                }
            case .buffer(let value):
                if description.type == .image {
                    inputs[name] = value
                }
            }
        }
        
        guard let outputProvider = try? model.prediction(from: CoreMLInputProvider(inputs: inputs)) else {
            throw PipelineRuntimeError.genericError(self, "Unable to run CoreML model")
        }
        
        for (name, _) in model.modelDescription.outputDescriptionsByName {
            guard let feature = outputProvider.featureValue(for: name) else{
                continue
            }
            
            switch feature.type {
            case .string:
                outputs[name] = feature.stringValue
            case .dictionary:
                outputs[name] = feature.dictionaryValue
            case .multiArray:
                outputs[name] = feature.multiArrayValue
            case .image:
                outputs[name] = feature.imageBufferValue
            default:
                break
            }
        }
        
        return outputs
    }
    
}

extension CoreML {
    fileprivate func createMultiArray(from input : MTLTexture, constraint : MLMultiArrayConstraint) -> MLMultiArray? {
        let channelsCount = 4
        
        if input.pixelFormat == .rgba8Unorm {
            let pixels = input.toUInt8Array(width: input.width, height: input.height, featureChannels: channelsCount)
            bytes = [Double](repeating: 0, count: pixels.count)
            vDSP_vfltu8D(pixels, 1, &bytes, 1, vDSP_Length(pixels.count))
            
            lastMultiArrayPointer = UnsafeMutableRawPointer(mutating: bytes)!
        }
        else if input.pixelFormat == .rgba32Float {
            let pixels = input.toFloatArray(width: input.width, height: input.height, featureChannels: channelsCount)
            bytes = [Double](repeating: 0, count: pixels.count)
            
            vDSP_vspdp(pixels, 1, &bytes, 1, vDSP_Length(pixels.count))
            
            lastMultiArrayPointer = UnsafeMutableRawPointer(mutating: bytes)!
        }
        
        return try? MLMultiArray(dataPointer: lastMultiArrayPointer!,
                                 shape: constraint.shape,
                                 dataType: constraint.dataType,
                                 strides: [1,
                                           NSNumber(value: channelsCount*Int(truncating: (constraint.shape[1]))),
                                           NSNumber(value: channelsCount)])
    }
    
    fileprivate func createCVPixelBuffer(from input : MTLTexture) -> CVPixelBuffer? {
        var sourceBuffer : CVPixelBuffer?
        
        let attrs = NSMutableDictionary()
        attrs[kCVPixelBufferIOSurfacePropertiesKey] = NSMutableDictionary()
        
        CVPixelBufferCreate(kCFAllocatorDefault,
                            input.width,
                            input.height,
                            kCVPixelFormatType_32BGRA,
                            attrs as CFDictionary,
                            &sourceBuffer)
        
        guard let buffer = sourceBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let bufferPointer = CVPixelBufferGetBaseAddress(buffer)!
        
        let region = MTLRegionMake2D(0, 0, input.width, input.height)
        input.getBytes(bufferPointer, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), from: region, mipmapLevel: 0)
        
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return buffer
    }
    
}
