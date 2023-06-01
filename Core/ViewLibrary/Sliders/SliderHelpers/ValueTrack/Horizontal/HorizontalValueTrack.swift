import SwiftUI

public typealias HorizontalTrack = HorizontalValueTrack

public struct HorizontalValueTrack<ValueView: View, MaskView: View>: View {
    @Environment(\.trackValue) var value
    @Environment(\.valueTrackConfiguration) var configuration
    let view: ValueView
    let mask: MaskView
    
    public var body: some View {
        GeometryReader { geometry in
            self.view.accentColor(.accentColor)
                .mask(
                    ZStack {
                        self.mask
                            .frame(
                                width: distanceFrom(
                                    value: self.value,
                                    availableDistance: geometry.size.width,
                                    bounds: self.configuration.bounds,
                                    leadingOffset: self.configuration.leadingOffset,
                                    trailingOffset: self.configuration.trailingOffset
                                )
                            )
                    }
                    .frame(width: geometry.size.width, alignment: .leading)
                )
        }
    }
}

extension HorizontalValueTrack {
    public init(@ViewBuilder view: () -> ValueView, @ViewBuilder mask: () -> MaskView) {
        self.view = view()
        self.mask = mask()
    }
}

extension HorizontalValueTrack where ValueView == DefaultHorizontalValueView {
    public init(mask: MaskView) {
        self.init(view: DefaultHorizontalValueView(), mask: mask)
    }
}

extension HorizontalValueTrack where MaskView == Capsule {
    public init(view: ValueView) {
        self.init(view: view, mask: Capsule())
    }
}

extension HorizontalValueTrack where ValueView == DefaultHorizontalValueView, MaskView == Capsule {
    public init() {
        self.init(view: DefaultHorizontalValueView(), mask: Capsule())
    }
}
