//
//  SwipeToDeleteChildView.swift
//  NoFlyZone
//
//  Created by baptiste sansierra on 9/2/26.
//

import SwiftUI
import NoFlyZone

struct SwipeToDeleteChildView: View {
    
    // MARK: States & Bindings
    @State private var revealedItemIndex: String? = nil
    @State private var revealedIndex: Int? = nil
    @State private var deleteButtonFrame: CGRect = .zero
    @Binding private var displayNoFlyZone: Bool
    @Binding private var noFlyAuthorizedZones: [NoFlyZoneData]
    @Binding private var items: [String]

    // MARK: properties
    private var tag: Int

    // MARK: Init
    init(tag: Int,
         displayNoFlyZone: Binding<Bool>,
         noFlyAuthorizedZones: Binding<[NoFlyZoneData]>,
         items: Binding<[String]>) {
        self._displayNoFlyZone = displayNoFlyZone
        self._noFlyAuthorizedZones = noFlyAuthorizedZones
        self._items = items
        self.tag = tag
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .frame(height: CGFloat(items.count) * (60 + 5) + 5 + 5 )

            VStack(spacing: 5) {
                ForEach(items.indices, id: \.self) { index in
                    rowView(index)
                        .padding(.horizontal)
                        .overlay(content: { rowDragOverlayView(index) } )
                }
            }
        }
        .padding()
        .onChange(of: displayNoFlyZone) { _, newValue in
            guard newValue == false else { return }
            revealedItemIndex = nil
            deleteButtonFrame = .zero
            withAnimation {
                revealedIndex = nil
            }
        }
    }
    
    // MARK: subviews
    private func rowDragOverlayView(_ index: Int) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onChanged { value in
                        if value.translation.width < -50 {
                            revealedIndex = index
                            displayNoFlyZone = true
                            noFlyAuthorizedZones = [NoFlyZoneData(viewId: tag,
                                                                  itemId: index,
                                                                  zone: deleteButtonFrame)]
                        }

                    }
            )
            .allowsHitTesting(true) // keeps List scrolling alive
    }
    
    private func rowView(_ index: Int) -> some View {
        ZStack(alignment: .trailing) {
            // Delete button (hidden behind)
            Button(action: {
                //do nothing, deletion handled in parent
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: 80, height: 60)
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                }
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: revealedIndex, { _, _ in
                            if revealedIndex == index {
                                deleteButtonFrame = geo.frame(in: .global)
                            }
                        })
                }
            )
            
            // Row content
            HStack {
                Text(items[index])
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            }
            .background(Color.white)
            .frame(height: 60)
            .offset(x: revealedIndex == index ? -80 : 0)
            .animation(.easeInOut, value: revealedIndex)
            .border(.gray)
        }
    }
}

#Preview {
    @Previewable @State var items: [String] = ["Bob", "Peter", "Jack"]
    @Previewable @State var displayNoFlyZone: Bool = false
    @Previewable @State var noFlyAllowedZone: [NoFlyZoneData] = []

    SwipeToDeleteChildView(tag: 123,
                           displayNoFlyZone: $displayNoFlyZone,
                           noFlyAuthorizedZones: $noFlyAllowedZone,
                           items: $items)
}
