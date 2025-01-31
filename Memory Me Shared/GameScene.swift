//
//  GameScene.swift
//  Memory Me Shared
//
//  Created by Tristan Dube on 2019-01-03.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import SpriteKit

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

enum ScreenRatioType
{
    case SuperTall;
    case Tall;
    case Square;
}

class GameScene: SKScene
{
    // Scene size properties
    var initialWidth: CGFloat = 0;
    var initialHeight: CGFloat = 0;
    
    var Game: MemoryMeGame?;
    
    class func newGameScene() -> GameScene
    {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            logError(withMessage: "Failed to load GameScene.sks. Aborting", export: true);
            
            abort();
        }
        
        logTrace(withMessage: "Loaded Game Scene");
                
        let sceneSize = getSizeForRatio(size: getScreenSize());
        
        var orientationIsLandscape = false; // For debugging with Analytics
        if(isLandscapeSize(target: getScreenSize()))
        {
            orientationIsLandscape = true;
            
            scene.size.width = max(sceneSize.width, sceneSize.height);
            scene.size.height = min(sceneSize.width, sceneSize.height);
        }
        else
        {
            orientationIsLandscape = false;
            
            scene.size.width = min(sceneSize.width, sceneSize.height);
            scene.size.height = max(sceneSize.width, sceneSize.height);
        }
        
        logTrace(withMessage: "Scene initialized", andProperties: [
            "Scene Size":"(w: `\(scene.size.width), h: `\(scene.size.height)`)",
            "Screen Size":"(w: `\(sceneSize.width), h: `\(sceneSize.height)`)",
            "Screen Ratio": "\(sceneSize.width / sceneSize.height)",
            "Orientation": orientationIsLandscape ? "Landscape" : "Portrait"
            ], export: true);
        
        scene.initialWidth = scene.size.width;
        scene.initialHeight = scene.size.height;
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit;
        
        return scene;
    }
    
    func setUpScene()
    {
        logTrace(withMessage: "Setting up game components.");
        
        self.Game = MemoryMeGame(self, GetViewFrame());
        
        self.Game?.LoadTextures();
        self.Game?.StartNewGame();
    }
    
    override func didMove(to view: SKView)
    {
        self.setUpScene();
    }
    
    override func didChangeSize(_ oldSize: CGSize)
    {
        self.Game?.ResizeGame(withFrame: self.GetViewFrame());
        self.UpdateDebugInfo();
    }
    
    func changedOrientation(to size: CGSize)
    {
        let sceneSize = getSizeForRatio(size: size);
        
        if(isLandscapeSize(target: size))
        {
            logTrace(withMessage: "Layout changed", andProperties: ["New layout": "Landscape"])
            
            self.scene?.size.width = max(sceneSize.width, sceneSize.height);
            self.scene?.size.height = min(sceneSize.width, sceneSize.height);
        }
        else
        {
            logTrace(withMessage: "Layout changed", andProperties: ["New layout": "Portrait"])
            
            self.scene?.size.width = min(sceneSize.width, sceneSize.height);
            self.scene?.size.height = max(sceneSize.width, sceneSize.height);
        }
    }
    
    #if os(OSX)
    override func keyUp(with event: NSEvent)
    {
        if(event.keyCode == 49) // Spacebar
        {
            logTrace(withMessage: "Cheat triggered");
            
            self.Game?.debugKeyPressed();
        }
    }
    #endif
    
    /**
     * Get a rectangle corresponding to the size of the view.
     *
     * Returns a Zero rectangle if the view frame does not exist.
     */
    func GetViewFrame() -> CGRect
    {
        var r = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size);
        r = r.insetBy(dx: 0, dy: 20);
        
        return r;
    }
    
    func UpdateDebugInfo()
    {
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        self.Game?.Update();
    }
    
    func receiveUpdatedPreferences(_ vm: SettingsViewModel)
    {
        PreferenceManager.current.SetAllowsTracking(toValue: vm.enableTracking);
        PreferenceManager.current.SetEnabledCheats(toValue: vm.enableCheats);
        PreferenceManager.current.SetUseDebugLayer(toValue: vm.showDebugLayer);
        
        self.Game?.activateDebugLayer(state: vm.showDebugLayer);
    }
    
    func sendUserPreferences() -> SettingsViewModel
    {
        var vm = SettingsViewModel();
        vm.enableCheats = PreferenceManager.current.GetEnabledCheats();
        vm.enableTracking = PreferenceManager.current.GetAllowsTracking();
        vm.showDebugLayer = PreferenceManager.current.GetUseDebugLayer();
        
        return vm;
    }
    
    func deletePlayerData()
    {
        PreferenceManager.current.resetData();
        StatisticsManager.default.resetData();
        
        self.Game?.activateDebugLayer(state: PreferenceManager.current.GetUseDebugLayer());
    }
}

func isTallScreen(width: CGFloat, height: CGFloat) -> Bool
{
    if(width > height)
    {
        let ratio: CGFloat = width / height;
        
        if(ratio > 1.77)
        {
            return true;
        }
    }
    else
    {
        let ratio: CGFloat = height / width;
        
        if(ratio > 1.77)
        {
            return true;
        }
    }
    
    return false;
}

func isLandscapeSize(width: CGFloat, height: CGFloat) -> Bool
{
    return isLandscapeSize(target: CGSize(width: width, height: height));
}

func isLandscapeSize(target: CGSize) -> Bool
{
    return target.width > target.height;
}

func getScreenSize() -> CGSize
{
    #if os(iOS)
    return UIScreen.main.bounds.size;
    #endif
    #if os(OSX)
    return CGSize(width: 500, height: 500);
    #endif
}

func getSizeForRatio(size: CGSize) -> CGSize
{
    switch(getScreenRatioType(size: size))
    {
    case .SuperTall:
        return CGSize(width: 1125, height: 2436);
    case .Tall:
        return CGSize(width: 1242, height: 2208);
    case .Square:
        return CGSize(width: 2048 / 2, height: 2732 / 2);
    }
}

func getScreenRatioType(size: CGSize) -> ScreenRatioType
{
    let largest = max(size.width, size.height);
    let smallest = min(size.width, size.height);
    
    let ratio = largest / smallest;
    if(ratio > 2.0)
    {
        return .SuperTall;
    }
    else if(ratio > 1.7)
    {
        return .Tall;
    }
    else
    {
        return .Square;
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            self.Game?.ProcessClick(at: t.location(in: self));
        }
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene
{
    override func mouseUp(with event: NSEvent)
    {
        self.Game?.ProcessClick(at: event.location(in: self));
    }
}
#endif
