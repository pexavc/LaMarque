import CoreGraphics
import SwiftUI


public let granite_defaultInnerShadowColor = Color(white: 0.56)

private func convertIntensityToColor<T: UINumericType>(_ intensity: T) -> Color {
    return Color(white: 1 - intensity.asDouble.clamped(to: 1, spanZero: false))
}

public struct granite_InnerShadowConfig {
    
    let radius: CGFloat
    let offsetLength: CGFloat!
    let offset: CGPoint!
    let angle: Angle!
    let color: Color!
    
    private init<TR: UINumericType>(radiusInternal: TR, offsetLength: CGFloat? = nil, offset: CGPoint? = nil, angle: Angle? = nil, color: Color = granite_defaultInnerShadowColor) {
        self.radius = radiusInternal.asCGFloat
        self.offsetLength = offsetLength
        self.offset = offset
        self.angle = angle
        self.color = color
    }
    
    public init<TR: UINumericType, TO: UINumericType>(radius: TR, offsetLength: TO, angle: Angle, color: Color = granite_defaultInnerShadowColor) {
        self.init(radiusInternal: radius, offsetLength: offsetLength.asCGFloat, angle: angle, color: color)
    }
    
    public init<TR: UINumericType, TO: UINumericType, TI: UINumericType>(radius: TR, offsetLength: TO, angle: Angle, intensity: TI) {
        self.init(radius: radius, offsetLength: offsetLength, angle: angle, color: convertIntensityToColor(intensity))
    }

    public init<TR: UINumericType>(radius: TR, offset: CGPoint, color: Color = granite_defaultInnerShadowColor) {
        self.init(radiusInternal: radius, offset: offset, color: color)
    }
    
    public init<TR: UINumericType, TI: UINumericType>(radius: TR, offset: CGPoint, intensity: TI) {
        self.init(radius: radius, offset: offset, color: convertIntensityToColor(intensity))
    }
    
    public init<TR: UINumericType>(radius: TR, color: Color = granite_defaultInnerShadowColor) {
        self.init(radiusInternal: radius, offset: .zero, color: color)
    }
    
    public init<TR: UINumericType, TI: UINumericType>(radius: TR, intensity: TI) {
        self.init(radius: radius, offset: .zero, intensity: intensity)
    }
    
    var hasAngle: Bool {
        angle != nil
    }
}

public extension granite_InnerShadowConfig {
    
    static func config<TR: UINumericType, TI: UINumericType>(radius: TR, intensity: TI) -> granite_InnerShadowConfig {
        config(radius: radius, offset: .zero, intensity: intensity)
    }
    
    static func config<TR: UINumericType>(radius: TR, color: Color = granite_defaultInnerShadowColor) -> granite_InnerShadowConfig {
        config(radius: radius, offset: .zero, color: color)
    }
    
    static func config<TR: UINumericType, TO: UINumericType, TI: UINumericType>(radius: TR, offset: TO, angle: Angle, intensity: TI) -> granite_InnerShadowConfig {
        config(radius: radius, offset: offset, angle: angle, color: convertIntensityToColor(intensity))
    }
    
    static func config<TR: UINumericType, TO: UINumericType>(radius: TR, offset: TO, angle: Angle, color: Color = granite_defaultInnerShadowColor) -> granite_InnerShadowConfig {
        granite_InnerShadowConfig(radius: radius, offsetLength: offset, angle: angle, color: color)
    }

    static func config<TR: UINumericType, TI: UINumericType>(radius: TR, offset: CGPoint, intensity: TI) -> granite_InnerShadowConfig {
        config(radius: radius, offset: offset, color: convertIntensityToColor(intensity))
    }
    
    static func config<TR: UINumericType>(radius: TR, offset: CGPoint, color: Color = granite_defaultInnerShadowColor) -> granite_InnerShadowConfig {
        granite_InnerShadowConfig(radius: radius, offset: offset, color: color)
    }
}

public struct FillAndContent<V: View> {
    let fillStyle: FillStyle
    let content: V?
    
    public init(_ fillStyle: FillStyle, _ content: V?) {
        self.fillStyle = fillStyle
        self.content = content
    }
}

public extension FillAndContent {
    
    static var fill: FillAndContent<Color> {
        fill(Color.clear)
    }
    
    static func fill(eoFill: Bool = false, antialiased: Bool = true) -> FillAndContent<Color> {
        fill(Color.clear, eoFill: eoFill, antialiased: antialiased)
    }
    
    static func fill<V: View>(_ content: V, eoFill: Bool = false, antialiased: Bool = true) -> FillAndContent<V> {
        FillAndContent<V>(FillStyle(eoFill: eoFill, antialiased: antialiased), content)
    }
}

public struct StrokeAndContent<V: View> {
    let style: StrokeStyle
    let fillAndContent: FillAndContent<V>
    
    public init(_ style: StrokeStyle, _ fillAndContent: FillAndContent<V>) {
        self.style = style
        self.fillAndContent = fillAndContent
    }
}

public extension StrokeAndContent {
    static func stroke<T: UINumericType>(lineWidth: T) -> StrokeAndContent<Color> {
        stroke(Color.clear, lineWidth: lineWidth)
    }
    
    static func stroke<V: View, T: UINumericType>(_ content: V, lineWidth: T) -> StrokeAndContent<V> {
        StrokeAndContent<V>(StrokeStyle(lineWidth: lineWidth.asCGFloat), .fill(content))
    }
    
    static func stroke(style: StrokeStyle) -> StrokeAndContent<Color> {
        stroke(Color.clear, style: style)
    }
    
    static func stroke<V: View>(_ content: V, style: StrokeStyle) -> StrokeAndContent<V> {
        StrokeAndContent<V>(style, .fill(content))
    }
}

public struct ShapeAndContent<S: Shape, V: View> {
    let shape: S
    let content: V?
    
    public init(_ shape: S, _ content: V? = nil) {
        self.shape = shape
        self.content = content
    }
}

public extension ShapeAndContent {
    
    static var circle: ShapeAndContent<Circle, Color> {
        circle(Color.clear)
    }
    
    static func circle<V: View>(_ content: V? = nil) -> ShapeAndContent<Circle, V> {
        ShapeAndContent<Circle, V>(Circle(), content)
    }
    
    static var ellipse: ShapeAndContent<Ellipse, Color> {
        ellipse(Color.clear)
    }
    
    static func ellipse<V: View>(_ content: V? = nil) -> ShapeAndContent<Ellipse, V> {
        ShapeAndContent<Ellipse, V>(Ellipse(), content)
    }
    
    static var capsule: ShapeAndContent<Capsule, Color> {
        capsule(Color.clear)
    }
    
    static func capsule<V: View>(_ content: V? = nil) -> ShapeAndContent<Capsule, V> {
        ShapeAndContent<Capsule, V>(Capsule(), content)
    }

    static var rectangle: ShapeAndContent<Rectangle, Color> {
        rectangle(Color.clear)
    }
    
    static func rectangle<V: View>(_ content: V? = nil) -> ShapeAndContent<Rectangle, V> {
        ShapeAndContent<Rectangle, V>(Rectangle(), content)
    }
    
    static func roundedRectangle<T: UINumericType>(_ cornerRadius: T) -> ShapeAndContent<RoundedRectangle, Color> {
        roundedRectangle(cornerRadius, Color.clear)
    }
    
    static func roundedRectangle<T: UINumericType, V: View>(_ cornerRadius: T, _ content: V? = nil) -> ShapeAndContent<RoundedRectangle, V> {
        ShapeAndContent<RoundedRectangle, V>(RoundedRectangle.init(cornerRadius: cornerRadius.asCGFloat), content)
    }
}
