//
//  GridOrganizer.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-01.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import SpriteKit

enum AreaShape
{
    case Wide;
    case Square;
}

class GridSlot
{
    let area: CGRect;
    var shapeOnSlot: GameShape?;
    
    init(gridArea: CGRect)
    {
        self.area = gridArea;
        shapeOnSlot = nil;
    }
    
    func isOccupied() -> Bool
    {
        return shapeOnSlot != nil;
    }
}

let ratio: CGFloat = 1.2;

class GridOrganizer
{
    var areaType: AreaShape;
    
    var areaSize: CGRect;
    
    // Two separate columns or maybe use a CGSize
    var gridColumns: Int;
    var gridRows: Int;
    
    let keepAvailableFactor: CGFloat = 0.35; // Percentage of slots to keep free
    
    var gridPositions: [GridSlot];
    
    init(areaSize: CGRect)
    {
        self.areaSize = areaSize;
        
        // Setting the layout :
        /*
         Figure out if we are in a portrait/landscape device or something
         more square.
         */
        if(areaSize.getSizeRatio() > ratio)
        {
            areaType = .Wide;
            
            if(areaSize.height > areaSize.width)
            {
                gridColumns = 2;
                gridRows = 3;
            }
            else
            {
                gridColumns = 3;
                gridRows = 2;
            }
        }
        else
        {
            areaType = .Square;
            
            gridColumns = 3;
            gridRows = 3;
        }
        
        self.gridPositions = SplitRectangle(columns: gridColumns, rows: gridRows, area: areaSize)
            .map({ (rect) -> GridSlot in
                return GridSlot(gridArea: rect);
            });
    }
    
    func resizeGrid(withFrame frame: CGRect)
    {
        if  self.areaType == .Square && frame.getSizeRatio() > ratio ||
            self.areaType == .Wide && frame.getSizeRatio() <= ratio
        {
            self.shapeSizeChanged();
        }
        
        self.areaSize = frame;
        
        self.gridPositions = SplitRectangle(columns: gridColumns, rows: gridRows, area: areaSize)
            .map({ (rect) -> GridSlot in
                return GridSlot(gridArea: rect);
        });
    }
    
    func shapeSizeChanged()
    {
        if(self.areaSize.getSizeRatio() > ratio)
        {
            self.areaType = .Wide;
            
            if(areaSize.height > self.areaSize.width)
            {
                gridColumns = 2;
                gridRows = 3;
            }
            else
            {
                gridColumns = 3;
                gridRows = 2;
            }
        }
        else
        {
            self.areaType = .Square;
            
            gridColumns = 3;
            gridRows = 3;
        }

    }
    
    /**
     Return the number of free slots remaining in the grid.
    */
    func getAvailablePositionsCount() -> Int
    {
        return gridPositions.filter({ (rect) -> Bool in
            return rect.isOccupied() == false;
        }).count;
    }
    
    /**
     Insert a shape at a random available position. Returns the slot that was
     used if the insert was possible.
    */
    func placeShapeAtRandomPosition(shape: GameShape) -> GridSlot?
    {
        let freePosition = gridPositions.filter({(rect) -> Bool in
            return rect.isOccupied() == false;
        }).randomElement();
        
        freePosition?.shapeOnSlot = shape;
        
        shape.position.x = freePosition!.area.midX;
        shape.position.y = freePosition!.area.midY;
        
        return freePosition;
    }
    
    /**
     Get the amount of slots to keep free given the currentr grid size.
     For example, on a 6 slots grid (2x3) we should keep 2 slots free.
    */
    func getSlotsToKeepFreeCount() -> Int
    {
        return Int(floor((CGFloat(self.gridColumns * self.gridRows) * self.keepAvailableFactor)));
    }
    
    /**
     Get the GridSlot instance that contains the provided shape.
    */
    func getSlotOfShape(shape: GameShape) -> GridSlot?
    {
        return gridPositions.first(where: {(rect) -> Bool in
            return rect.shapeOnSlot === shape;
        });
    }
    
    /**
     Clear all shapes from the grid and return the instances that were removed
     so the caller can choose to remove them.
    */
    func clear() -> [GameShape]
    {
        let currentShapes = gridPositions
            .filter { (slot) -> Bool in
                return slot.isOccupied();
            }.map { (slot) -> GameShape in
                slot.shapeOnSlot!;
            };
        
        for pos in gridPositions
        {
            pos.shapeOnSlot = nil;
        }
        
        return currentShapes;
    }
}

/**
 Split a rectangle into multiple smaller, equivalent rectangles.
 */
func SplitRectangle(columns: Int, rows: Int, area: CGRect) -> [CGRect]
{
    var cellsCenterPoints = [CGRect]();
    
    // TODO : Handle margins + cell spacing
    var oneCellSize = CGSize();
    oneCellSize.width = area.width / CGFloat(columns);
    oneCellSize.height = area.height / CGFloat(rows);
    
    for col in 0..<columns
    {
        for row in 0..<rows
        {
            var cellPos = CGPoint();
            
            cellPos.x = oneCellSize.width * CGFloat(col);
            cellPos.y = oneCellSize.height * CGFloat(row);
            
            let cell = CGRect(origin: cellPos, size: oneCellSize);
            
            cellsCenterPoints.append(cell);
        }
    }
    
    return cellsCenterPoints;
}

/**
 Split a rectangle into multiple smaller, equivalent rectangles with padding
 in-between.
 */
func SplitRectangle(columns: Int, rows: Int, cellPadding: Int, area: CGRect) -> [CGRect]
{
    // TODO : Handle padding
    
    var cellsCenterPoints = [CGRect]();
    
    // TODO : Handle margins + cell spacing
    var oneCellSize = CGSize();
    oneCellSize.width = area.width / CGFloat(columns);
    oneCellSize.height = area.height / CGFloat(rows);
    
    for col in 0..<columns
    {
        for row in 0..<rows
        {
            var cellPos = CGPoint();
            
            cellPos.x = oneCellSize.width * CGFloat(col);
            cellPos.y = oneCellSize.height * CGFloat(row);
            
            let cell = CGRect(origin: cellPos, size: oneCellSize);
            
            cellsCenterPoints.append(cell);
        }
    }
    
    return cellsCenterPoints;
}

extension CGRect
{
    func getSizeRatio() -> CGFloat
    {
        if(self.height > self.width)
        {
            return self.height / self.width;
        }
        else
        {
            return self.width / self.height;
        }
    }
}
