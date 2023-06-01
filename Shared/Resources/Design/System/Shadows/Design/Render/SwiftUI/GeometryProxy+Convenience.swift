import SwiftUI

public extension GeometryProxy {
    
    var width: CGFloat {
        size.width
    }
    
    func widthScaled<T: UINumericType>(_ scale: T) -> CGFloat {
        width * scale.asCGFloat
    }
    
    var height: CGFloat {
        size.height
    }
    
    func heightScaled<T: UINumericType>(_ scale: T) -> CGFloat {
        height * scale.asCGFloat
    }
    
    var localFrame: CGRect {
        frame(in: .local)
    }
    
    var localOrigin: CGPoint {
        localFrame.origin
    }
    
    var localMinX: CGFloat {
        localFrame.minX
    }
    
    var localMinY: CGFloat {
        localFrame.minY
    }
    
    var localMidX: CGFloat {
        localFrame.midX
    }
    
    var localMidY: CGFloat {
        localFrame.midY
    }
    
    var localMaxX: CGFloat {
        localFrame.maxX
    }
    
    var localMaxY: CGFloat {
        localFrame.maxY
    }
    
    var localCenter: CGPoint {
        localFrame.center
    }
    
    var globalFrame: CGRect {
        frame(in: .global)
    }
    
    var globalOrigin: CGPoint {
        globalFrame.origin
    }
    
    var globalMinX: CGFloat {
        globalFrame.minX
    }
    
    var globalMinY: CGFloat {
        globalFrame.minY
    }
    
    var globalMidX: CGFloat {
        globalFrame.midX
    }
    
    var globalMidY: CGFloat {
        globalFrame.midY
    }
    
    var globalMaxX: CGFloat {
        globalFrame.maxX
    }
    
    var globalMaxY: CGFloat {
        globalFrame.maxY
    }
    
    var globalCenter: CGPoint {
        globalFrame.center
    }
}
