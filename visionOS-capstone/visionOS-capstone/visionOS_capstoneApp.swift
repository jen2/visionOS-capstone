//
//  visionOS_capstoneApp.swift
//  visionOS-capstone
//
//  Created by Jen Sipila on 6/14/24.
//

import SwiftUI

@main
struct visionOS_capstoneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
