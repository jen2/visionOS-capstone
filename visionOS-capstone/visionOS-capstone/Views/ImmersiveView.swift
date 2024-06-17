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

    @State private var smoke: Entity?
    @State private var ghostWhisper: Entity?
    @State private var audio: AudioFileResource?

    var body: some View {
        RealityView { content, attachments in
            // Initial RealityKit content
            if let scene = try? await Entity(
                named: Constants.immersiveViewEntityName,
                in: realityKitContentBundle
            ) {
                content.add(scene)

                // Sunlight
                guard let resource = try? await EnvironmentResource(
                    named: Constants.sunlightResourceName
                ) else { return }

                let iblComponent = ImageBasedLightComponent(
                    source: .single(resource),
                    intensityExponent: Constants.sunlightIntensity
                )
                scene.components.set(iblComponent)
                scene.components.set(ImageBasedLightReceiverComponent(imageBasedLight: scene))

                // Occluded floor
                let floor = ModelEntity(
                    mesh: .generatePlane(
                        width: Dimensions.floorSize,
                        depth: Dimensions.floorSize
                    ),
                    materials: [OcclusionMaterial()]
                )
                floor.generateCollisionShapes(recursive: false)
                floor.components[PhysicsBodyComponent.self] = .init(
                    massProperties: .default,
                    mode: .static
                )
                content.add(floor)

                // Add Attachments
                let pumpkins = PumpkinFactory.pumpkins
                for pumpkin in pumpkins {
                    addAttachment(with: content,
                                  attachments: attachments,
                                  entityName: "pedestal_\(pumpkin.pedestalNumber)")
                }

                // Audio
                ghostWhisper = content.entities.first?.findEntity(named: "SpatialAudio")
                audio = try? await AudioFileResource(
                    named: "/Root/spooky_sound",
                    from: "Immersive.usda",
                    in: realityKitContentBundle
                )

                // Smoke effect
                smoke = content.entities.first?.findEntity(named: "SmokeEmitter")
                smoke?.components.set(OpacityComponent(opacity: 0.0))
            }
        } update: { content, attachments in
            // Ghost animation
            if let ghostEntity = content.entities.first?.findEntity(named: Constants.ghostEntityName) {
                animateGhost(with: ghostEntity)
            }
        } attachments: {
            let pumpkins = PumpkinFactory.pumpkins
            Attachment(id: "pedestal_\(pumpkins[0].pedestalNumber)_attach") {
                VStack {
                    Text(pumpkins[0].name)
                        .font(.largeTitle)
                    Text(pumpkins[0].description)
                        .font(.title)
                }
                .padding(.all, Dimensions.attachmentPadding)
                .frame(maxWidth: Dimensions.attachmentMaxWidth, maxHeight: Dimensions.attachmentMaxHeight)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_\(pumpkins[1].pedestalNumber)_attach") {
                VStack {
                    Text(pumpkins[1].name)
                        .font(.largeTitle)
                    Text(pumpkins[1].description)
                        .font(.title)
                }
                .padding(.all, Dimensions.attachmentPadding)
                .frame(maxWidth: Dimensions.attachmentMaxWidth, maxHeight: Dimensions.attachmentMaxHeight)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_\(pumpkins[2].pedestalNumber)_attach") {
                VStack {
                    Text(pumpkins[2].name)
                        .font(.largeTitle)
                    Text(pumpkins[2].description)
                        .font(.title)
                }
                .padding(.all, Dimensions.attachmentPadding)
                .frame(maxWidth: Dimensions.attachmentMaxWidth, maxHeight: Dimensions.attachmentMaxHeight)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_\(pumpkins[3].pedestalNumber)_attach") {
                VStack {
                    Text(pumpkins[3].name)
                        .font(.largeTitle)
                    Text(pumpkins[3].description)
                        .font(.title)
                }
                .padding(.all, Dimensions.attachmentPadding)
                .frame(maxWidth: Dimensions.attachmentMaxWidth, maxHeight: Dimensions.attachmentMaxHeight)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_\(pumpkins[4].pedestalNumber)_attach") {
                VStack {
                    Text(pumpkins[4].name)
                        .font(.largeTitle)
                    Text(pumpkins[4].description)
                        .font(.title)
                }
                .padding(.all, Dimensions.attachmentPadding)
                .frame(maxWidth: Dimensions.attachmentMaxWidth, maxHeight: Dimensions.attachmentMaxHeight)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_\(pumpkins[5].pedestalNumber)_attach") {
                VStack {
                    Text(pumpkins[5].name)
                        .font(.largeTitle)
                    Text(pumpkins[5].description)
                        .font(.title)
                }
                .padding(.all, Dimensions.attachmentPadding)
                .frame(maxWidth: Dimensions.attachmentMaxWidth, maxHeight: Dimensions.attachmentMaxHeight)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_\(pumpkins[6].pedestalNumber)_attach") {
                VStack {
                    Text(pumpkins[6].name)
                        .font(.largeTitle)
                    Text(pumpkins[6].description)
                        .font(.title)
                }
                .padding(.all, Dimensions.attachmentPadding)
                .frame(maxWidth: Dimensions.attachmentMaxWidth, maxHeight: Dimensions.attachmentMaxHeight)
                .glassBackgroundEffect()
            }
        }
        .gesture(tapGesture)
    }
}

// MARK: - Private
extension ImmersiveView {
    private enum Constants {
        static let immersiveViewEntityName = "Immersive"
        static let ghostEntityName = "cute_ghost"
        static let sunlightResourceName = "Sunlight"
        static let sunlightIntensity: Float = 3.5
        static let orbitAnimationDuration = 3.0
    }

    private enum Dimensions {
        static let floorSize: Float = 100.0
        static let attachmentPadding: CGFloat = 20
        static let attachmentMaxWidth: CGFloat = 300
        static let attachmentMaxHeight: CGFloat = 500
    }

    private enum Positions {
        static let attachmentPosition: SIMD3<Float> = [0.05, 0.25, 0.11]
    }

    // MARK: Helpers
    private func animateGhost(with ghostEntity: Entity) {
        var transform = ghostEntity.transform
        transform.translation = SIMD3<Float>(x: 0.05, y: 0.5, z: -0.05)

        let orbit = OrbitAnimation(duration: Constants.orbitAnimationDuration,
                                   axis: SIMD3<Float>(x: .zero, y: 1.0, z: .zero),
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

    private func addAttachment(with content: RealityViewContent,
                               attachments: RealityViewAttachments,
                               entityName: String) {
        if let pedestal = content.entities.first?.findEntity(named: entityName) {
            if let pumpkinAttachment = attachments.entity(for: "\(entityName)_attach") {
                pumpkinAttachment.position = Positions.attachmentPosition
                pedestal.addChild(pumpkinAttachment)
            }
        }
    }

    private var tapGesture: some Gesture {
        TapGesture()
          .targetedToAnyEntity()
          .onEnded { value in
              // Show smoke
              smoke?.components.set(OpacityComponent(opacity: 1.0))

              // Trigger sound effect
              guard let audio else { return }
              if let audioPlaybackControl = ghostWhisper?.prepareAudio(audio) {
                  audioPlaybackControl.play()
              }
          }
      }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
