//
//  ImmersiveView.swift
//  visionOS-capstone
//
//  Created by Jen Sipila on 6/14/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Initial RealityKit content
            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(scene)

                // Sunlight
                guard let resource = try? await EnvironmentResource(named: "Sunlight") else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 3.5)
                scene.components.set(iblComponent)
                scene.components.set(ImageBasedLightReceiverComponent(imageBasedLight: scene))

            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
