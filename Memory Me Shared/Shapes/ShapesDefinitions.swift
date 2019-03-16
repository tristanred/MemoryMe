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
    case NONE;
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
    ShapesKind.SQUARE: "Square_x64.png",
    ShapesKind.CIRCLE: "Circle_x64.png",
    ShapesKind.TRIANGLE: "Triangle_x64.png",
    ShapesKind.DIAMOND: "Diamond_x64.png"
];

/**
 128x128 shape assets
 */
let ShapeAssetsX128: [ShapesKind: String] =
[
    ShapesKind.SQUARE: "Square_x128.png",
    ShapesKind.CIRCLE: "Circle_x128.png",
    ShapesKind.TRIANGLE: "Triangle_x128.png",
    ShapesKind.DIAMOND: "Diamond_x128.png"
];

/**
 256x256 shape assets
 */
let ShapeAssetsX256: [ShapesKind: String] =
[
    ShapesKind.SQUARE: "Square_x256.png",
    ShapesKind.CIRCLE: "Circle_x256.png",
    ShapesKind.TRIANGLE: "Triangle_x256.png",
    ShapesKind.DIAMOND: "Diamond_x256.png"
];

/**
 512x512 shape assets
 */
let ShapeAssetsX512: [ShapesKind: String] =
[
    ShapesKind.SQUARE: "Square_x512.png",
    ShapesKind.CIRCLE: "Circle_x512.png",
    ShapesKind.TRIANGLE: "Triangle_x512.png",
    ShapesKind.DIAMOND: "Diamond_x512.png"
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
    ShapeTextureMap[ShapesKind.CIRCLE] = SKTexture(imageNamed: "Circle");
    ShapeTextureMap[ShapesKind.DIAMOND] = SKTexture(imageNamed: "Diamond");
    ShapeTextureMap[ShapesKind.SQUARE] = SKTexture(imageNamed: "Square");
    ShapeTextureMap[ShapesKind.TRIANGLE] = SKTexture(imageNamed: "Triangle");
}
