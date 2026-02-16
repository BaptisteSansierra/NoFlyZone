//
//  File.swift
//  NoFlyZone
//
//  Created by baptiste sansierra on 16/2/26.
//

import SwiftUI

struct NoFlyZoneView<Content>: View where Content: View {
    
    // NoFlyZone
    @State private var noFlyZoneEnabled: Bool = false
    @State private var noFlyAuthorizedZones: [NoFlyZoneData] = []
    @State private var noFlyZoneCompletionStatus: NoFlyZoneCompletionStatus = .undefined

    // MARK: - private properties
    private var content: Content
    
    // MARK: - init
    init(content: Content) {
        self.content = content
    }
    
    // MARK: - body
    var body: some View {
        content
            .noFlyZone(enabled: noFlyZoneEnabled,
                       authorizedZones: noFlyAuthorizedZones,
                       onAllowed: noFlyZoneOnAllowed,
                       onBlocked: noFlyZoneOnBlocked)
    }

    // MARK: - private methods
    private func noFlyZoneOnBlocked() {
        noFlyZoneEnabled = false
        noFlyZoneCompletionStatus = .blocked
    }
    
    private func noFlyZoneOnAllowed(tappedZones: [NoFlyZoneData]) {
        noFlyZoneEnabled = false
        noFlyZoneCompletionStatus = .allowed
    }

}
