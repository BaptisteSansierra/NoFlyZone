// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct NoFlyZoneModifier: ViewModifier {

    var enabled: Bool
    var authorizedZones: [NoFlyZoneData]
    var onAllowed: ([NoFlyZoneData]) -> Void
    var onBlocked: () -> Void
    var color: Color
    var coloredDebugOverlay: Bool

    // MARK: - init
    public init(enabled: Bool,
                authorizedZones: [NoFlyZoneData],
                onAllowed: @escaping ([NoFlyZoneData]) -> Void,
                onBlocked: @escaping () -> Void,
                coloredDebugOverlay: Bool = false) {
        self.enabled = enabled
        self.authorizedZones = authorizedZones
        self.onAllowed = onAllowed
        self.onBlocked = onBlocked
        self.coloredDebugOverlay = coloredDebugOverlay
        if coloredDebugOverlay {
            color = enabled ? .red.opacity(0.3) : .clear
        } else {
            color = .clear
        }
    }

    // MARK: - body
    public func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
            GeometryReader { geo in
                overlayView(geo)
                if coloredDebugOverlay && enabled {
                    ForEach(authorizedZones.indices, id: \.self) { idx in
                        allowedZoneView(idx)
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    private func overlayView(_ geo: GeometryProxy) -> some View {
        color
            .contentShape(Rectangle())
            .allowsHitTesting(enabled)
            .ignoresSafeArea()
            .gesture( DragGesture()
                .onEnded({ _ in onBlocked() })
            )
            .onTapGesture { onTapGesture($0, worldOrigin: geo.frame(in: .global).origin) }
    }
    
    private func allowedZoneView(_ idx: Int) -> some View {
        Rectangle()
            .stroke(.green, style: StrokeStyle(lineWidth: 4))
            .fill(.green)
            .opacity(0.5)
            .frame(width: authorizedZones[idx].zone.width,
                   height: authorizedZones[idx].zone.height)
            .offset(x: authorizedZones[idx].zone.origin.x,
                    y: authorizedZones[idx].zone.origin.y)
            .ignoresSafeArea()
    }
    
    // MARK: - private methods
    private func onTapGesture(_ localPoint: CGPoint, worldOrigin: CGPoint) {
        guard authorizedZones.count > 0 else {
            onBlocked()
            return
        }
        // Convert local tap location to global coordinates
        let worldPoint = CGPoint(x: worldOrigin.x + localPoint.x,
                                 y: worldOrigin.y + localPoint.y)
        
        let intersectedAuthorizedZones = intersect(worldPoint)
        guard intersectedAuthorizedZones.count > 0 else {
            onBlocked()
            return
            
        }
        onAllowed(intersectedAuthorizedZones)
    }

    private func intersect(_ point: CGPoint) -> [NoFlyZoneData] {
        var intersected = [NoFlyZoneData]()
        for idx in 0..<authorizedZones.count {
            if authorizedZones[idx].zone.contains(point) {
                intersected.append(authorizedZones[idx])
            }
        }
        return intersected
    }
}
