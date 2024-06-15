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
    @State private var ghostEntity: Entity?

    var body: some View {
        RealityView { content, attachments in
            // Initial RealityKit content
            if let scene = try? await Entity(named: Constants.immersiveViewEntityName, in: realityKitContentBundle) {
                content.add(scene)

                // Sunlight
                guard let resource = try? await EnvironmentResource(named: Constants.sunlightResourceName) else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 3.5)
                scene.components.set(iblComponent)
                scene.components.set(ImageBasedLightReceiverComponent(imageBasedLight: scene))

                // Occluded floor
                let floor = ModelEntity(
                    mesh: .generatePlane(
                        width: 100,
                        depth: 100
                    ),
                    materials: [OcclusionMaterial()]
                )
                floor.generateCollisionShapes(recursive: false)
                floor.components[PhysicsBodyComponent.self] = .init(
                    massProperties: .default,
                    mode: .static
                )
                content.add(floor)

                // Attachments
                if let pedestal = content.entities.first?.findEntity(named: "pedestal_1") {
                    if let pumpkinAttachment = attachments.entity(for: "pedestal-1-attach") {
                        pumpkinAttachment.position = [0.05, 0.25, 0.11]
                        pedestal.addChild(pumpkinAttachment)
                    }
                }
            }
        } update: { content, attachments in
            // Ghost animation
            if let ghostEntity = content.entities.first?.findEntity(named: Constants.ghostEntityName) {

                var transform = ghostEntity.transform
                transform.translation = SIMD3<Float>(x: 0.05, y: 0.5, z: -0.05)

                let orbit = OrbitAnimation(duration: 3.0,
                                           axis: SIMD3<Float>(x: 0.0, y: 1.0, z: 0.0),
                                           startTransform: transform,
                                           spinClockwise: false,
                                           orientToPath: false,
                                           rotationCount: 1.0,
                                           bindTarget: .transform,
                                           repeatMode: .repeat)
                if let animation = try? AnimationResource.generate(with: orbit) {
                    ghostEntity.playAnimation(animation)
                }
            }
        } attachments: {
            Attachment(id: "pedestal-1-attach") {
                VStack {
                    Text("\"Baby Boo\" Pumpkin")
                        .font(.largeTitle)
                    Text("These ghostly white beauties are known for their long and distinct handles, typically a warm shade of green, along with their bright-white hue and excellent shape. This pumpkin is perfect for creating a decorative seasonal display with contrasting color.")
                        .font(.title)
                }
                .padding(.all, 20)
                .frame(maxWidth: 300, maxHeight: 500)
                .glassBackgroundEffect()
            }
        }
    }
}

// MARK: - Private
extension ImmersiveView {
    private enum Constants {
        static let immersiveViewEntityName = "Immersive"
        static let ghostEntityName = "cute_ghost"
        static let sunlightResourceName = "Sunlight"
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
