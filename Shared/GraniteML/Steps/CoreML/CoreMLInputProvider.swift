import Foundation
import CoreML

class CoreMLInputProvider: MLFeatureProvider {
    
    let inputs: [String: AnyObject]
    
    var featureNames: Set<String> {
        get {
            return Set(inputs.keys)
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        guard let input = inputs[featureName] else {
            return nil
        }
        
        if let input = input as? MLMultiArray {
            return MLFeatureValue(multiArray: input)
        }
        else if CFGetTypeID(input as CFTypeRef) == CVPixelBufferGetTypeID() {
            return MLFeatureValue.init(pixelBuffer: input as! CVPixelBuffer)
        }
        
        return nil
    }
    
    init(inputs: [String : AnyObject]) {
        self.inputs = inputs
    }
}
