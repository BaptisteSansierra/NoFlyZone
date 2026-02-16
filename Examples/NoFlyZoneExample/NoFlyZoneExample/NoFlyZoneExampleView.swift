//
//  NoFlyZoneExampleView.swift
//  NoFlyZoneExample
//
//  Created by baptiste sansierra on 16/2/26.
//

import SwiftUI

struct NoFlyZoneExampleView: View {
    var body: some View {
        TabView {
            Tab("Ex1", systemImage: "appwindow.swipe.rectangle") {
                SwipeToDeleteView()
            }
            Tab("Ex2", systemImage: "shippingbox") {
                ForcedActionView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    NoFlyZoneExampleView()
}
