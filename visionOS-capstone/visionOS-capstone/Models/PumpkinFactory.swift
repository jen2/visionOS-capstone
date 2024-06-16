//
//  PumpkinInfo.swift
//  visionOS-capstone
//
//  Created by Jen Sipila on 6/16/24.
//

import Foundation

public struct PumpkinInfo {
    let name: String
    let description: String
    let pedestalNumber: Int
}

public struct PumpkinFactory {
    public static var pumpkins: [PumpkinInfo] {
        var pumpkins: [PumpkinInfo] = []

        pumpkins.append(PumpkinInfo(
            name: "\"Baby Boo\" Pumpkin",
            description: "These ghostly white beauties are known for their long and distinct handles, typically a warm shade of green, along with their bright-white hue and excellent shape. This pumpkin is perfect for creating a decorative seasonal display with contrasting color.",
            pedestalNumber: 1)
        )

        pumpkins.append(PumpkinInfo(
            name: "Gooseneck Gourd",
            description: "Native to northern Mexico and eastern North America, yellow-flowered gourds have been cultivated for a very long time. These gourds are primarily used as ornamentals. Many of the smaller fruits are naturally striped creating various shades of green and yellow.",
            pedestalNumber: 2)
        )

        pumpkins.append(PumpkinInfo(
            name: "Black Kat Pumpkin",
            description: "Black Kat pumpkins, also known as Midnight pumpkins, are dark green, classic-shaped pumpkins with deep ridges that are both edible and ornamental. They are produced by semi-bush plants and can weigh between 8 oz & 1 lb. The flesh is pale orange and sweet, making them ideal for pumpkin pie.",
            pedestalNumber: 3)
        )

        pumpkins.append(PumpkinInfo(
            name: "\"Jack-Be-Little\" Pumpkin",
            description: "Jack-Be-Little pumpkins are small, deep orange, and ribbed pumpkins that are easy to grow and can be used for decoration or eaten. They are a variety of Cucurbita pepo, which also includes summer squashes and small gourds.",
            pedestalNumber: 4)
        )

        pumpkins.append(PumpkinInfo(
            name: "Kabocha Squash",
            description: "Kabocha squash is a winter squash that originated in the Americas. It's a fruit that grows on bushes but is often eaten as a vegetable. Kabocha squash is usually round or oblate in shape, with a hard rind that can be dark green, gray, or reddish-orange, and yellow to orange flesh. Kabocha squash is often used in Japanese, Korean, and other cuisine.",
            pedestalNumber: 5)
        )

        pumpkins.append(PumpkinInfo(
            name: "\"Knucklehead\" Pumpkin",
            description: "Orange pumpkins with pimples, also known as warty pumpkins or knuckleheads, are a hybrid variety of pumpkin that can be bumpy and grotesque in appearance. The warts are caused by the pumpkin's high sugar content, which can crack the skin and lead to wart development.",
            pedestalNumber: 6)
        )

        pumpkins.append(PumpkinInfo(
            name: "\"Blue Doll\" Pumpkin",
            description: "Deeply ribbed, slightly flattened fruits are somewhat bumpy and hard-shelled with a cool greenish-blue gray color that is certain to add interest to fall displays. They weigh 20 to 24 pounds with sweet, deep-orange flesh that is fantastic for both cooking and baking.",
            pedestalNumber: 7)
        )

        return pumpkins
    }
}


