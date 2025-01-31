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

let ratio: CGFloat = 1.0;


/*
 Example Grid API
 
 - The grid does not touch the Scene object
 - Function to return the centerpoint of each cell
 
 let frame = 500x500
 let grid = GridOrganizer(frame);
 
 grid.addShape(square);
 grid.addShape(circle);
 
 grid.shuffle(); <-- Shuffle existing shapes
 
 grid.clear(); <--- Clear all shape data.
 */

class GridOrganizer
{
    var areaType: AreaShape;
    
    var areaSize: CGRect;
    
    // Two separate columns or maybe use a CGSize
    var gridColumns: Int;
    var gridRows: Int;
    
    // How much space in the grid we can use before growing up.
    let keepAvailableFactor: CGFloat = 0.75;
    
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
    
    /**
     Add a shape to a cell on the grid. Returns the cell that the shape was
     added to. Returns nil if the grid is full and the cell could not be added.
    */
    func addShape(shape: GameShape) -> GridSlot?
    {
        // Find a free cell and attach the shape to it
        for cell in self.gridPositions
        {
            if(cell.shapeOnSlot == nil)
            {
                cell.shapeOnSlot = shape;
                
                return cell;
            }
        }
        
        // Return nil if no free cells were found.
        logWarning(withMessage: "Was unable to find a free grid slot.", export: true);
        
        return nil;
    }
    
    /**
     Shuffle the attached shapes inside the grid's positions
    */
    func shuffleShapes()
    {
        // Grab all shapes currently on the screen before we reset
        let currentShapes: [GameShape] = self.gridPositions.filter { (slot) -> Bool in
                return slot.shapeOnSlot != nil;
            }.map { (slot) -> GameShape in
                slot.shapeOnSlot!;
        };
        
        // Reset the positions
        self.gridPositions.forEach { (slot) in
            slot.shapeOnSlot = nil;
        };
        
        // Set all the shapes on random positions
        let randomGridOrder = self.gridPositions.shuffled();
        
        for shape in currentShapes.enumerated()
        {
            randomGridOrder[shape.offset].shapeOnSlot = shape.element;
        }
        
        self.gridPositions = randomGridOrder;
    }
    
    /**
     Get the center position of each cell in the grid.
    */
    func getCellPositions() -> [CGPoint]
    {
        return self.gridPositions.map({ (slot) -> CGPoint in
            return CGPoint(x: slot.area.midX, y: slot.area.midY);
        });
    }
    
    /*
     Set the position of each shape inside their assigned grid cell.
    */
    func resetShapePositions()
    {
        for slot in self.gridPositions
        {
            slot.shapeOnSlot?.position = CGPoint(x: slot.area.midX, y: slot.area.midY);
        }
    }
    
    // --------------------------- OLD API BELOW ------------------------------
    
    /**
     Returns if the grid needs to grow additional rows/columns to accomodate
     more slots.
     
     Returns true if more than 75% of the grid will be filled by the given count
    */
    func gridMustGrow(amount: Int) -> Bool
    {
        let amount = CGFloat(amount);
        let count = CGFloat(gridPositions.count);
        
        return CGFloat(amount / count) >= keepAvailableFactor;
    }
    
    func growGrid()
    {
        self.gridColumns += 1;
        self.gridRows += 1;
    }
    
    /**
     Resize the grid to contain a new frame.
    */
    func onResize(withFrame frame: CGRect)
    {
        if  self.areaType == .Square && frame.getSizeRatio() > ratio ||
            self.areaType == .Wide && frame.getSizeRatio() <= ratio
        {
            self.shapeSizeChanged();
        }
        
        self.areaSize = frame;
        
        // Create the new grid partitions
        let newGridPositions = SplitRectangle(columns: gridColumns, rows: gridRows, area: areaSize)
            .map({ (rect) -> GridSlot in
                return GridSlot(gridArea: rect);
            });
        
        // Transfer all shapes of the old grid to the new grid at the same index
        // Both the new and the old grid are assumed to have the same amount of
        // slots.
        for currentSlot in self.gridPositions.enumerated()
        {
            newGridPositions[currentSlot.offset].shapeOnSlot = currentSlot.element.shapeOnSlot;
        }
        
        self.gridPositions = newGridPositions;
        
        self.resetShapePositions();
    }
    
    /**
     
    */
    func shapeSizeChanged()
    {
        if(self.areaSize.getSizeRatio() > ratio)
        {
            // In this case, we are going into a Widescreen ratio
            
            // Check if we are currently in Square ratio so, indicating a
            // change of shape from Square to Wide
            if(self.areaType == .Square)
            {
                swap(&gridColumns, &gridRows);
            }
            
            self.areaType = .Wide;
        }
        else
        {
            // In this case, we are going into a Square screen ration
            
            // Check we we are in Widescreen, indicating a switch from
            // Widescreen to Square
            
            if(self.areaType == .Wide)
            {
                swap(&gridRows, &gridColumns);
            }
            
            self.areaType = .Square;
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
     Get the amount of slots to keep free given the current grid size.
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
        
        self.gridPositions = SplitRectangle(columns: gridColumns, rows: gridRows, area: areaSize)
            .map({ (rect) -> GridSlot in
                return GridSlot(gridArea: rect);
            });
        
        for pos in gridPositions
        {
            pos.shapeOnSlot = nil;
        }
        
        return currentShapes;
    }
    
    func reset()
    {
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
        return self.width / self.height;
    }
}
