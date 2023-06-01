////
////  GraniteScrollView.swift
////  
////
////  Created by PEXAVC on 1/7/21.
////

import Foundation
import SwiftUI

//
//  TrackableScrollView.swift
//  TrackableScrollView
//
//  Created by maxnatchanon on 26/12/2019 BE.
//  Copyright © 2019 maxnatchanon All rights reserved.
//

struct SliderBinding: View {
    @Binding var position: CGFloat
    @State var dragBegin: CGFloat?

    public init(_ contentOffset: Binding<CGFloat>) {
        self._position = contentOffset
    }
    var body: some View {
        VStack {
            Text("\(position)")
            Slider(value: $position, in: 0...400)
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .red]),
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: 800, height: 200)
                    .offset(x: position - 400 / 2)
            }
            .frame(width:400)
            .gesture(DragGesture()
                        .onChanged { gesture in
                            if (dragBegin == nil) {
                                dragBegin = self.position
                            } else {
                                position = (dragBegin ?? 0) + gesture.translation.width
                            }
                        }
                        .onEnded { _ in
                            dragBegin = nil
                        }
            )
        }
        .frame(width: 400)
    }
}

@available(iOS 13.0, *)
public struct TrackableScrollView<Content>: View where Content: View {
    let axes: Axis.Set
    let showIndicators: Bool
    @Binding var contentOffset: CGFloat
    let content: Content
    
    public init(_ axes: Axis.Set = .vertical, showIndicators: Bool = true, contentOffset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: [self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                    }
                    VStack {
                        self.content
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value[0]
            }
        }
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}

@available(iOS 13.0, *)
struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
//
//public struct GraniteScrollView<Content>: View where Content : View {
//    /// The content of the scroll view.
//    public var content: Content
//
//    /// The scrollable axes.
//    ///
//    /// The default is `.vertical`.
//    public var axes: Axis.Set
//
//    /// If true, the scroll view may indicate the scrollable component of
//    /// the content offset, in a way suitable for the platform.
//    ///
//    /// The default is `true`.
//    public var showsIndicators: Bool
//
//    /// The initial offset of the view as measured in the global frame
//    @State private var initialOffset: CGPoint?
//
//    /// The offset of the scroll view updated as the scroll view scrolls
//    @Binding public var preserveOffset: CGPoint
//    @Binding public var offset: CGPoint
//
//    public init(_ axes: Axis.Set = .vertical,
//                showsIndicators: Bool = true,
//                offset: Binding<CGPoint> = .constant(.zero),
//                preserveOffset: Binding<CGPoint> = .constant(.zero),
//                @ViewBuilder content: () -> Content) {
//        self.axes = axes
//        self.showsIndicators = showsIndicators
//        self._offset = offset
//        self._preserveOffset = preserveOffset
//        self.content = content()
//    }
//
//    public var body: some View {
//        ScrollView(axes, showsIndicators: showsIndicators) {
//            ScrollViewReader { sp in
//                VStack(alignment: .leading, spacing: 0) {
//                    GeometryReader { geometry in
//                        Run {
//                            let globalOrigin = geometry.frame(in: .global).origin
//                            self.initialOffset = self.initialOffset ?? globalOrigin
//                            let initialOffset = (self.initialOffset ?? .zero)
//                            let offset = CGPoint(x: globalOrigin.x - initialOffset.x, y: globalOrigin.y - initialOffset.y)
//                            self.$offset.wrappedValue = offset
//
//                            guard offset.x >= 0 && offset.y > 0 else { return }
//                            self.$preserveOffset.wrappedValue = CGPoint(x: globalOrigin.x - initialOffset.x, y: globalOrigin.y - initialOffset.y)
//    //                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: offset)
//                        }
//                    }.frame(width: 0, height: 0)
//
//                    content
//                }
//            }
//        }
//    }
//}
//
////public struct GraniteScrollView<Content>: View where Content : View {
////    @State public var offset: CGPoint = .zero
////
////    /// The content of the scroll view.
////    public var content: Content
////
////    public init(@ViewBuilder content: () -> Content) {
////        self.content = content()
////    }
////
////    public var body: some View {
////        GraniteScrollViewProxy(offset: $offset) {
////            content
////        }.environment(\.graniteScrollViewOffset, offset)
////    }
////}
////
////public struct GraniteScrollViewOffsetKey: EnvironmentKey {
////    public static let defaultValue = CGPoint.zero
////}
////
////public extension EnvironmentValues {
////    var graniteScrollViewOffset: CGPoint {
////        get {
////            return self[GraniteScrollViewOffsetKey.self]
////        }
////        set {
////            self[GraniteScrollViewOffsetKey.self] = newValue
////        }
////    }
////}
////
//////struct ScrollOffsetPreferenceKey: PreferenceKey {
//////    typealias Value = CGPoint
//////
//////    static var defaultValue: CGPoint = .zero
//////
//////    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
//////        value.append(contentsOf: nextValue())
//////    }
//////}
