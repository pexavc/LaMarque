//
//  FeatureExtraction.swift
//
//
//  Created by 0xKala on 2/26/21.
//

import CoreML
import Foundation

open class Features {
    typealias MLFeature = [MLFeatureType : Features.Context.Constraints]
    
    public struct Context {
        let inputs: MLFeature
        let outputs: MLFeature
        
        public init(_ url: URL?) {
            do {
                if let url = url {
                    let model = try MLModel(contentsOf: URL(fileURLWithPath: url.path))
                    self.inputs = Features.extractFrom(model)
                    self.outputs = Features.extractFrom(model, output: true)
                } else {
                    self.inputs = [:]
                    self.outputs = [:]
                }
            } catch {
                self.inputs = [:]
                self.outputs = [:]
            }
        }
        
        struct Constraints {
            let image: MLImageConstraint?
            let dictionary: MLDictionaryConstraint?
            let sequence: MLSequenceConstraint?
            let multiArray: MLMultiArrayConstraint?
            
            var imageConstraintSize: CGSize {
                .init(
                    width: CGFloat(
                        image?.pixelsWide ?? 0),
                    height: CGFloat(
                        image?.pixelsHigh ?? 0))
            }
        }
        
        var inputIsImage: Bool {
            inputs.keys.contains(.image)
        }
        
        public var inputSize: CGSize {
            inputs.values.first(
                where: {$0.image != nil})?.imageConstraintSize ?? .zero
        }
    }
    
    static func extractFrom(
        _ model: MLModel,
        output: Bool = false) -> MLFeature {
        
        var outputs: MLFeature = [:]
        let descriptions = output ? model.modelDescription.outputDescriptionsByName : model.modelDescription.inputDescriptionsByName
        
        for (_, description) in descriptions {
            
            switch description.type {
            case .string:
                outputs[description.type] = Features.Context.Constraints(
                    image: nil,
                    dictionary: nil,
                    sequence: nil,
                    multiArray: nil)
            case .dictionary:
                outputs[description.type] = Features.Context.Constraints(
                    image: nil,
                    dictionary: description.dictionaryConstraint,
                    sequence: nil,
                    multiArray: nil)
            case .multiArray:
                outputs[description.type] = Features.Context.Constraints(
                    image: nil,
                    dictionary: nil,
                    sequence: nil,
                    multiArray: description.multiArrayConstraint)
            case .image:
                outputs[description.type] = Features.Context.Constraints(
                    image: description.imageConstraint,
                    dictionary: nil,
                    sequence: nil,
                    multiArray: nil)
            default:
                break
            }
        }
        
        return outputs
    }
}

