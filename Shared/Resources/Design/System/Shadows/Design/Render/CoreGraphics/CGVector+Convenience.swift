import Foundation
import SwiftUI

public extension CGVector {
    
    init(_ size: CGFloat) {
        self.init(size, size)
    }
    
    init<T: UINumericType>(_ size: T) {
        self.init(size.asCGFloat)
    }
    
    init(_ dx: CGFloat, _ dy: CGFloat) {
        self.init(dx: dx, dy: dy)
    }

    init<TX: UINumericType, TY: UINumericType>(_ dx: TX, _ dy: TY) {
        self.init(dx: dx.asCGFloat, dy: dy.asCGFloat)
    }

    var asCGRect: CGRect {
        CGRect(dx, dy)
    }
    
    var asCGPoint: CGPoint {
        CGPoint(x: dx, y: dy)
    }

    var asCGSize: CGSize {
        CGSize(dx, dy)
    }
    
    var asUnitPoint: UnitPoint {
        UnitPoint(dx, dy)
    }
    
    var width: CGFloat {
        dx
    }

    var height: CGFloat {
        dy
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
        min(dx, dy)
    }

    var maxDimension: CGFloat {
        max(dx, dy)
    }
    
    func scaled<T: UINumericType>(_ scale: T) -> CGSize {
        scaled(.square(scale))
    }
    
    func scaled(_ scale: CGSize) -> CGSize {
        .init(widthScaled(scale.width), heightScaled(scale.height))
    }

    func widthScaled<T: UINumericType>(_ scale: T) -> CGFloat {
        dx * scale.asCGFloat
    }

    func heightScaled<T: UINumericType>(_ scale: T) -> CGFloat {
        dy * scale.asCGFloat
    }

    func clamped(from: CGFloat, to: CGFloat) -> CGVector {
        .init(dx.clamped(from: from, to: to), dy.clamped(from: from, to: to))
    }
}

// MARK: -- STATIC INITIALISERS

public extension CGVector {
    
    static func dx<T: UINumericType>(_ dx: T) -> CGVector {
        .init(dx, 0)
    }
    
    static func dy<T: UINumericType>(_ dy: T) -> CGVector {
        .init(0, dy)
    }
    
    static func vector<TDX: UINumericType, TDY: UINumericType>(_ dx: TDX, _ dy: TDY) -> CGVector {
        .init(dx, dy)
    }
    
    static func vector<T: UINumericType>(_ size: T) -> CGVector {
        .init(size)
    }
}

// MARK: -- OPERATOR OVERLOADS

public extension CGVector {
    
    static func -(lhs: CGVector, rhs: CGVector) -> CGVector {
        .init(lhs.dx - rhs.dx, lhs.dy - rhs.dy)
    }

    static func +(lhs: CGVector, rhs: CGVector) -> CGVector {
        .init(lhs.dx + rhs.dx, lhs.dy + rhs.dy)
    }
}
