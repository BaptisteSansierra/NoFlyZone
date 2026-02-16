//
//  ForcedActionView.swift
//  NoFlyZone
//
//  Created by baptiste sansierra on 16/2/26.
//

import SwiftUI
import NoFlyZone

struct ForcedActionView: View {
    
    enum Action: Int {
        case proceed
        case cancel
    }
    
    // NoFlyZone states
    @State private var displayNoFlyZone: Bool = true
    @State private var displayNoFlyZoneDebug: Bool = true
    @State private var noFlyAuthorizedZones: [NoFlyZoneData] = []
    // NoFly zones
    @State private var proceedButtonframe: CGRect = .zero
    @State private var cancelButtonframe: CGRect = .zero
    // Alerts flags
    @State private var showProceedAction = false
    @State private var showCancelAction = false
    // others
    @State private var warningTextOpacity: CGFloat = 0
    @State private var dummyStepperValue: Int = 0
    @State private var dummyToggleValue: Bool = false

    var body: some View {
        contentView
            .noFlyZone(enabled: displayNoFlyZone,
                       authorizedZones: noFlyAuthorizedZones,
                       onAllowed: onAllowed,
                       onBlocked: onBlocked,
                       coloredDebugOverlay: false)
            .onChange(of: proceedButtonframe) { _, _ in
                updateZones()
            }
            .onChange(of: proceedButtonframe) { _, _ in
                updateZones()
            }
            .alert("Proceed",
                   isPresented: $showProceedAction) {
                Button("Restart") {
                    displayNoFlyZone = true
                }
            }
           .alert("Cancel",
                  isPresented: $showCancelAction) {
               Button("Restart") {
                   displayNoFlyZone = true
               }
           }
    }

    private var contentView: some View {
        ZStack {
            VStack() {
                Text("Please tap an action at bottom")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 150)
                    .padding(.bottom)
                Text("All other controls are irresponsive")
                    .padding(.bottom, 40)
                Stepper("Dummy stepper value : \(dummyStepperValue)", value: $dummyStepperValue)
                    .padding()
                Toggle("Dummy toggle", isOn: $dummyToggleValue)
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                proceedButtonView
                cancelButtonView
                    .padding(.top)
                    .padding(.bottom, 150)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 260, height: 80)
                    .shadow(radius: 5)
                Text("Please select an action")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
            .opacity(warningTextOpacity)
        }
    }

    private var proceedButtonView: some View {
        Button("Proceed", role: .destructive) {
        }
        .buttonStyle(.bordered)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        proceedButtonframe = geo.frame(in: .global)
                    }
                    .onChange(of: geo.frame(in: .global)) { _, _ in
                        proceedButtonframe = geo.frame(in: .global)
                    }
            }
        )
    }
    
    private var cancelButtonView: some View {
        Button("Cancel") {
        }
        .buttonStyle(.bordered)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        cancelButtonframe = geo.frame(in: .global)
                    }
                    .onChange(of: geo.frame(in: .global)) { _, _ in
                        cancelButtonframe = geo.frame(in: .global)
                    }
            }
        )
    }
    
    // MARK: - private methods
    private func onAllowed(tappedZones: [NoFlyZoneData]) {
        guard tappedZones.count == 1 else {
            fatalError("Only one result expected here")
        }
        guard let action = Action(rawValue: tappedZones[0].itemId) else {
            fatalError("Undefined action \(tappedZones[0].itemId)")
        }
        switch action {
            case Action.proceed:
                showProceedAction = true
            case Action.cancel:
                showCancelAction = true
        }
    }

    private func onBlocked() {
        withAnimation(.easeIn, {
            warningTextOpacity = 1
        }, completion: {
            withAnimation(.easeOut.delay(1), {
                warningTextOpacity = 0
            })
        })
    }
    
    private func updateZones() {
        noFlyAuthorizedZones = [NoFlyZoneData(itemId: Action.proceed.rawValue,
                                              zone: proceedButtonframe),
                                NoFlyZoneData(itemId: Action.cancel.rawValue,
                                              zone: cancelButtonframe),
        ]
    }
}

#Preview {
    ForcedActionView()
}
