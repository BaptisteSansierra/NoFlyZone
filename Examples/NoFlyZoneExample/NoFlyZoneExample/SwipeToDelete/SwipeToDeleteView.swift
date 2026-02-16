//
//  SwipeToDeleteView.swift
//  NoFlyZone
//
//  Created by baptiste sansierra on 7/2/26.
//

import SwiftUI
import NoFlyZone


struct SwipeToDeleteView: View {
    
    @State private var displayNoFlyZone: Bool = false
    @State private var displayNoFlyZoneDebug: Bool = true
    @State private var noFlyAuthorizedZones: [NoFlyZoneData] = []

    @State private var items1 = [
        "Brandon",
        "Brenda",
        "Pamela",
        "Zach",
        "Kevin",
        "Kelly"
    ]
    @State private var items2 = [
        "Dylan",
        "Donna",
        "Brenda",
        "Zach",
        "Kelly"
    ]
    
    var body: some View {
        List {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .frame(height: 60)
                Toggle("No fly zone visible", isOn: $displayNoFlyZoneDebug)
                    .padding()
            }
            .padding()
            Text("Swipe to delete any row")

            SwipeToDeleteChildView(tag: 1,
                                   displayNoFlyZone: $displayNoFlyZone,
                                   noFlyAuthorizedZones: $noFlyAuthorizedZones,
                                   items: $items1)
            SwipeToDeleteChildView(tag: 2,
                                   displayNoFlyZone: $displayNoFlyZone,
                                   noFlyAuthorizedZones: $noFlyAuthorizedZones,
                                   items: $items2)
        }
        .noFlyZone(
            enabled: displayNoFlyZone,
            authorizedZones: noFlyAuthorizedZones,
            onAllowed: { intersected in
                displayNoFlyZone = false

                for inter in intersected {
                    if inter.viewId == 1 {
                        _ = withAnimation {
                            items1.remove(at: inter.itemId)
                        }
                    } else if inter.viewId == 2 {
                        _ = withAnimation {
                            items2.remove(at: inter.itemId)
                        }
                    }
                }
            },
            onBlocked: {
                displayNoFlyZone = false
            },
            coloredDebugOverlay: displayNoFlyZoneDebug
        )
    }
}

#Preview {
    SwipeToDeleteView()
}
