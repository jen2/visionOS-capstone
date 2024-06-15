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
                addAttachment(with: content,
                              attachments: attachments,
                              entityName: "pedestal_1")
                addAttachment(with: content,
                              attachments: attachments,
                              entityName: "pedestal_2")
                addAttachment(with: content,
                              attachments: attachments,
                              entityName: "pedestal_3")
                addAttachment(with: content,
                              attachments: attachments,
                              entityName: "pedestal_4")
                addAttachment(with: content,
                              attachments: attachments,
                              entityName: "pedestal_5")
                addAttachment(with: content,
                              attachments: attachments,
                              entityName: "pedestal_6")
                addAttachment(with: content,
                              attachments: attachments,
                              entityName: "pedestal_7")
            }
        } update: { content, attachments in
            // Ghost animation
            if let ghostEntity = content.entities.first?.findEntity(named: Constants.ghostEntityName) {
                animateGhost(with: ghostEntity)
            }
        } attachments: {
            Attachment(id: "pedestal_1_attach") {
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

            Attachment(id: "pedestal_2_attach") {
                VStack {
                    Text("Gooseneck Gourd")
                        .font(.largeTitle)
                    Text("Native to northern Mexico and eastern North America, yellow-flowered gourds have been cultivated for a very long time. These gourds are primarily used as ornamentals. Many of the smaller fruits are naturally striped creating various shades of green and yellow.")
                        .font(.title)
                }
                .padding(.all, 20)
                .frame(maxWidth: 300, maxHeight: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_3_attach") {
                VStack {
                    Text("Black Kat Pumpkins")
                        .font(.largeTitle)
                    Text("Black Kat pumpkins, also known as Midnight pumpkins, are dark green, classic-shaped pumpkins with deep ridges that are both edible and ornamental. They are produced by semi-bush plants and can weigh between 8 oz & 1 lb. The flesh is pale orange and sweet, making them ideal for pumpkin pie.")
                        .font(.title)
                }
                .padding(.all, 20)
                .frame(maxWidth: 300, maxHeight: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_4_attach") {
                VStack {
                    Text("\"Jack-Be-Little\" Pumpkins")
                        .font(.largeTitle)
                    Text("Jack-Be-Little pumpkins are small, deep orange, and ribbed pumpkins that are easy to grow and can be used for decoration or eaten. They are a variety of Cucurbita pepo, which also includes summer squashes and small gourds.")
                        .font(.title)
                }
                .padding(.all, 20)
                .frame(maxWidth: 300, maxHeight: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_5_attach") {
                VStack {
                    Text("Kabocha Squash")
                        .font(.largeTitle)
                    Text("Kabocha squash is a winter squash that originated in the Americas. It's a fruit that grows on bushes but is often eaten as a vegetable. Kabocha squash is usually round or oblate in shape, with a hard rind that can be dark green, gray, or reddish-orange, and yellow to orange flesh. Kabocha squash is often used in Japanese, Korean, and other cuisine.")
                        .font(.title)
                }
                .padding(.all, 20)
                .frame(maxWidth: 300, maxHeight: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_6_attach") {
                VStack {
                    Text("\"Knucklehead\" Pumpkins")
                        .font(.largeTitle)
                    Text("Orange pumpkins with pimples, also known as warty pumpkins or knuckleheads, are a hybrid variety of pumpkin that can be bumpy and grotesque in appearance. The warts are caused by the pumpkin's high sugar content, which can crack the skin and lead to wart development.")
                        .font(.title)
                }
                .padding(.all, 20)
                .frame(maxWidth: 300, maxHeight: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "pedestal_7_attach") {
                VStack {
                    Text("\"Blue Doll\" Pumpkins")
                        .font(.largeTitle)
                    Text("Deeply ribbed, slightly flattened fruits are somewhat bumpy and hard-shelled with a cool greenish-blue gray color that is certain to add interest to fall displays. They weigh 20 to 24 pounds with sweet, deep-orange flesh that is fantastic for both cooking and baking.")
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
        static let sunlightIntensity: Float = 3.5
        static let orbitAnimationDuration = 3.0
    }

    private enum Dimensions {
        static let floorSize: Float = 100.0
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
                pumpkinAttachment.position = [0.05, 0.25, 0.11]
                pedestal.addChild(pumpkinAttachment)
            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
