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
        RealityView { content in
            // Initial RealityKit content
            if let scene = try? await Entity(named: Constants.immersiveViewEntityName, in: realityKitContentBundle) {
                content.add(scene)

                // Sunlight
                guard let resource = try? await EnvironmentResource(named: Constants.sunlightResourceName) else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 3.5)
                scene.components.set(iblComponent)
                scene.components.set(ImageBasedLightReceiverComponent(imageBasedLight: scene))

                // Occuled floor
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
            }
        } update: { content in
            // Ghost animation
            if let ghostEntity = content.entities.first?.findEntity(named: Constants.ghostEntityName) {

                ghostEntity.orientation = simd_quatf(angle: Float.pi/4, axis: [0.0, 0.0, 0.0])

                var transform = ghostEntity.transform
                transform.translation = SIMD3<Float>(x: 0.05, y: 1.5, z: -0.05)
                ghostEntity.position.z = -400
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
