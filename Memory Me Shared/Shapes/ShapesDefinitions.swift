//
//  ShapesDefinitions.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-02-21.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

enum ShapesKind
{
    case SQUARE;
    case CIRCLE;
    case TRIANGLE;
    case DIAMOND;
}

enum ShapeTextureSet
{
    case X64;
    case X128;
    case X256;
    case X512;
}

/**
 64x64 assets
 */
let ShapeAssetsX64: [ShapesKind: String] =
[
    ShapesKind.SQUARE: "1_Square_64.png",
    ShapesKind.CIRCLE: "0_Circle_64.png",
    ShapesKind.TRIANGLE: "3_Triangle_64.png",
    ShapesKind.DIAMOND: "2_Diamond_64.png"
];

/**
 128x128 shape assets
 */
let ShapeAssetsX128: [ShapesKind: String] =
[
    ShapesKind.SQUARE: "1_Square_128.png",
    ShapesKind.CIRCLE: "0_Circle_128.png",
    ShapesKind.TRIANGLE: "3_Triangle_128.png",
    ShapesKind.DIAMOND: "2_Diamond_128.png"
];

/**
 256x256 shape assets
 */
let ShapeAssetsX256: [ShapesKind: String] =
[
    ShapesKind.SQUARE: "1_Square_256.png",
    ShapesKind.CIRCLE: "0_Circle_256.png",
    ShapesKind.TRIANGLE: "3_Triangle_256.png",
    ShapesKind.DIAMOND: "2_Diamond_256.png"
];

/**
 512x512 shape assets
 */
let ShapeAssetsX512: [ShapesKind: String] =
[
    ShapesKind.SQUARE: "1_Square_512.png",
    ShapesKind.CIRCLE: "0_Circle_512.png",
    ShapesKind.TRIANGLE: "3_Triangle_512.png",
    ShapesKind.DIAMOND: "2_Diamond_512.png"
];

/**
 Map loaded with appropriate SKTextures for each shape. Each texture
 can then be used to create a Shape's sprite.
 */
var ShapeTextureMap: [ShapesKind: SKTexture] = [:];

/**
 Setup the ShapeTextureMap with built SKTextures instances
 
 @param set Reference dictionary, callers should use prebuilt dictionaries
 ShapeAssetsX64, ShapeAssetsX128, ShapeAssetsX256 or ShapeAssetsX512 depending
 on the scene's chosen resolution.
 */
func InitializeTextureMap(withTextureSet set: [ShapesKind: String])
{
    for i in set
    {
        ShapeTextureMap[i.key] = SKTexture(imageNamed: i.value);
    }
}
