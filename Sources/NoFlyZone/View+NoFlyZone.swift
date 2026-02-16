//
//  File.swift
//  NoFlyZone
//
//  Created by baptiste sansierra on 7/2/26.
//

import SwiftUI

public extension View {

    func noFlyZone(enabled: Bool,
                   authorizedZones: [NoFlyZoneData],
                   onAllowed: @escaping ([NoFlyZoneData]) -> Void,
                   onBlocked: @escaping () -> Void,
                   coloredDebugOverlay: Bool = false) -> some View {
        modifier(NoFlyZoneModifier(enabled: enabled,
                                   authorizedZones: authorizedZones,
                                   onAllowed: onAllowed,
                                   onBlocked: onBlocked,
                                   coloredDebugOverlay: coloredDebugOverlay))
    }
}
