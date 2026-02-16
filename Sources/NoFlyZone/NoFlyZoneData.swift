//
//  File.swift
//  NoFlyZone
//
//  Created by baptiste sansierra on 9/2/26.
//

import Foundation

public struct NoFlyZoneData: Equatable, Sendable {
    
    public let viewId: Int
    public let itemId: Int
    public let zone: CGRect
    
    public init(viewId: Int, itemId: Int, zone: CGRect) {
        self.viewId = viewId
        self.itemId = itemId
        self.zone = zone
    }
    
    public init(itemId: Int, zone: CGRect) {
        self.viewId = 0
        self.itemId = itemId
        self.zone = zone
    }
}
