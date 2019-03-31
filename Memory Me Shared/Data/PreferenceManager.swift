//
//  PreferenceManager.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-20.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation

/**
 * Manager for the player preferences. The user preferences are saved and can
 * persist across app sessions.
 *
 * This class is using the UserDefaults library instead of saving it in an
 * archive. We'll see how it goes.
 */
class PreferenceManager
{
    static var current: PreferenceManager = PreferenceManager();
    
    func GetAllowsTracking() -> Bool
    {
        return UserDefaults.standard.bool(forKey: "allows_tracking");
    }
    
    func SetAllowsTracking(toValue value: Bool)
    {
        UserDefaults.standard.set(value, forKey: "allows_tracking");
    }
    
    func GetEnabledCheats() -> Bool
    {
        return UserDefaults.standard.bool(forKey: "enabled_cheats");
    }
    
    func SetEnabledCheats(toValue value: Bool)
    {
        UserDefaults.standard.set(value, forKey: "enabled_cheats");
    }
    
    func GetUseDebugLayer() -> Bool
    {
        return UserDefaults.standard.bool(forKey: "debug_layer");
    }
    
    func SetUseDebugLayer(toValue value: Bool)
    {
        UserDefaults.standard.set(value, forKey: "debug_layer");
    }
    
    func resetData()
    {
        UserDefaults.standard.set(false, forKey: "debug_layer");
        UserDefaults.standard.set(false, forKey: "enabled_cheats");
        UserDefaults.standard.set(true, forKey: "allows_tracking");
    }
}

// Shorthand methods below

func allowsTracking() -> Bool
{
    return PreferenceManager.current.GetAllowsTracking();
}

func useDebugLayer() -> Bool
{
    return PreferenceManager.current.GetUseDebugLayer();
}

func useCheats() -> Bool
{
    return PreferenceManager.current.GetEnabledCheats();
}
