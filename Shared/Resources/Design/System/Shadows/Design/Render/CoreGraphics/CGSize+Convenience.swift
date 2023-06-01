import CoreGraphics
import SwiftUI

public extension CGSize {
    
    init(_ size: CGFloat) {
        self.init(size, size)
    }
    
    init<T: UINumericType>(_ size: T) {
        self.init(size, size)
    }
    
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
    
    init<TW: UINumericType, TH: UINumericType>(_ width: TW, _ height: TH) {
        self.init(width: width.asCGFloat, height: height.asCGFloat)
    }

    var asCGRect: CGRect {
        CGRect(width, height)
    }
    
    var asCGPoint: CGPoint {
        CGPoint(x: width, y: height)
    }

    var asCGVector: CGVector {
        CGVector(dx: width, dy: height)
    }
    
    var asUnitPoint: UnitPoint {
        UnitPoint(width, height)
    }
    
    var x: CGFloat {
        width
    }
    
    var y: CGFloat {
        height
    }
    
    var midX: CGFloat {
        width * 0.5
    }
    
    var midY: CGFloat {
        height * 0.5
    }
    
    var halfWidth: CGFloat {
        midX
    }
 
    var halfHeight: CGFloat {
        midY
    }
    
    var minDimension: CGFloat {
        min(width, height)
    }

    var maxDimension: CGFloat {
        max(width, height)
    }
    
    func scaled<T: UINumericType>(_ scale: T) -> CGSize {
        scaled(.square(scale))
    }
    
    func scaled(_ scale: CGSize) -> CGSize {
        scaled(scale.width, scale.height)
    }
    
    func scaled<TW: UINumericType, TH: UINumericType>(_ widthScale: TW, _ heightScale: TH) -> CGSize {
        .init(widthScaled(widthScale), heightScaled(heightScale))
    }
    
    func widthScaled<T: UINumericType>(_ scale: T) -> CGFloat {
        width * scale.asCGFloat
    }
    
    func heightScaled<T: UINumericType>(_ scale: T) -> CGFloat {
        height * scale.asCGFloat
    }
    
    func clamped(from: CGFloat, to: CGFloat) -> CGSize {
        .init(self.width.clamped(from: from, to: to), self.height.clamped(from: from, to: to))
    }
}

// MARK: -- OPERATOR OVERLOADS

public extension CGSize {
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        .init(lhs.width - rhs.width, lhs.height - rhs.height)
    }
    
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        .init(lhs.width + rhs.width, lhs.height + rhs.height)
    }
}

// MARK: -- STATIC INITIALISERS

public extension CGSize {
    
    static func square<T: UINumericType>(_ size: T) -> CGSize {
        .init(size.asCGFloat)
    }
    
    static func width<T: UINumericType>(_ width: T) -> CGSize {
        .init(width, 0)
    }
    
    static func height<T: UINumericType>(_ height: T) -> CGSize {
        .init(0, height)
    }
    
    static func size<TW: UINumericType, TH: UINumericType>(_ width: TW, _ height: TH) -> CGSize {
        .init(width, height)
    }
    
    static func size<T: UINumericType>(_ size: T) -> CGSize {
        .square(size)
    }
}

// MARK: -- MAP FROM ONE RECT TO ANOTHER

public extension CGSize {
    
    func map(from: CGRect, to: CGRect) -> CGSize {
        let relativeOffsetWidth = from.width == 0 ? width : width / from.width
        let relativeOffsetHeight = from.height == 0 ? height : height / from.height
        
        return CGSize(relativeOffsetWidth * to.width, relativeOffsetHeight * to.height)
    }
}
