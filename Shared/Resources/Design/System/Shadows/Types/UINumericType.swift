import CoreGraphics

public protocol UINumericType: RepresentableAsCGFloat, RepresentableAsInt, RepresentableAsDouble, RepresentableAsFloat {
    
    var isPositive: Bool {get}
    var isNegative: Bool {get}
    
}

extension Int: UINumericType {}
extension Float: UINumericType {}
extension Double: UINumericType {}
extension CGFloat: UINumericType {}

